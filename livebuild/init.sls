# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

live-build-package:
  pkg.installed:
    - pkgs:
      - live-build
{% set parent_directory = pget('livebuild:parent_directory', '') %}
{% if parent_directory %}
livebuild-parent-directory:
  file.directory:
    - name: {{ parent_directory }}

{% set images = pget('livebuild:images', {}) %}
{% for imgname in images %}
{% set imgdir = '%s/%s' % (parent_directory, imgname) %}
livebuild-image-config-directory-{{ imgname }}:
  file.directory:
    - name: {{ imgdir }}/config
    - makedirs: true
      
testfile-binary-{{ imgname }}:
  file.managed:
    - name: /tmp/testfile-{{ imgname }}.txt
    - source: salt://livebuild/files/config/binary
    - template: jinja
    - context:
        imgname: {{ imgname }}
{% endfor %}

{% endif %}

