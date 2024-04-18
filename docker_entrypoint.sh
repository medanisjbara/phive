#!/bin/sh

# Set application key
php artisan key:generate

# Create tables using migration with dummy data
php artisan migrate:fresh --seed

# Run the app
php artisan serve --host 0.0.0.0

