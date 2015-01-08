{% from "openssh/map.jinja" import openssh with context %}

openssh-server:
  {% if openssh.server is defined %}
  pkg.installed:
    - name: {{ openssh.server }}
  {% endif %}
  service.running:
    - enable: True
    - name: {{ openssh.service }}
  {% if openssh.server is defined %}
    - require:
      - pkg: {{ openssh.server }}
  {% endif %}
