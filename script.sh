#!/usr/bin/env bash

EMAIL="$1"
URL=${2:-"github:NixOS/nixpkgs?ref=master"}
gum spin --spinner dot --title "Querying $URL..." -- nixmeta --flakeref="$URL" -o /tmp/nixmeta.csv
csvsql /tmp/nixmeta.csv --query "select * from nixmeta where meta_maintainers_email LIKE '%$EMAIL%'" | gum table -p
rm /tmp/nixmeta.csv
