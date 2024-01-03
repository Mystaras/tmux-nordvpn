#!/usr/bin/env bash

NORD_INFO="$(nordvpn status)"
NORD_STATUS=$(echo "$NORD_INFO" | grep -oP 'Status: \K[^ ]+')

COLOR_RED='#[fg=red]'
COLOR_BLUE='#[fg=blue]'
COLOR_NONE='#[fg=default]'

CACHE_FILE=$(dirname "$0")/country_cache.txt

get_iso_code() {
    local country="$1"

    # Check if the country is in the cache
    if [ -f "$CACHE_FILE" ]; then
        iso_code=$(grep "^$country:" "$CACHE_FILE" | cut -d ':' -f 2)
        if [ -n "$iso_code" ]; then
            echo "$iso_code"
            return 0  # ISO code found in the cache
        fi
    fi

    # If not in cache, fetch from API
    iso_code=$(curl -s "https://restcountries.com/v2/name/$country" | jq -r '.[0].alpha2Code')

    if [ -n "$iso_code" ]; then
        # Cache the result
        echo "$country:$iso_code" >> "$CACHE_FILE"
        echo "$iso_code"
        return 0  # ISO code fetched from the API
    else
        echo '?'
    fi
}

iso_code=$(get_iso_code "$country")

if [ $NORD_STATUS == "Connected" ]; then
    NORD_IP=$(echo "$NORD_INFO" | grep -oP 'IP: \K[^ ]+')
    NORD_COUNTRY=$(echo "$NORD_INFO" | grep -oP 'Country: \K[^ ]+')
    NORD_CITY=$(echo "$NORD_INFO" | grep -oP 'City: \K[^ ]+')
    NORD_COUNTRY_CODE=$(get_iso_code "$NORD_COUNTRY")
    OUTPUT="${COLOR_BLUE}#[bold]${NORD_IP}#[nobold]${COLOR_NONE}${NORD_COUNRY} ${NORD_CITY}(#[bold]${NORD_COUNTRY_CODE}#[nobold])"
else
    OUTPUT="${COLOR_RED}NordVPN${COLOR_NONE}"
fi

echo "$OUTPUT"