# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

netboot-support-packages:
  pkg.installed:
    - pkgs:
      - debian-installer-7.0-netboot-amd64
      - debian-installer-7.0-netboot-i386
      - di-netboot-assistant
      

tftpd-parent-directory:
  file.directory:
    - name: {{ pget('tftpd:directory', '/srv/tftp') }}
    - user: {{ pget('tftpd:username', 'tftp') }}
    - group: {{ pget('tftpd:group', 'tftp') }}

tftpd-default-config:
  file.managed:
    - name: /etc/default/tftpd-hpa
    - source: salt://netboot/files/tftpd-hpa
    - template: jinja
      

      
tftpd-package:
  pkg.installed:
    - pkgs:
      - tftpd-hpa
    - requires:
      - pkg: netboot-support-packages
      - file: tftpd-parent-directory


        
         