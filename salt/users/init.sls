

osgvo:
  group.present: []
  user.present:
    - shell: /bin/bash
    - home: /home/osgvo
    - remove_groups: False
    - groups:
      - osgvo
      - users


