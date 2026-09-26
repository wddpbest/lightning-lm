#!/bin/bash
set -euo pipefail

script_path=$(realpath "$0")
dds_dir=$(dirname "$script_path")

if [ "${1:-}" = "--system-only" ]; then
    shift
    if [ "$EUID" -ne 0 ]; then
        echo "The system setup phase must run as root."
        exit 1
    fi
else
    if [ "$EUID" -eq 0 ]; then
        echo "Please run this script as a normal user, without sudo."
        exit 1
    fi

    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo is required to configure system services and sysctl settings."
        exit 1
    fi

    config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/lvins"
    mkdir -p "$config_dir"
    cp "$dds_dir"/cyclonedds_default.xml "$config_dir"/
    cp "$dds_dir"/cyclonedds_zenoh.xml "$config_dir"/
    cp "$dds_dir"/roudi_config.toml "$config_dir"/

    exec sudo -- "$script_path" --system-only "$@"
fi

echo "Setting up multicast interfaces for DDS..."

multicast_interfaces=("$@")
if [ "${#multicast_interfaces[@]}" -eq 0 ]; then
    multicast_interfaces=(lo)
fi

cp "$dds_dir"/multicast@.service /etc/systemd/system/
systemctl daemon-reload
for iface in "${multicast_interfaces[@]}"; do
    systemctl enable --now "multicast@${iface}.service"
done

echo "Multicast interfaces set up: ${multicast_interfaces[*]}"

echo "Setting up DDS..."

cp "$dds_dir"/10-cyclone-max.conf /etc/sysctl.d/
sysctl -p /etc/sysctl.d/10-cyclone-max.conf

echo "Done!"
