#!/usr/bin/env bash

# A cross-platform utility to check internet status
# Licensed under MIT, (C) Alicia Sykes 2022
# Enhanced

# Colors and re-used string components
pre_general='\033[1;96m'
pre_success='  \033[1;92m✔'
pre_failure='  \033[1;91m✗'
post_string='\x1b[0m'

# Check if required commands exist
for cmd in curl ping grep awk; do
    command -v $cmd >/dev/null || { echo "Error: '$cmd' is required"; exit 1; }
done

# Check if the internet is reachable via HTTP
aio_http_host() {
    curl -s --head --max-time 5 https://github.com | head -n 1 | grep -E "200|301" >/dev/null
    [[ $? -ne 0 ]] && echo "Error: No active internet connection" >&2 && return 1
}

# Check if DNS is online
aio_check_dns() {
    (echo > /dev/tcp/1.1.1.1/53) &>/dev/null && \
        echo -e "${pre_success} DNS Online${post_string}" || \
        echo -e "${pre_failure} DNS Offline${post_string}"
}

# Check if we can ping the default gateway
aio_ping_gateway() {
    if [[ "$(uname)" == "Darwin" ]]; then
        GATEWAY=$(route -n get default 2>/dev/null | awk '/gateway/ {print $2}')
    else
        GATEWAY=$(ip r | awk '/default/ {print $3}' | head -1)
    fi

    if [[ -z "$GATEWAY" ]]; then
        echo -e "${pre_failure} No default gateway found${post_string}"
        return 1
    fi

    ping -q -c 1 "$GATEWAY" >/dev/null && \
        echo -e "${pre_success} Gateway Available${post_string}" || \
        echo -e "${pre_failure} Gateway Unavailable${post_string}"
}

# Checks if a given URL is accessible
aio_check_url() {
    local INTERNET_URL="${INTERNET_URL:-$1}"
    curl -Is "$INTERNET_URL" >/dev/null 2>&1 && \
        echo -e "${pre_success} Domains Accessible${post_string}" || \
        echo -e "${pre_failure} Domains Unaccessible${post_string}"
}

# Check if network interfaces are configured
aio_check_interfaces() {
    if [[ "$(uname)" == "Darwin" ]]; then
        INTERFACES=$(ifconfig | grep -E "^[a-z0-9]+" | awk '{print $1}' | grep -v "lo")
    else
        [[ -d /sys/class/net/ ]] && INTERFACES=$(ls /sys/class/net/ | grep -v lo)
    fi

    [[ -z "$INTERFACES" ]] && \
        echo -e "${pre_failure} No active network interfaces${post_string}" || \
        echo -e "${pre_success} Network Interfaces Configured${post_string}"
}

# Get public IP
aio_get_public_ip() {
    local IP=$(curl -s ifconfig.me)
    echo -e "${pre_success} Public IP: $IP${post_string}"
}

# Measure network latency
aio_latency_test() {
    local LATENCY=$(ping -c 3 8.8.8.8 | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    echo -e "${pre_success} Latency: ${LATENCY}ms${post_string}"
}

# Get Wi-Fi signal strength (macOS/Linux)
aio_wifi_signal() {
    if [[ "$(uname)" == "Darwin" ]]; then
        SIGNAL=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/agrCtlRSSI/ {print $2}')
    else
        SIGNAL=$(iwconfig 2>/dev/null | grep -i --color quality | awk '{print $2}')
    fi

    [[ -n "$SIGNAL" ]] && \
        echo -e "${pre_success} Wi-Fi Signal: $SIGNAL dBm${post_string}" || \
        echo -e "${pre_failure} Wi-Fi Signal: Unavailable${post_string}"
}

# Display help
aio_help() {
    echo -e "${pre_general}Utility for checking connectivity status${post_string}"
    echo -e "\e[0;96mUsage:${post_string}"
    echo -e "  \e[0;96m$ online${post_string}"
}

# Main function to check everything
aio_start() {
    if [[ $1 == "--help" ]]; then
        aio_help
        return
    fi
    line="${pre_general}─────────────────────────${post_string}"
    echo -e "$line"
    echo -e "${pre_general}📶 Checking connection...${post_string}"
    echo -e "$line"
    aio_check_dns
    aio_ping_gateway
    aio_check_url 'https://duck.com'
    aio_check_interfaces
    aio_get_public_ip
    aio_latency_test
    aio_wifi_signal
    echo -e "$line"
}

# Detect if script is sourced or executed directly
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    sourced=1
else
    sourced=0
fi

# Run or register aliases
if [[ $sourced -eq 0 ]]; then
    aio_start "$@"
else
    alias amionline=aio_start
    alias online=aio_start
    alias aio=aio_start
fi
