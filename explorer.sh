#!/bin/bash

docker run -p 8000:8000 \
           -v "${PWD}"/kuzu_db:/database \
           --rm kuzudb/explorer:latest