# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

    
{% set shorewall = pget('shorewall:shorewall_package', 'shorewall') %}
shorewall-package:
  pkg.installed:
    - name: {{ shorewall }}

  
