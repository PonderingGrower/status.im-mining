#!/usr/bin/python
import sys
import json
import socket
import statsd

"""
This script collects metrics from Geth by connecting
to it's IPC socket and using JSONRPC command to extract metrics.
Then converts them into a format ediblae by statsd and
pushes them via UDP to netdata(which implements statsd protocol).
"""

def recvall(s, bufsize=4096):
    """
    Makes sure the whole JSON is loaded.
    """
    data = b''
    while True:
        rval = s.recv(bufsize)
        data += rval
        if len(rval) < bufsize:
            break
    return data

def read_metrics(socket_path):
    """
    Loads metrics from Geth IPC socket using JSONRPC.
    """
    metrics_query = {
        "id": 0,
        "jsonrprc": "2.0",
        "method": "debug_metrics",
        "params": [True]
    }
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.connect(socket_path)
    s.send(json.dumps(metrics_query).encode('utf-8'))
    data = recvall(s)
    s.close()
    return data

def unpack(data, path=[]):
    """
    Unfolds JSON info list of paths and values.
    """
    rval = []
    if not isinstance(data, dict):
        return [('.'.join(path), data)]
    for key,val in data.iteritems():
        pair = unpack(val, path + [key])
        rval.extend(pair)
    return rval

# default configuration
statsd_host = 'localhost'
statsd_port = 8125
socket_path = '/home/miner/.ethereum/testnet/geth.ipc'

print('Connecting to Geth socket: {}'.format(socket_path))
data = read_metrics(socket_path)
metrics = json.loads(data)
rval = unpack(metrics['result'])
print('Metrics loaded: {}'.format(len(rval)))

sc = statsd.StatsClient(statsd_host, statsd_port, prefix='geth')
print('Connected to statsd on: {}:{}'.format(statsd_host, statsd_port))

for path, val in rval:
    #print('geth.{}:{}'.format(path, val))
    sc.gauge(path, val)

print('Metrics pushed to statsd server.')
