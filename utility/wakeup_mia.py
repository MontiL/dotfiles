#!/usr/bin/env python
# import socket
#
# s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# s.sendto("\xff" * 6 + "\x01\x23\x45\x67\x89\x0a" * 16, ("codecat3.local", 80))

from wakeonlan import send_magic_packet

send_magic_packet("8c:2d:aa:60:9d:27")
