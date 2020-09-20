# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

rubymine-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ rubymine.pkg.deps|json }}
    - require_in:
      - file: rubymine-package-archive-install

              {%- if rubymine.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ rubymine.dir.tmp }}/rubymine.exe
    - source: {{ rubymine.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ rubymine.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ rubymine.dir.tmp }}/rubymine.exe
    - require:
      - file: rubymine-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ rubymine.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: rubymine-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(rubymine.pkg.archive) }}
    - retry: {{ rubymine.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ rubymine.identity.rootuser }}
    - group: {{ rubymine.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: rubymine-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and rubymine.linux.altpriority|int == 0 %}

rubymine-archive-install-file-symlink-rubymine:
  file.symlink:
    - name: /usr/local/bin/{{ rubymine.command }}
    - target: {{ rubymine.dir.path }}/{{ rubymine.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: rubymine-package-archive-install

              {%- elif rubymine.flavour|lower == 'windowszip' %}

rubymine-archive-install-file-shortcut-rubymine:
  file.shortcut:
    - name: C:\Users\{{ rubymine.identity.rootuser }}\Desktop\{{ rubymine.dirname }}.lnk
    - target: {{ rubymine.dir.archive }}\{{ rubymine.dirname }}\{{ rubymine.command }}
    - working_dir: {{ rubymine.dir.archive }}\{{ rubymine.dirname }}\bin
    - icon_location: {{ rubymine.dir.archive }}\{{ rubymine.dirname }}\bin\rubymine.ico
    - makedirs: True
    - force: True
    - user: {{ rubymine.identity.rootuser }}
    - require:
      - archive: rubymine-package-archive-install

              {%- endif %}
