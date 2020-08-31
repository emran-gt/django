#!/bin/bash
sed "s/tagVersion/$1/g" django.yaml > django-dev.yaml
