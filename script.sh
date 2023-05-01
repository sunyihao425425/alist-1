#!/bin/bash
touch /content/aria2/aria2.session
exec aria2c --conf-path=/content/aria2/aria2.conf &
exec ./alist server
