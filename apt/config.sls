#!jinja|yaml

{% from "apt/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('apt:lookup')) %}

{% for k, v in salt['pillar.get']('apt:configs', {})|dictsort %}
aptconf_{{ k }}:
  file:
    - managed
    - name: {{ datamap.conf_dir|default('/etc/apt/apt.conf.d') }}/{{ k }}
    - mode: 644
    - user: root
    - group: root
    - contents_pillar: apt:configs:{{ k }}:content
{% endfor %}
