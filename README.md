coreos-cluster-setup
====================

Example clould-config file to setup a CoreOS cluster

1. Start virtual machine and ssh into it

$ vagrant up
$ vagrant ssh

2. Build docker image and push it to registry

$ cd /Users/asc/Projects/frontendside/coreos-cluster-setup/drone
$ docker build -t arielschiavoni/drone .
$ docker login
$ docker push

3. Run a docker container with the previous image
- Make sure that you are exposing the proper ENV variables in docker.run.sh according to the
CVS that you want to connect to (Github, Stash, etc.). In our case we connect to Github and to do that
it is necessary to setup a new [application](https://github.com/settings/applications/149503) in Github.
Once we setup the app we have the DRONE_GITHUB_CLIENT and DRONE_GITHUB_SECRET necessary values.

$ docker pull arielschiavoni/drone
$ cd /Users/asc/Projects/frontendside/coreos-cluster-setup
$ ./docker.run.sh

4. Run ngrok tunnel to make docker ci service running in the VM visible to Github
- Open a new console on the host machine

$ ngrok -config=./ngrok.yml start ci

5. Open the url that ngrok shows and configure your repositories

6. Setup a .drone.yml file in your repo to configure the CI and push the changes.
