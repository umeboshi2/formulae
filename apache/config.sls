# -*- mode: yaml -*-
{% if grains['os_family']=="Debian" %}

include:
  - apache

{% set aconf = salt['pillar.get']('apache:config', {}) %}
{% for conf in aconf %}
apache-config-file-{{ conf }}:
  file.managed:
    - name: /etc/apache2/conf-available/{{ conf }}.conf
    - source: {{ aconf[conf]['source'] }}
    {% if 'template' in aconf[conf] %}
    - template: {{ aconf[conf]['template'] }}
    {% endif %}
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-restart
    
{% if 'enable' in aconf[conf] and aconf[conf]['enable'] %}
apache-config-enable-{{ conf }}:
  cmd.run:
    - name: a2enconf {{ conf }}
    - unless: ls /etc/apache2/conf-enabled/{{ conf }}.conf
    - require:
      - pkg: apache
      - file: apache-config-file-{{ conf }}
    - watch_in:
      - module: apache-restart
{% elif 'enable' in aconf[conf] and not aconf[conf]['enable'] %}
apache-config-disable-{{ conf }}:
  cmd.run:
    - name: a2disconf {{ conf }}
    - onlyif: ls /etc/apache2/conf-enabled/{{ conf }}.conf
    - require:
      - pkg: apache
    - watch_in:
      - module: apache-restart
{% endif %}
{% endfor %}
{% endif %}
