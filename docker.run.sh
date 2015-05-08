docker run -d --name="drone" \
  -e DRONE_GITHUB_CLIENT=YOUR_DRONE_GITHUB_CLIENT \
  -e DRONE_GITHUB_SECRET=YOUR_DRONE_GITHUB_SECRET \
  -p 8080:8080 \
  -v /var/lib/drone/ \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/asc/Projects/frontendside/coreos-cluster-setup/drone/drone.sqlite:/var/lib/drone/drone.sqlite \
  arielschiavoni/drone
