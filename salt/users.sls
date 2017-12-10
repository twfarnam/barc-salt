
# user
deploy:
  group.present:
    - gid: 4001
    - system: True
  user.present:
    - shell: /bin/bash
    - home: /home/deploy
    - empty_password: True
    - uid: 4001
    - gid: 4001
    - groups:
      - sudo

/home/deploy/.vimrc:
  file.managed:
    - source: salt://vimrc
    - user: deploy
    - group: deploy
    - makedirs: True
    - mode: 600

# ~/tmp for vim swap files
/home/deploy/tmp:
  file.directory:
    - user: deploy
    - group: deploy
    - makedirs: True
    - mode: 770

# add ssh keys
/home/deploy/.ssh/authorized_keys:
  file.managed:
    - source: salt://authorized_keys
    - user: deploy
    - group: deploy
    - makedirs: True
    - mode: 600

# clean sudoers.d
/etc/sudoers.d:
  file.directory:
    - clean: True
    - exclude_pat: 'E@(README)|(sudo_group_no_password_sudo)|(google_sudoers)'

# Allow sudoers to sudo without passwords.
/etc/sudoers.d/sudo_group_no_password_sudo:
  file.managed:
    - contents: '%sudo ALL=(ALL) NOPASSWD:ALL'
    - user: root
    - group: root
    - mode: 440
    - require:
      - file: /etc/sudoers.d

