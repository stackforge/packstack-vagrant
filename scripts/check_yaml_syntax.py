#!/usr/bin/env python

import sys
import yaml

sys.tracebacklimit = 0
yaml.load(open("config.yaml.sample"))
