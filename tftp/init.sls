{% from "tftp/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('tftp:lookup')) %}

tftp:
  pkg:
    - installed
    - pkgs:
{% for p in datamap['pkgs'] %}
      - {{ p }}
{% endfor %}
{% if datamap['daemon'] == False %}
  {# TODO: xinetd config for Redhat family, see https://github.com/theforeman/puppet-tftp/blob/master/manifests/config.pp #}
{% else %}
  service:
    - running
    - name: {{ datamap['servicename'] }}
{% endif %}
