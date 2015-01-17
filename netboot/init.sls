# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

include:
  - tftp
  

netboot-support-packages:
  pkg.installed:
    - pkgs:
      - debian-installer-7.0-netboot-amd64
      - debian-installer-7.0-netboot-i386


tftpd-parent-directory:
  file.directory:
    - name: {{ pget('tftpd:directory', '/var/lib/tftpboot') }}
    - user: {{ pget('tftpd:user', 'root') }}
    - group: {{ pget('tftpd:group', 'root') }}
      