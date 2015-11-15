{% from "supervisor/map.jinja" import supervisor with context %}

supervisor:
  pkg.installed:
    - name: {{ supervisor.server }}
  service.running:
    - name: {{ supervisor.service }}
    - enable: True
    - require:
      - pkg: supervisor
      
