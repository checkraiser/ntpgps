#!/bin/bash

RACK_ENV=test bundle exec rspec
RACK_ENV=test bundle exec spinach
