#!jinja|yaml

{% from "tools/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('tools:lookup')) %}

{% for t in salt['pillar.get']('tools:manage') %}
tool_{{ t.name }}:
  pkg:
    - installed
  {% if datamap.tools[t.name] is not defined or datamap.tools[t.name].pkgs is not defined %}
    - name: {{ t.name }}
  {% else %}
    - pkgs: {{ datamap.tools[t.name].pkgs }}
  {% endif %}
{% endfor %}
