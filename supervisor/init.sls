# -*- mode: yaml -*-
{% from "supervisor/map.jinja" import supervisor with context %}
{% set pget = salt['pillar.get'] %}

supervisor:
  pkg.installed:
    - name: {{ supervisor.server }}
  service.running:
    - name: {{ supervisor.service }}
    - enable: True
    - require:
      - pkg: supervisor
      
supervisor_conf_file:
  file.managed:
    - name: /etc/supervisor/supervisord.conf
    - source: salt://supervisor/files/supervisord.conf
    - template: jinja
      