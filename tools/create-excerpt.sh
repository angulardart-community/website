#!/bin/env bash

set -eox pipefail

dart run build_runner build -o data/fragments
