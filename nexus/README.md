Launches a new instance of nexus3 oss on docker with an nginx reverse proxy to enable SSL.  Also launches a Harness delegate.

In addition to launching the containers, this script does the following:

* Bootstraps Nexus by disabling random password, requiring authentication, creating a docker repo, changing admin password
* Creates self signed certificates for us in reverse proxy
* Adds certificate to delegate trust store

This requires docker and powershell to be be installed.

See `run.sh` for the starting point.
