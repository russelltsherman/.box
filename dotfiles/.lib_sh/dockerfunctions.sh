#!/usr/bin/env bash
# Bash wrappers for docker run commands

export DOCKER_REPO_PREFIX=jess

#
# Helper Functions
#
dcleanup(){
	local containers
	containers=( "$(docker ps -aq 2>/dev/null)" )
	docker rm "${containers[@]}" 2>/dev/null

  local volumes
	volumes=( "$(docker ps --filter status=exited -q 2>/dev/null)" )
	docker rm -v "${volumes[@]}" 2>/dev/null

  local images
	images=( "$(docker images --filter dangling=true -q 2>/dev/null)" )
	docker rmi "${images[@]}" 2>/dev/null
}

del_stopped(){
	local name="$1"
	local state
	state=$(docker inspect --format "{{.State.Running}}" "${name}" 2>/dev/null)

	if [[ "${state}" == "false" ]]; then
		docker rm "${name}"
	fi
}

relies_on(){
	for container in "$@"; do
		local state
		state=$(docker inspect --format "{{.State.Running}}" "${container}" 2>/dev/null)

		if [[ "${state}" == "false" ]] || [[ "${state}" == "" ]]; then
			echo "${container} is not running, starting it for you."
			${container}
		fi
	done
}

# creates an nginx config for a local route
nginx_config(){
	server="$1"
	route="$2"

	cat >"${HOME}/.nginx/conf.d/${server}.conf" <<-EOF
	upstream ${server} { server ${route}; }
	server {
		server_name ${server};

		location / {
			proxy_pass  http://${server};
			proxy_http_version 1.1;
			proxy_set_header Upgrade \$http_upgrade;
			proxy_set_header Connection "upgrade";
			proxy_set_header Host \$http_host;
			proxy_set_header X-Forwarded-Proto \$scheme;
			proxy_set_header X-Forwarded-For \$remote_addr;
			proxy_set_header X-Forwarded-Port \$server_port;
			proxy_set_header X-Request-Start \$msec;
		}
	}
	EOF

	# restart nginx
	docker restart nginx

	# add host to /etc/hosts
	hostess add "${server}" 127.0.0.1

	# open browser
	browser-exec "http://${server}"
}

alias notify-send=notify_send
notify_send(){
	relies_on notify_osd
	local args=${*:2}
	docker exec -i notify_osd notify-send "$1" "${args}"
}

###
### Awesome sauce by @jpetazzo
###
command_not_found_handle () {
	# Check if there is a container image with that name
	if ! docker inspect --format '{{ .Author }}' "$1" >&/dev/null ; then
		echo "$0: $1: command not found"
		return
	fi

	# Check that it's really the name of the image, not a prefix
	if docker inspect --format '{{ .Id }}' "$1" | grep -q "^$1" ; then
		echo "$0: $1: command not found"
		return
	fi

	docker run -ti -u "$(whoami)" -w "${HOME}" \
		"$(env | cut -d= -f1 | awk '{print "-e", $1}')" \
		--device /dev/snd \
		-v /etc/passwd:/etc/passwd:ro \
		-v /etc/group:/etc/group:ro \
		-v /etc/localtime:/etc/localtime:ro \
		-v /home:/home \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		"${DOCKER_REPO_PREFIX}/${1}" "$@"
}
