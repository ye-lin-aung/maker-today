#!/bin/bash

# Copy service to /etc/systemd/system
cp maker-today.service /etc/systemd/system/maker-today.service

# Copy maker.today to nginx sites-available
cp maker.today /etc/nginx/sites-available/maker.today

# Symlink to sites-enabled
ln -s /etc/nginx/sites-available/maker.today /etc/nginx/sites-enabled/
