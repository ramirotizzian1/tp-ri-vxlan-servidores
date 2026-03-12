
# Implementación de Red VXLAN con Seguridad Perimetral y Arquitectura Leaf-Spine

 ## Descripción del Proyecto
 
 Este proyecto documenta el diseño, la implementación y la validación de una infraestructura de red corporativa distribuida entre una Casa Central y una Sucursal. La arquitectura se basa en el modelo Spine-Leaf y utiliza paradigmas de Open Networking con el sistema operativo Cumulus Linux. El objetivo principal es integrar conceptos de enrutamiento dinámico y virtualización de red dentro de un entorno de simulación reproducible sobre GNS3, complementado con una estrategia robusta de seguridad perimetral. 

(---) 

## Arquitectura de Red

El diseño lógico se divide en tres niveles operativos principales: 


* Nivel de Núcleo (Spine): Centraliza el enrutamiento, actúa como gateway principal hacia Internet y simula la infraestructura de un ISP proveyendo conectividad de transporte (Underlay). 


* Nivel de Acceso y Distribución (Leafs): Ubicados en los extremos de la topología para gestionar la conectividad de última milla, encapsular el tráfico de redes privadas y aplicar políticas de seguridad en el borde. 


* Nivel de Aplicación: Entornos ligeros optimizados para ejecutar servicios (Web y DNS) y VPCs que representan a los clientes de la red.

---

## Tecnologías Utilizadas

* Simulador: GNS3. 
* Sistemas Operativos: Cumulus Linux (Open Networking), Alpine Linux (Contenedores ligeros).
* Protocolos y Servicios: OSPFv2, VXLAN (LNV), Nginx, Dnsmasq.
* Seguridad: Linux Netfilter (iptables) para Firewall y NAT.

![Arquitectura implementada en GNS3](images/imagen_pegada.png)

---

## Características Principales

### 1. Desacoplamiento de Red (Underlay y Overlay)
* Underlay IP: Orquestado mediante el protocolo de enrutamiento dinámico OSPFv2 en el Área 0 para asegurar conectividad entre interfaces Loopback. 
* Overlay VXLAN: Despliegue de túneles utilizando el mecanismo Lightweight Network Virtualization (LNV) para extender el dominio de difusión de Capa 2 a través de la red de Capa 3. 


### 2. Seguridad Perimetral Centralizada (Zero Trust)

* Firewall de Borde: Implementación de políticas de "Negación por Defecto" (DROP) en el nodo SPINE utilizando scripts de iptables. 
* Ofuscación ICMP: Configuración de una "trampa" que redirige los escaneos externos hacia destinos arbitrarios (Google) para mitigar el reconocimiento de la red. * Gestión NAT: Uso de SNAT (Masquerade) para salida a Internet y DNAT (Port Forwarding) para publicación segura de servicios hacia el exterior. 

### 3. Zona Desmilitarizada (DMZ) y Servicios
* Aislamiento Lógico: La DMZ se despliega en una VLAN dedicada, aislada de las redes de usuarios (Gerencia y Empleados) para mitigar movimientos laterales
* Servidor Web: Nginx configurado para alojar y servir el portal corporativo estático.
* DNS Híbrido: Implementación de Dnsmasq para resolución autoritativa local (Split-DNS) y forwarding recursivo hacia servidores públicos. 

---
## Validación y Pruebas
El correcto funcionamiento de la topología fue certificado mediante exhaustivas pruebas de conectividad y análisis de tráfico: 

* Análisis de Encapsulamiento: Verificación con Wireshark del transporte UDP 4789, diferenciando la cabecera externa (Underlay) y la cabecera interna (Overlay)

* Eficacia del Firewall: Pruebas exitosas de redirección ICMP, bloqueo de accesos administrativos (SSH) no autorizados y correcta resolución de reglas DNAT/SNAT. 

* Aislamiento de Segmentos: Comprobación de la inaccesibilidad intencional entre subredes de Gerencia y Empleados por ausencia de mapeo VNI. 

