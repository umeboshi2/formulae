# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

slapd-packages:
  pkg.installed:
    - pkgs:
      - slapd

      