{% if 1 == salt['cmd.retcode']('test -x /usr/local/bin/s3fs') %}

include:
  - git.installed

s3fs-deps:
  pkg.installed:
    - names:
      - automake
      - fuse
      - fuse-devel
      - gcc-c++
      - libcurl
      - libcurl-devel
      - libxml2
      - libxml2-devel
      - openssl-devel

s3fs-code:
  git.latest:
    - name: https://github.com/s3fs-fuse/s3fs-fuse.git
    - target: /opt/code/s3fs-fuse
    - require:
      - pkg: git

run-autogen-s3fs-fuse:
  cmd.run:
    - name: sh ./autogen.sh
    - cwd: /opt/code/s3fs-fuse
    - stateful: False
    - require:
      - pkg: s3fs-deps

run-configure-s3fs-fuse:
  cmd.run:
    - name: ./configure
    - cwd: /opt/code/s3fs-fuse
    - stateful: False

run-make-s3fs-fuse:
  cmd.run:
    - name: make
    - cwd: /opt/code/s3fs-fuse
    - stateful: false

run-make-install-s3fs-fuse:
  cmd.run:
    - name: make install
    - cwd: /opt/code/s3fs-fuse
    - stateful: false

{% else %}

not-installing-s3fs-already-installed:
  test.nop

{% endif %}
