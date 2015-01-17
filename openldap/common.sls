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

ldap-utils-packages:
  pkg.installed:
    - pkgs:
      - ldap-utils

