
condor:
  pkg: 
    - installed
    - require:
      - file: /etc/yum.repos.d/pegasus.repo
  service.running:
    - enable: True
    - watch:
      - file: /etc/condor/pool_password
      - file: /etc/condor/config.d/10-main.conf


/etc/condor/pool_password:
  file:
    - managed
    - user: root
    - mode: 600
    - source: salt://htcondor/pool_password

/etc/condor/config.d/10-main.conf:
  file:
    - managed
    - source: salt://htcondor/10-main.conf

/etc/condor/config.d/50-master.conf:
  file:
    - managed
    - source: salt://htcondor/50-master.conf


