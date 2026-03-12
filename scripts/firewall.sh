#!/bin/bash
# Habilitar el reenvío de paquetes en el Kernel
sysctl -w net.ipv4.ip_forward=1

# Limpieza de reglas previas
iptables -F && iptables -t nat -F

# VARIABLES
IF_WAN="swp6"
IP_WEBSERVER="10.0.30.10"
IP_GOOGLE="142.250.78.195"

# TABLA NAT
# 1. DNAT Web (Acceso externo al servidor)
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination $IP_WEBSERVER

# 2. Trampa Ping (Redirección a Google)
iptables -t nat -A PREROUTING -i $IF_WAN -p icmp --icmp-type echo-request -j DNAT --to-destination $IP_GOOGLE

# 3. SNAT Salida (Internet para la LAN)
iptables -t nat -A POSTROUTING -o $IF_WAN -j MASQUERADE

# 4. SNAT Retorno (Asegura la respuesta del servidor web)
iptables -t nat -A POSTROUTING -d $IP_WEBSERVER -p tcp --dport 80 -j MASQUERADE

# TABLA FILTER
# Políticas restrictivas
iptables -P INPUT DROP
iptables -P FORWARD DROP

# Excepciones de Entrada (Para el Router)
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p ospf -j ACCEPT

# Excepciones de Paso (Tráfico de Usuarios/Servicios)
# Respuestas establecidas
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

# Tráfico Web DNATeado
iptables -A FORWARD -d $IP_WEBSERVER -p tcp --dport 80 -j ACCEPT

# Tráfico Ping DNATeado
iptables -A FORWARD -d $IP_GOOGLE -p icmp -j ACCEPT

# Salida de redes internas
iptables -A FORWARD -i swp1 -j ACCEPT
iptables -A FORWARD -i swp2 -j ACCEPT