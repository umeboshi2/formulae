# -*- mode: yaml -*-
{% set pget = salt['pillar.get'] %}

live-build-package:
  pkg.installed:
    - pkgs:
      - live-build

{% for imgname in ['default', 'foobar'] %}
{% image = pget('livebuild:images:%s' % imgname, {} %}
testfile-binary-{{ imgname }}:
  file.managed:
    - name: /tmp/testfile-{{ imgname }}.txt
    - source: salt://livebuild/files/config/binary
    - template: jinja
    - context:
        imgname: {{ imgname }}
{% endfor %}

