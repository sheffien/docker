#!/bin/bash
#$(env | cut -f1 -d= | sed 's/^/-e /') \
container_name="$1"
docker_image="$2"
shift 2
cmd="$@"

echo "name: ${container_name} image: ${docker_image} cmd: ${cmd}"

dockerrv() {
  docker run -it `vols` $@
}

dockerrv \
  --name=${container_name} \
  --user=$(id -u) \
  --env="DISPLAY" \
  --volume /tmp:/tmp \
  --volume="/etc/group:/etc/group:ro" \
  --volume="/etc/passwd:/etc/passwd:ro" \
  --volume="/etc/shadow:/etc/shadow:ro"  \
  --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="${HOME}/.local/lib/R:/usr/local/lib/R/host-site-library" \
  --workdir="`pwd`" \
  ${docker_image} \
  ${cmd}
