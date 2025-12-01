#!/usr/bin/env bash
# system_info.sh
# Shows OS version, bash users, and open ports.

echo "========== OS / Distribution Information =========="
# Try lsb_release
if command -v lsb_release >/dev/null 2>&1; then
    lsb_release -a 2>/dev/null
    echo
fi

# /etc/os-release
if [ -f /etc/os-release ]; then
    echo "-> /etc/os-release"
    cat /etc/os-release
    echo
fi

echo "-> uname -a"
uname -a
echo

echo "========== Users with Bash Shell =========="
awk -F: '$7 ~ /bash/ { print $1 " (shell: " $7 ")" }' /etc/passwd
echo

echo "========== Open / Listening Ports =========="
# Prefer ss
if command -v ss >/dev/null 2>&1; then
    echo "-> ss -tuln"
    ss -tuln
# fallback netstat
elif command -v netstat >/dev/null 2>&1; then
    echo "-> netstat -tuln"
    netstat -tuln
# fallback lsof
elif command -v lsof >/dev/null 2>&1; then
    echo "-> lsof -i -P -n"
    lsof -i -P -n
else
    echo "No tools available to list ports (ss/netstat/lsof missing)"
fi
