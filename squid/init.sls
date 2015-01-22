# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

squid-packages:
  pkg.installed:
    - pkgs:
      - squid3
