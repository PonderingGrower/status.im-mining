# Geth Syncing

Basic info can be extracted from JS console:
```bash
geth attach /home/miner/.ethereum/testnet/geth.ipc --exec eth.syncing
```

# Geth Syncing Progress

Neat function for estimating sync progress:
```javascript
var lastPercentage = 0, lastBlocksToGo = 0, timeInterval = 10000;
setInterval(function(){
    var percentage = eth.syncing.currentBlock/eth.syncing.highestBlock*100;
    var percentagePerTime = percentage - lastPercentage;
    var blocksToGo = eth.syncing.highestBlock - eth.syncing.currentBlock;
    var bps = (lastBlocksToGo - blocksToGo) / (timeInterval / 1000)
    var etas = 100 / percentagePerTime * (timeInterval / 1000)

    var etaM = parseInt(etas/60,10);
    console.log(parseInt(percentage,10)+'% ETA: '+etaM+' minutes @ '+bps+'bps');

    lastPercentage = percentage;lastBlocksToGo = blocksToGo;
},timeInterval);
```

# Fetching Geth Metrics

How to get metrics from geth IPC socket:
```bash
echo '{"id": 0, "jsonrprc": "2.0", "method": "debug_metrics", "params": [true]}' | nc -U ~/.ethereum/geth.ipc
```

# Geth Logs

```
/var/log/supervisor/geth-miner-stderr.log
/var/log/supervisor/geth-miner-stdout.log
```
