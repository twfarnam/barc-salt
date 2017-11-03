

flask packages:
  pkg.installed:
    - pkgs: 
      - uwsgi-core
      - uwsgi-plugin-python
      - python-pip

pip:
   require:
     - pkg.installed: python-pip

   pip.installed:
     - no_cache_dir: True
     - pkgs:
       - flask
       - tensorflow
       - uwsgi


