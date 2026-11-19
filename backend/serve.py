"""Start the Screenshot to Code backend on one dual-stack socket.

Railway's private network may use IPv6 and local tools use IPv4. Uvicorn's
"--host ::" is IPv6-only, so open one socket that accepts both and hand it over.
"""
import os
import socket
import sys

import uvicorn

sys.path.insert(0, "/app")

port = int(os.environ.get("PORT", "7001"))
sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.setsockopt(socket.IPPROTO_IPV6, socket.IPV6_V6ONLY, 0)
sock.bind(("::", port))
sock.set_inheritable(True)

config = uvicorn.Config(
    "main:app",
    proxy_headers=True,
    forwarded_allow_ips="*",
    ws_max_size=64 * 1024 * 1024,
)
print(f"Screenshot to Code backend listening on [::]:{port} (IPv4 and IPv6)", flush=True)
uvicorn.Server(config).run(sockets=[sock])
