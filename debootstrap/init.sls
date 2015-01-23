include:
  - debootstrap.prereq

{% from 'state.jinja' import debootstrap_state %}

{% for id, data in salt['pillar.get']('debootstrap:chroots', {}).items() %}
{% do data.setdefault('id', id) %}
{{ debootstrap_state(data) }}
{% endfor %}
