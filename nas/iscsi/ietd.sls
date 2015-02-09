iscsitarget:
  pkg:
    - installed
    - require:
      - pkg: iscsitarget-dkms
  service:
    - running

iscsitarget-dkms:
  pkg.installed

/etc/iet/ietd.conf:
  file.managed:
    - source: salt://nas/iscsi/ietd.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - backup: .bak
    - require:
      - pkg: iscsitarget
    - watch_in:
      - service: iscsitarget

/etc/default/iscsitarget:
  file.managed:
    - source: salt://nas/iscsi/ietd-default
    - template: jinja
    - backup: .bak
    - require:
      - pkg: iscsitarget
    - watch_in:
      - service: iscsitarget
    