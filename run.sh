#!/bin/bash

set -e

/root/setup.sh

exec /usr/sbin/sshd -D