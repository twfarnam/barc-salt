
ssh:
  service.running:
    - Reload: true
    - watch:
      - file: sshd_config

sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://sshd/config
    - template: jinja
    - user: root
    - group: root
    - mode: 644

