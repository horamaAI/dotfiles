#!/usr/bin/env bash

COMMENT=\#*
# can either: `dpkg -s $package_name`, or `apt-mark showinstall | grep -q "^$package_name" && echo "$package_name installed" || echo "not"

test_apt_installed() {
  # INSTALLED_APPS
  # for each pkg in associative array 'INSTALLED_APPS', do if 'command_for_test pkg', then returns/print OK/check; otherwise KO/cross
}

