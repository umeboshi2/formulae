# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}
{% set default_realm = salt['grains.get']('domain').upper() %}
{% set mainrealm = pget('kerberos:mainrealm', default_realm) %}

kerberos-client packages:
  pkg.installed:
    - pkgs:
      - krb5-user
      - libpam-krb5
      - libsasl2-modules-gssapi-mit
