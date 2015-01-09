# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}
    
include:
  - network.interfaces
  - shorewall.base
  - shorewall.macros

{% if pget('shorewall:shorewall_package') == 'shorewall-init': %}
#https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=773392
restart-systemd-for-shorewall-install:
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
      - pkg: shorewall-package
        
# FIXME
# Shorewall is not a normal service, such as a running daemon, but
# a collection of iptable rules that is loaded in the kernel.
restart-shorewall:
  cmd.wait:
    - name: systemctl daemon-reload && /etc/init.d/shorewall restart
    - unless: shorewall status
    - requires:
      - pkg: shorewall-package
      - sls: network.interaces        
{% endif %}

/etc/default/shorewall:
  file.managed:
    - source: salt://shorewall/templates/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - requires:
      - pkg: shorewall-package
    - watch_in:
        - cmd: restart-shorewall

shorewall-main-config:
  file.managed:
    - name: /etc/shorewall/shorewall.conf
    - source: salt://shorewall/templates/shorewall.conf
    - template: jinja
    - user: root
    - group: staff
    - mode: 640
    - requires:
      - pkg: shorewall-package
    - watch_in:
        - cmd: restart-shorewall
    


{% set templates = ['interfaces', 'policy', 'rules', 'zones'] %}

{# choices are single, double, triple, or universal
# default is universal #}
{% set configtype = pget('shorewall:config_type', 'universal') %}

{% if configtype in ['double', 'triple']: %}
{% set templates = templates + ['Makefile', 'masq', 'routestopped'] %}
{% endif %}

{% for templ in templates: %}
shorewall_configfile_{{ templ }}:
  file.managed:
    - name: /etc/shorewall/{{ templ }}
    - source: salt://shorewall/templates/{{ configtype }}/{{ templ }}
    - template: jinja
    - user: root
    - group: staff
    - mode: 640
    - requires:
      - pkg: shorewall-package
    - watch_in:
        - cmd: restart-shorewall
{% endfor %}
      
