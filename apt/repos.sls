#!jinja|yaml

{% from "apt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('apt:lookup')) %}

{% set repos = salt['pillar.get']('apt:repos', {}) %}
{% for id, r in repos|dictsort %}
aptrepo_{{ r.name|default(id) }}:
  pkgrepo:
    - {{ r.ensure|default('managed') }}
    - name: {{ r.debtype|default('deb') }} {{ r.url }} {{ r.dist|default(salt['grains.get']('oscodename')) }}{% for c in r.comps|default(['main', 'contrib', 'non-free']) %} {{ c }}{% endfor %}
  {% if not r.globalfile|default(False) %}
    - file: {{ datamap.sources_dir|default('/etc/apt/sources.list.d') }}/{{ r.name|default(id) }}.list
  {% endif %}
  {% if 'keyuri' in r %}
    - key_url: {{ r.keyuri }}
  {% endif %}
{% endfor %}

