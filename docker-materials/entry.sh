#!/usr/bin/env bash

set -e

# This script is needed to get the permissions correct when copying files from a file system that is mounted in
# read-only mode by the iRODS CSI Driver. Simply doing a resursive copy causes the directory permissions to become
# corrupt, which prevents any access to the copied directories at all, for example:
#
# d????????? ? ? ? ?            ? data
# d????????? ? ? ? ?            ? notebooks
#
# I haven't been able to find a way to fix the problem after the copies have been made, and this only happens when
# the file system is mounted in read-only mode.

# Create the directory structure.
for d in $(find data/input/* -type d); do
    mkdir -p "work/${d#*/*/}"
done

# Copy the files.
for f in $(find data/input/* -type f); do
    cp $f "work/${f#*/*/}"
done

# Fix the permissions on the files.
find work -type f -exec chmod 0644 {} +



exec jupyter-lab --no-browser --ip=0.0.0.0 --LabApp.token="" --LabApp.password=""
