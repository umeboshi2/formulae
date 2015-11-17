# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

include:
  - nginx.ng
  - supervisor
  - virtualenv
  

uwsgi-packages:
  pkg.installed:
    - pkgs:
      - uwsgi

devpi_user:
  user.present:
    - name: devpi
    - home: /var/lib/devpi

      
devpi_virtualenv:
  virtualenv.managed:
    - name: /var/lib/devpi/venv
    - user: devpi
    - requirements: salt://devpi/reqs.txt
    - require:
        - user: devpi_user
    

devpi_supervisor_config:
  file.managed:
    - name: /etc/supervisor/conf.d/devpi.conf
    - source: salt://devpi/supervisor.conf
    - template: mako
    - context:
        webservice: {{ wservice }}
    - require_in:
        - service: supervisor
    - watch_in:
        - service: supervisor
      
