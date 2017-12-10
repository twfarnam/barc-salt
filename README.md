

Install salt package repo (https://repo.saltstack.com/#ubuntu):

    wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
    sudo bash -c 'echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" > /etc/apt/sources.list.d/saltstack.list'
    sudo apt-get update
    sudo apt-get install salt-minion


Prepend to /etc/salt/minion:

    file_client: local
    id: barc
    file_roots:
      base:
        - /srv/saltstack/salt
    pillar_roots:
      base:
        - /srv/saltstack/pillar

Apply masterless salt:

    sudo salt-call --local state.apply


