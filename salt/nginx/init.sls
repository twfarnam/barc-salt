

nginx_repo:
  pkgrepo.managed:
    - ppa: nginx/stable

nginx:
  pkg:
    - installed
    - require:
      - pkgrepo: nginx_repo

restart_nginx:
  service.running:
    - name: nginx
    - Reload: true
    - require:
      - pkg: nginx
      - file: http
    - watch:
      - file: https

nginx clean:
  file.absent:
    - names:
      - /etc/nginx/sites-available

http:
  file.managed:
    - name: /etc/nginx/sites-enabled/http
    - source: salt://nginx/http
    - template: jinja
    - user: root
    - group: root
    - mode: 644

https:
  file.managed:
    - name: /etc/nginx/sites-enabled/https
    - source: salt://nginx/https
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: certbot



certbot:

  pkg:
    - name: git
    - installed

  git.latest:
    - name: https://github.com/certbot/certbot
    - target: /opt/certbot
    - user: root
    - unless: test -x /opt/certbot

  file.directory:
    - name: /var/www/lets-encrypt/.well-known/acme-challenge/
    - user: root
    - group: root
    - mode: 775
    - makedirs: True
    - unless: test -x /var/www/lets-encrypt/.well-known/acme-challenge

  cmd.run:
    - name: /opt/certbot/certbot-auto certonly -n --webroot -w /var/www/lets-encrypt --agree-tos --expand --email twfarnam@gmail.com -d barc.squids.online 
    - unless: test -x /etc/letsencrypt/live/barc.squids.online/

  cron.present:
    - name: /opt/certbot/certbot-auto renew && /etc/init.d/nginx reload
    - user: root
    - minute: 0
    - hour: 4
    - dayweek: 0


