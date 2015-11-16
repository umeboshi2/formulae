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

{% for key in pget('supervisor') %}
tmp_file_{{ key }}:
  file.managed:
    - name: /tmp/supervisor-key-{{ key }}
    - contents: {{ pget('supervisor.%s' % key) }}
{% endfor %}
      
{% set programs = pget('supervisor.programs', []) %}
{% for program in pget('supervisor.programs') %}
supervisor_program_file_{{ program }}:
  file.managed:
    - name: /tmp/{{ program }}.test
    #- contents: "hello there"
    - source: salt://supervisor/files/program-conf
{% endfor %}
