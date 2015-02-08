include:
{% if pillar.get('iscsi', {})['target'] == 'tgtd' %}
  - nas.iscsi.tgtd
{% endif %}
{% if pillar.get('iscsi', {})['target'] == 'ietd' %}
  - nas.iscsi.ietd
{% endif %}
