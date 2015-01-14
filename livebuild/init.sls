# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

live-build-package:
  pkg.installed:
    - pkgs:
      - live-build
      
