# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class bigtop_toolchain::packages {
  case $operatingsystem{
  /(?i:(centos|fedora))/: { $pkgs = [ "unzip", "curl", "wget", "git",      "make", "cmake", "autoconf", "automake", "libtool", "gcc", "gcc-c++", "fuse", "createrepo", "lzo-devel",   "fuse-devel",  "cppunit-devel",    "openssl-devel",         "rpm-build" , "redhat-rpm-config", "fuse-libs" ] }
  /(?i:(SLES|opensuse))/: { $pkgs = [ "unzip", "curl", "wget", "git",      "make", "cmake", "autoconf", "automake", "libtool", "gcc", "gcc-c++", "fuse", "createrepo", "lzo-devel",   "fuse-devel",  "libcppunit-devel", "libopenssl-devel",      "rpm-devel", "pkg-config" ] }
  Amazon: { $pkgs = [ "unzip", "curl", "wget", "git",      "make", "cmake", "autoconf", "automake", "libtool", "gcc", "gcc-c++", "fuse", "createrepo", "lzo-devel",   "fuse-devel",    "openssl-devel",         "rpm-build" , "system-rpm-config", "fuse-libs" ] }
  Ubuntu: {                 $pkgs = [ "unzip", "curl", "wget", "git-core", "make", "cmake", "autoconf", "automake", "libtool", "gcc", "g++",     "fuse", "reprepro",   "liblzo2-dev", "libfuse-dev", "libcppunit-dev",   "libssl-dev",            "libzip-dev", "sharutils", "pkg-config", "debhelper", "devscripts", "protobuf-compiler", "build-essential", "dh-make", "libfuse2", "libssh-dev", "libjansi-java" ] 
      
    exec { "apt-update":
      command => "/usr/bin/apt-get update"
    }
    Exec["apt-update"] -> Package <| |>      
  }
}
  package { $pkgs:
    ensure => installed,
  }

  # Some bigtop packages use `/usr/lib/rpm/redhat` tools
  # from `redhat-rpm-config` package that doesn't exist on AmazonLinux.
  if $operatingsystem == 'Amazon' {
    file { '/usr/lib/rpm/redhat':
      ensure => 'link',
      target => '/usr/lib/rpm/amazon',
    }
  }
}
