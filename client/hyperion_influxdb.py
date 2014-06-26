#!/usr/bin/env python

# Copyright (C) 2014  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import argparse
import socket
import time

import influxdb
import psutil


def format_for_submission(name, values):
    points = [socket.getfqdn()]
    columns = ["host"]
    for field, value in zip(values._fields, values):
        points.append(value)
        columns.append(field)
    return {"points": [points],
            "name": name,
            "columns": columns}


def send_stats(client):
    interval = 1
    while True:
        start_time = time.time()
        data = []
        metrics = {"cpu_percent": psutil.cpu_times_percent,
                   "network_usage": psutil.net_io_counters}
        for name, fn in metrics.iteritems():
            raw_data = fn()
            data.append(format_for_submission(name, raw_data))
        print("Metrics: %s" % data)
        client.write_points(data)
        while (start_time + interval - time.time()) > 0:
            rest_duration = start_time + interval - time.time()
            time.sleep(rest_duration)


def parse_args():
    parser = argparse.ArgumentParser(description='Hyperion InfluxDB client.')
    parser.add_argument('--server',
                        type=str,
                        help=' The influxdb host to connect to, defaults to localhost',
                        default='localhost')
    parser.add_argument('--port',
                        type=int,
                        help='The influxdb port to connect to, defaults to 8086',
                        default=8086)
    parser.add_argument('--dbname',
                        type=str,
                        help='The influxdb database to connect to, defaults to hyperion-lite',
                        default='hyperion-lite')
    parser.add_argument('--username',
                        type=str,
                        help='The influxdb username, defaults to root',
                        default='root')
    parser.add_argument('--password',
                        type=str,
                        help='The influxdb password to connect to, defaults to root',
                        default='root')
    return parser.parse_args()


if __name__ == '__main__':
    args = parse_args()
    client = influxdb.InfluxDBClient(args.server,
                                     args.port,
                                     args.username,
                                     args.password,
                                     args.dbname)
    time.sleep(1)
    send_stats(client)
    # dbusers = client.get_database_users()
    # print("Get list of database users: {0}".format(dbusers))
