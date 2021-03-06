#!/bin/bash

# Copyright 2015 Insight Data Science
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# check if Riak is installed
# if not, install it from the package manager

if [ -f /usr/sbin/riak ]; then
  echo "Riak installed."
else
  echo "Riak missing."
  echo "installing Riak ..."
  curl -s https://packagecloud.io/install/repositories/basho/riak/script.deb.sh | sudo bash
  sudo apt-get install riak=2.0.7-1
fi
