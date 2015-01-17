# -*- mode: yaml -*-
{%- set pget = salt['pillar.get'] -%}
{%- set domain = pget('openldap:slapd:domain', 'example.org') -%}
{%- macro make_basedn(domain) -%}
{%- set parts = domain.split('.') %}
{%- set newparts = [] -%}
{%- for part in parts %}
{%- do newparts.append('dc=%s' % part) %}
{%- endfor -%}
{{ newparts|join(',') }}
{%- endmacro %}
{% set basedn = make_basedn(domain) -%}

debconf-slapd:
  debconf.set:
    - name: slapd
    - data:
        #'slapd/backend': {'type': 'select', 'value': 'MDB'}
        'slapd/internal/adminpw': {'type': 'password', 'value': '{{ pget("openldap:slapd:adminpw", "changeme") }}'}
        'slapd/no_configuration': {'type': 'boolean', 'value': {{ pget('openldap:slapd:no_configuration', False) }}}
        'slapd/allow_ldap_v2': {'type': 'boolean', 'value': False}
        'slapd/domain': {'type': 'string', 'value': '{{ domain }}'}
        'slapd/custom_suffix': {'type': 'string', 'value', '{{ basedn }}'}
        'slapd/internal/dn': {'type': 'string', 'value', '{{ basedn }}'}
        'slapd/internal/admin': {'type': 'string', 'value', '^cn=admin,{{ basedn }}$'}
        'shared/organization': {'type': 'string', 'value', '{{ pget("openldap:organization", "organization") }}'}
        

ldap-utils-packages:
  pkg.installed:
    - pkgs:
      - ldap-utils

slapd-packages:
  pkg.installed:
    - requires:
      - debconf: debconf-slapd
    - pkgs:
      - slapd
      