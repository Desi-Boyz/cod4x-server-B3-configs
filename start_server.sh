#!/bin/bash

set -ex

cd /home/ubuntu/cod4

./cod4x18_dedrun +exec server.cfg +exec maps.cfg +map_rotate +set sv_maxclients 38
