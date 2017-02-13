/etc/salt/minion.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/salt/master.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/salt/minion.d/master.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://salt/master.conf

/etc/salt/minion.d/jetstream-osg.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://salt/jetstream-osg.conf

/etc/salt/master.d/jetstream-osg.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://salt/jetstream-osg.conf

/etc/cron.d/salt:
  file.managed:
    - source: salt://salt/cron.salt
    - user: root
    - group: root
    - mode: 644
    - template: jinja


