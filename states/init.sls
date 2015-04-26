#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('tools', saltenv) %}

# SLS includes/ excludes
include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}

{% for k, v in datamap.tools|dictsort if v.ensure|default('removed') == 'installed' %}
  {% set tool_name = v.name|default(k) %}
tool_{{ tool_name }}:
  pkg:
    - {{ v.ensure }}
  {% if v.pkgs|default([])|length > 0 %}
    - pkgs: {{ v.pkgs }}
  {% else %}
    - name: {{ tool_name }}
  {% endif %}
{% endfor %}
