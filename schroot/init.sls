include:
  - schroot.prereq

{% from 'state.jinja' import schroot_state_loop %}
{{ schroot_state_loop() }}
