

/etc/grid-security/certificates:
  file.symlink:
    - target: /cvmfs/oasis.opensciencegrid.org/mis/certificates
    - force: true
    - makedirs: true

