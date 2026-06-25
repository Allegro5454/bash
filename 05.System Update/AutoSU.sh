#!/bin/bash

tee /etc/systemd/system/update.timer << 'EOF'
[Unit]
Description=Automatic system update, launches once a week
[Timer]
OnCalendar=Mon *-*-* 00:00:00
Persistent=true
[Install]
WantedBy=timers.target
EOF
tee /etc/systemd/system/update.service << 'EOF'
[Unit]
Description=System Update

[Service]
Type=oneshot
ExecStart=/usr/local/bin/update.sh
EOF
tee /usr/local/bin/update.sh << 'EOF'
#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
DEBIAN_FRONTEND=noninteractive apt-get -y autoremove
EOF

chmod +x /usr/local/bin/update.sh

systemctl daemon-reload
systemctl enable --now update.timer
