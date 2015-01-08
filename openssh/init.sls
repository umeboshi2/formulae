# -*- mode: yaml -*-
{% from "openssh/map.jinja" import openssh with context %}
include:
  - openssh.client
  - openssh.server
  - openssh.config
  