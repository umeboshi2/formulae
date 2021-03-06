# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}
{% set default_realm = salt['grains.get']('domain').upper() %}
{% set mainrealm = pget('kerberos:mainrealm', default_realm) %}

krb5-config-file:
  file.managed:
    - name: /etc/krb5.conf
    - source: salt://kerberos/files/krb5.conf
    - template: jinja
      
kdc-config-file:
  file.managed:
    - name: /etc/krb5kdc/kdc.conf
    - source: salt://kerberos/files/kdc.conf
    - template: jinja
    - makedirs: true
      

touch-kadm5.acl:
  cmd.run:
    - name: touch /etc/krb5kdc/kadm5.acl
    - unless: test -r /etc/krb5kdc/kadm5.acl
      
/etc/krb5kdc/kadm5.acl:
  file.prepend:
    - requires:
      - cmd: touch-kadm5.acl
    - text:
      - '*/admin@{{ mainrealm }} *'

/tmp/addprincs.temp:
  file.absent:
    - name: /tmp/addprincs.temp
    
# add default princs
{% for princ in pget('kerberos:principals', []) %}
add-princ-{{ princ.name }}:
  cmd.run:
    - name: kadmin.local -q 'ank -pw {{ princ.password }} {{ princ.name }}'
    - unless: test -n "`kadmin.local -q listprincs | grep {{ princ.name }}`"
{% endfor %}

    
# read only filesystem?
kerberos-log-directory:
  file.directory:
    - name: /var/log/kerberos

#kerberos-password-stash:
#  file.managed:
#    - name: /etc/krb5kdc/.k5.{{ mainrealm }}
#    - contents: {{ pget('kerberos:masterdb_password', 'changeme') }}

kerberos-packages:
  pkg.installed:
    - pkgs:
      - krb5-admin-server
      - krb5-kdc
    - requires:
      - file: krb5-config-file
      - file: kdc-config-file
{% if pget('kerberos:install-kdc-ldap', False) %}
kdc-ldap-package:
  pkg.installed:
    - pkgs:
      - krb5-kdc-ldap
    - requires:
      - pkg: kerberos-packages
{% endif %}        
      
kerberos-create-db:
  cmd.run:
    - name: kdb5_util create -P {{ pget('kerberos:masterdb_password', 'changeme') }}
    - unless: test -r /var/lib/krb5kdc/principal
    - requires:
      - pkg: kerberos-packages

kerberos-kdc-create-stash:
  cmd.run:
    - name: kdb5_util stash -P {{ pget('kerberos:masterdb_password', 'changeme') }}
    - unless: test -r /etc/krb5kdc/stash
    - requires:
      - cmd: kerberos-create-db
        
kerberos-admin-service:
  service.running:
    - name: krb5-admin-server
    - requires:
      - pkg: kerberos-packages
    - watch:
      - file: krb5-config-file
      - file: kdc-config-file
        
kerberos-kdc-service:
  service.running:
    - name: krb5-kdc
    - requires:
      - pkg: kerberos-packages
    - watch:
      - file: krb5-config-file
      - file: kdc-config-file
        
