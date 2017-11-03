

nginx_repo:
  pkgrepo.managed:
    - ppa: nginx/stable


nginx:
  pkg:
    - installed
    - require:
      - pkgrepo: nginx_repo
  service.running:
    - Reload: true
    - watch:
      - pkg: nginx
      - file: http
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
  require:
    - cmd.run: certbot

  file.managed:
    - name: /etc/nginx/sites-enabled/https
    - source: salt://nginx/https
    - template: jinja
    - user: root
    - group: root
    - mode: 644


certbot:
  require:
    - service: nginx
    - file: http

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
    - name: /opt/certbot/certbot-auto certonly -n --webroot -w /var/www/lets-encrypt --agree-tos --expand --email twfarnam@gmail.com -d barc-service.tk
    - unless: test -x /etc/letsencrypt/live/barc-service.tk/
    - depends: nginx

  cron.present:
    - name: /opt/certbot/certbot-auto renew && /etc/init.d/nginx reload
    - user: root
    - minute: 0
    - hour: 4
    - dayweek: 0


