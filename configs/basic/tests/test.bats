#!/usr/bin/env bash

COMMENT=\#*
# can either: `dpkg -s $package_name`, or `apt-mark showinstall | grep -q "^$package_name" && echo "$package_name installed" || echo "not"

test_apt_installed() {
}

