{% from "openssh/map.jinja" import openssh with context %}

openssh_client:
  pkg.installed:
    - name: {{ openssh.client }}


ssh_config:
  file.managed:
    - name: {{ openssh.ssh_config }}
    - source: {{ openssh.ssh_config_src }}
    - template: jinja
    - user: root
    - mode: 644

