# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rubymine with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

rubymine-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/rubymine
      - {{ rubymine.dir.path }}

        {% if rubymine.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

rubymine-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: rubyminehome
    - path: {{ rubymine.dir.path }}
    - onlyif: update-alternatives --get-selections |grep ^rubyminehome


rubymine-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: rubymine
    - path: {{ rubymine.dir.path }}/{{ rubymine.command }}
    - onlyif: update-alternatives --get-selections |grep ^rubymine

        {%- else %}

rubymine-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (rubymine.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
