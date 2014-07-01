#!jinja|yaml

{% from "apt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('apt:lookup')) %}

{% for r in salt['pillar.get']('apt:repos', []) %}
aptrepo_{{ r.name }}:
  pkgrepo:
    - {{ r.ensure|default('managed') }}
    - name: {{ r.debtype|default('deb') }} {{ r.url }} {{ r.dist|default(salt['grains.get']('oscodename')) }}{% for c in r.comps|default(['main', 'contrib', 'non-free']) %} {{ c }}{% endfor %}
  {% if not r.globalfile|default(False) %}
    - file: {{ datamap.sources_dir|default('/etc/apt/sources.list.d') }}/{{ r.name }}.list
  {% endif %}
  {% if r.keyuri is defined %}
    - key_url: {{ r.keyuri }}
  {% endif %}
{% endfor %}

{% if datamap.remove_popularitycontest|default(False) %}
debian_pkg_popularity_contest:
  pkg:
    - name: popularity-contest
    - purged
{% endif %}

{% for k, v in salt['pillar.get']('apt:configs', {}).items() %}
aptconf_{{ k }}:
  file:
    - managed
    - name: {{ datamap.conf_dir|default('/etc/apt/apt.conf.d') }}/{{ k }}
    - mode: 644
    - user: root
    - group: root
    - contents_pillar: apt:configs:{{ k }}:content
{% endfor %}

{% for k, v in salt['pillar.get']('apt:preferences', {}).items() %}
aptpref_{{ k }}:
  file:
    - managed
    - name: {{ datamap.conf_dir|default('/etc/apt/preferences.d') }}/{{ k }}
    - mode: 644
    - user: root
    - group: root
    - contents_pillar: apt:preferences:{{ k }}:content
{% endfor %}
