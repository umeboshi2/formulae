{% from "nginx/map.jinja" import nginx with context %}

nginx:
  pkg.installed:
    - name: {{ nginx.server }}
  service.running:
    - name: {{ nginx.service }}
    - enable: True
    - require:
      - pkg: nginx
      
