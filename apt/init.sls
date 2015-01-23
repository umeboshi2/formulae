#!jinja|yaml

{% from "apt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('apt:lookup')) %}

include: {{ datamap.sls_include|default(['apt.config', 'apt.prefs', 'apt.repos']) }}
extend: {{ datamap.sls_extend|default({}) }}

{% if datamap.remove_popularitycontest|default(False) %}
debian_pkg_popularity_contest:
  pkg:
    - name: popularity-contest
    - purged
{% endif %}

{% if datamap.pkgs|length > 0 %}
aptpkgs:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}
{% endif %}
