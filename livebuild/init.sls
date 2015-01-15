# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

live-build-package:
  pkg.installed:
    - pkgs:
      - live-build

{% if pget('livebuild:parent_directory', '') %}
livebuild-parent-directory:
  file.directory:
    - name: {{ pget('livebuild:parent_directory') }}

{% set images = pget('livebuild:images', {}) %}
{% for imgname in images %}
testfile-binary-{{ imgname }}:
  file.managed:
    - name: /tmp/testfile-{{ imgname }}.txt
    - source: salt://livebuild/files/config/binary
    - template: jinja
    - context:
        imgname: {{ imgname }}
{% endfor %}

{% endif %}

