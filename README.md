# tp-ri-vxlan-servidores
# Implementación de Red Corporativa: VxLAN sobre Leaf-Spine con Seguridad Perimetral
Este proyecto documenta la implementación de una arquitectura de red moderna utilizando Cumulus Linux para simular una WAN corporativa. El diseño interconecta una Casa Central y una Sucursal remota mediante un túnel VxLAN sobre una capa física (Underlay) enrutada con OSPF.

Adicionalmente, se implementa una estrategia de Seguridad Perimetral (Firewall) avanzada utilizando iptables nativo, incluyendo redirección de tráfico (DNAT), publicación de servicios (Port Forwarding) y ofuscación de red (Trampa ICMP).

