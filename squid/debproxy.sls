# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}


dest-mirrors-config:
  file.managed:
    - name: /etc/squid-deb-proxy/mirror-dstdomain.acl.d/20-paella
    # FIXME: rename this to debproxy-mirrors (or better)
    - source: salt://squid/files/proxy-mirrors
    - template: jinja
    - makedirs: True
      
squid-deb-proxy-packages:
  pkg.installed:
    - pkgs:
      - squid-deb-proxy
    - fromrepo: wheezy-backports
    - require:
      - file: dest-mirrors-config

squid-deb-proxy-service:
  service.running:
    - name: squid-deb-proxy
    - require:
      - pkg: squid-deb-proxy-packages
    - watch:
      - file: dest-mirrors-config
        
