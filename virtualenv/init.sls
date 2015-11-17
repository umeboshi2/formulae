{% set pget = salt['pillar.get'] %}
{% set config = pget('virtualenv:config', {}) %}

python-virtualenv-packages:
  pkg.installed:
    - pkgs:
      - virtualenvwrapper
      
{% set parent = pget("virtualenv:system_virtualenv:path", "") %}
{% if parent %}
system_virtualenv_path:
  file.directory:
    - name: {{ parent }}
    - mode: {{ pget('virtualenv:system_virtualenv:dirmode', '0755') }}
    - group: {{ pget('virtualenv:system_virtualenv:group', 'root') }}
    - user: {{ pget('virtualenv:system_virtualenv:user', 'root') }}
{% endif %}      

{% for venv in pget('virtualenv:system_environments', []) %}
system_virtualenv_environment_{{ venv }}:
  file.managed:
    {% if 'name' not in venv %}
    - name: {{ parent }}/{{ venv }}
    {% endif %}
    {% for key in venv %}
    - {{ key }}: {{ venv[key] }}
    {% endfor %}
{% endfor %}

