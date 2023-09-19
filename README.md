# How to make a Sancho-Node Testnet Service (Using Port 6000)

## For DReps and Relay Nodes
### 1. Make the Service file and move it to your system folder (considering `snode` as the user and `tutorial` as the Home folder)
``` bash
cat > sancho-node.service << EOF
 [Unit]
Description       = Sancho node Service
After             = multi-user.target 

 [Service]
Type              = simple
Environment       = LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
Environment       = PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
Environment       = PATH="/home/tutorial/.local/bin/:$PATH"
ExecStart         = /home/tutorial/.local/bin/cardano-node run --config /home/tutorial/sancho-source/cardano-node/sanchotest/config.json --topology /home/tutorial/sancho-source/cardano-node/sanchotest/topology.json --database-path /home/tutorial/sancho-source/cardano-node/db/ --socket-path /home/tutorial/sancho-source/cardano-node/db/node.socket --host-addr 0.0.0.0 --port 6000


KillSignal        = SIGINT
RestartKillSignal = SIGINT
TimeoutStopSec    = 300
StandardOutput    = journal
StandardError     = journal
LimitNOFILE       = 32768
Restart           = on-failure
RestartSec        = 15
SyslogIdentifier  = sancho-node
User              = snode
Group             = tutorial

 [Install]
WantedBy          = multi-user.target
EOF
sudo mv sancho-node.service /etc/systemd/system
sudo chmod 644 sancho-node.service
```

### 2. Enable the Sancho Node Service:
```
sudo systemctl enable sancho-node.service
```

### 3. Start your Sancho Node Service
```
sudo systemctl start sancho-node.service
```

### 4. Check the logs if everything is working as expected
```
sudo journalctl --unit=sancho-node -f
```

## For Block Producing Node
### 1. Make the Service file and move it to your system folder (considering `snode` as the user, `tutorial` as the Home folder and `.sanchokeys` as the BP keys folder)
``` bash
cat > sancho-bp.service << EOF
 [Unit]
Description       = Sancho BPnode Service
After             = multi-user.target 

 [Service]
Type              = simple
Environment       = LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
Environment       = PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
Environment       = PATH="/home/tutorial/.local/bin/:$PATH"
ExecStart         = /home/tutorial/.local/bin/cardano-node run --config /home/tutorial/sancho-source/cardano-node/sanchotest/config.json --topology /home/tutorial/sancho-source/cardano-node/sanchotest/topology.json --database-path /home/tutorial/sancho-source/cardano-node/db/ --socket-path /home/tutorial/sancho-source/cardano-node/db/node.socket --host-addr 0.0.0.0 --port 6000 --shelley-kes-key /home/tutorial/.sanchockeys/kes.skey --shelley-vrf-key /home/tutorial/.sanchockeys/vrf.skey --shelley-operational-certificate /home/tutorial/.sanchockeys/node.cert


KillSignal        = SIGINT
RestartKillSignal = SIGINT
TimeoutStopSec    = 300
StandardOutput    = journal
StandardError     = journal
LimitNOFILE       = 32768
Restart           = on-failure
RestartSec        = 15
SyslogIdentifier  = bp-node
User              = snode
Group             = tutorial

 [Install]
WantedBy          = multi-user.target
EOF
sudo mv sancho-bp.service /etc/systemd/system
sudo chmod 644 sancho-bp.service
```

### 2. Enable the Sancho-BP Service:
```
sudo systemctl enable sancho-node.service
```

### 3. Start your Sancho-BP Service
```
sudo systemctl start sancho-node.service
```

### 4. Check the logs if everything is working as expected
```
sudo journalctl --unit=bp-node -f
```
