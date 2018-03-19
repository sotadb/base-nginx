#!/usr/bin/env sh
set -e

if [ "$1" == 'nginx' ]; then
	: #Add vars from ENV
fi

exec "$@"
