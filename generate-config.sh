#!/bin/env bash

rm -rf config
# Create directory where configs are stored
[ ! -d "config/west" ] && mkdir -p config/west
[ ! -d "config/east" ] && mkdir -p config/east

# Initnss
ipsec initnss --nssdir config/west
ipsec initnss --nssdir config/east

# Generate keys and store CKAIDs
WEST_CKAID=$(ipsec newhostkey --nssdir config/west \
  --output config/west/myvpn.secrets 2>&1 | awk -v FS="(CKAID | was)" '{print $2}')
EAST_CKAID=$(ipsec newhostkey --nssdir config/east \
  --output config/east/myvpn.secrets 2>&1 | awk -v FS="(CKAID | was)" '{print $2}')

# Store RSA SIG Keys
WEST_LEFT_RSASIGKEY=$(ipsec showhostkey --left --nssdir config/west  --verbose --ckaid $WEST_CKAID 2>&1 | grep -o "leftrsasigkey=.*")
EAST_RIGHT_RSASIGKEY=$(ipsec showhostkey --right --nssdir config/east  --verbose --ckaid $EAST_CKAID 2>&1 | grep -o "rightrsasigkey=.*")

# Create config files
cat <<EOF > config/west/host-to-host.conf
conn mytunnel
  leftid=@west.kti.pg.pl
  left=10.10.0.100
  $WEST_LEFT_RSASIGKEY
  rightid=@east.kti.pg.pl
  right=10.10.0.200
  $EAST_RIGHT_RSASIGKEY
  authby=rsasig
  # load and initiate automatically
  auto=start
EOF
cp config/west/host-to-host.conf config/east/host-to-host.conf
