# -*- mode: yaml -*-
{% if grains['os_family']=="Debian" %}

include:
  - apache

{% for conf in salt['pillar.get']('apache:config', {}) %}
apache-config-file-{{ conf }}:
  file.managed:
    - name: /etc/apache2/conf-available/{{ conf }}.conf
    - source: {{ conf.source }}
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-restart
    
{% if 'enable' in conf and conf.enable %}
apache-config-enable-{{ conf }}:
  cmd.run:
    - unless: ls /etc/apache2/conf-enabled/{{ conf }}.conf
    - require:
      - pkg: apache
      - file: apache-config-file-{{ conf }}
    - watch_in:
      - module: apache-restart
{% elif 'enable' in conf and not conf.enable %}
apache-config-disable-{{ conf }}:
  cmd.run:
    - onlyif: ls /etc/apache2/conf-enabled/{{ conf }}.conf
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-restart
{% endif %}
