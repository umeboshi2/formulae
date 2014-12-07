apt:
  lookup:
    remove_popularitycontest: True
  repos:
    - name: os
      url: http://http.debian.net/debian/
      globalfile: True
    - name: security
      url: http://security.debian.org/
      dist: {{ salt['grains.get']('oscodename') }}/updates
      globalfile: True
    - name: backports
      url: http://http.debian.net/debian/
      dist: {{ salt['grains.get']('oscodename') }}-backports
      globalfile: True
    - name: updates
      url: http://http.debian.net/debian/
      dist: {{ salt['grains.get']('oscodename') }}-updates
      globalfile: True
    - name: os_ftp
      ensure: absent
      url: http://ftp.debian.org:80/debian/
      comps:
        - non-free
        - contrib
        - main
    - name: os_src_ftp
      ensure: absent
      debtype: deb-src
      url: http://ftp.debian.org:80/debian/
      comps:
        - non-free
        - contrib
        - main
    - name: security_src_ftp
      ensure: absent
      debtype: deb-src
      url: http://security.debian.org/
      dist: wheezy/updates
      comps:
        - non-free
        - contrib
        - main
  configs:
    999custom:
      content: |
        APT::Install-Recommends "0";
        APT::Install-Suggests "0";
  preferences:
    999custom:
      content: |
        Package: python-requests python-zmq python-urllib3
        Pin: release a=wheezy-backports
        Pin-Priority: 1000
