rbenv-deps:
  pkg.installed:
    - names:
      - bzip2
      - gcc
      - openssl-devel
      - readline-devel
      - zlib-devel

ruby-2.3.0:
  rbenv.installed:
    - default: True
    - user: apache
    - require:
      - pkg: rbenv-deps

create-rbenv-global-profile:
  file.managed:
    - name: /home/apache/.profile
    - user: apache
    - group: apache
    - mode: 660

configure-rbenv-profile:
  file.append:
    - name: /home/apache/.profile
    - text: export PATH="~/.rbenv/bin:$PATH"
    - require:
      - rbenv: ruby-2.3.0

export-rbenv-profile:
  file.append:
    - name: /home/apache/.profile
    - text: export RBENV_ROOT=~/.rbenv
    - require:
      - rbenv: ruby-2.3.0

init-rbenv-profile:
  file.append:
    - name: /home/apache/.profile
    - text: eval "$(rbenv init -)"

bundle:
  gem.installed:
    - user: apache
    - ruby: 2.3.0
    - require:
      - rbenv: ruby-2.3.0