{% from "nginx/map.jinja" import nginx with context %}

nginx:
  pkg.installed:
    - name: {{ nginx.server }}
  service.running:
    - name: {{ samba.service }}
    - enable: True
    - require:
      - pkg: nginx
      
