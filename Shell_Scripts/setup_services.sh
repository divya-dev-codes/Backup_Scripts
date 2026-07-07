#!/bin/bash

# Check if Nomad service file is present
if [ -f /etc/systemd/system/nomad.service ]; then
  echo "Nomad service file found."
else
  echo "Error: Nomad service file not found."
  exit 1
fi

# Check if systemd-resolved service file is present
if [ -f /etc/nomad.s/nomad.hcl ]; then
  echo "nomad.hcl file found."
else
  echo "Error: nomad.hcl file not found."
  exit 1
fi

# Reload systemd daemon
sudo systemctl daemon-reload
sleep 5

# Start and enable Nomad service
sudo systemctl start nomad
sudo systemctl enable nomad
sleep 5

# Restart systemd-resolved service
sudo systemctl restart systemd-resolved
sleep 5

# Run resolvectl command
sudo resolvectl domain
sleep 5

echo "Services have been successfully started and enabled."