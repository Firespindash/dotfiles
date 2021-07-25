#!/bin/bash

find . -maxdepth 1 -type f -name "*-matrix.svg" | sed -e 'p' -E -e "s/-matrix/-mold/g" | xargs -n2 mv
