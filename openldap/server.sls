# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

debconf-slapd:
  debconf.set:
    - name: slapd
    - data:
        'slapd/internal/adminpw': {'type': 'password', 'value': '{{ pget("openldap:slapd:adminpw", "changeme") }}'}
        'slapd/no_configuration': {'type': 'boolean', 'value': False}
        'slapd/backend': {'type': 'select', 'value': 'MDB'}
        'slapd/allow_ldap_v2': {'type': 'boolean', 'value': 'false'}
        'slapd/domain': {'type': 'string', 'value': '{{ pget("openldap:slapd:domain", "example.org") }}'}
        


slapd-packages:
  pkg.installed:
    - requires:
      - debconf: debconf-slapd
    - pkgs:
      - slapd
      