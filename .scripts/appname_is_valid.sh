#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

appname_is_valid() {
    local AppName=${1-}
    if [[ ${AppName-} == *":" ]]; then
        AppName="${AppName%:*}"
    elif [[ ${AppName-} == ":"* ]]; then
        AppName="${AppName#:*}"
    fi
    if [[ ${AppName} =~ ^[a-zA-Z][a-zA-Z0-9]*(__[a-zA-Z0-9]+)?$ ]]; then
        local -a InvalidInstanceNames=(
            CONTAINER
            DEVICE
            DEVICES
            ENABLED
            ENVIRONMENT
            HOSTNAME
            PORT
            NETWORK
            RESTART
            STORAGE
            STORAGE2
            STORAGE3
            STORAGE4
            TAG
        )
        local InvalidInstanceNamesRegex
        {
            IFS='|'
            InvalidInstanceNamesRegex="${InvalidInstanceNames[*]}"
        }
        local InstanceName
        InstanceName="$(run_script 'appname_to_instancename' "${AppName}")"
        [[ ! ${InstanceName^^} =~ ${InvalidInstanceNamesRegex} ]]
        return
    fi
    false
    return
}

test_appname_is_valid() {
    for AppName in SONARR Sonarr SONARR_4K SONARR__4K "SONARR 4K" "SONARR:" SONARR__TAG; do
        if run_script 'appname_is_valid' "${AppName}"; then
            notice "[${AppName}] is valid"
        else
            notice "[${AppName}] is not valid"
        fi
    done
}
