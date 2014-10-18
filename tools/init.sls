#!jinja|yaml

{% from "tools/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('tools:lookup')) %}

{% for k, v in salt['pillar.get']('tools:manage', {})|dictsort %}
  {% set tool_name = v.name|default(k) %}
tool_{{ tool_name }}:
  pkg:
    - installed
  {% if datamap.tools[tool_name] is not defined or datamap.tools[tool_name].pkgs is not defined %}
    - name: {{ tool_name }}
  {% else %}
    - pkgs: {{ datamap.tools[tool_name].pkgs }}
  {% endif %}
{% endfor %}
