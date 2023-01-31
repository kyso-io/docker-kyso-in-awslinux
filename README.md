# Kyso-cli for awslinux

This repository contains scripts to configure and use the kyso-cli on an awslinux SO with docker containers. Check out [the documentation](https://docs.kyso.io/posting-to-kyso/kyso-command-line-tool/installation#docker) for more details.

# Usage

To install it just run the `awslinux-setup.sh` script as the `ec2-user`

1. **Download or clone** this repo into the EC2/Amazon Linux machine
2. **Execute** the following command

```shell
$ ./awslinux-setup.sh
```
* This will install docker on the EC2 machine
* And download the latest kyso cli docker image

3. **Check** that docker is properly installed executing the command "docker". You should see something like this:

```shell
$ docker

Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/home/ec2-user/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with
                           "docker context use")
[...]
```

4. **Check** that a new command `docker-kyso` is available for your user. Just run docker-kyso and you will see something like this:

```shell
$ sh bin/docker-kyso
Unable to find image 'kyso/kyso:latest' locally
latest: Pulling from kyso/kyso
2408cc74d12b: Pull complete
fdd104a55e88: Pull complete
58c2dfb7c32f: Pull complete
be08c352a798: Pull complete
f14d8c96429f: Pull complete
Digest: sha256:0d84989688486b31fd7b6b0ca9ea9a08a81362faf695660c1f8b82a480313cb2
Status: Downloaded newer image for kyso/kyso:latest
Kyso Client

VERSION
  kyso/1.13.1 linux-x64 node-v16.16.0

  [...]
```

Now you have kyso cli, using docker, ready to run. 

> 💡 PRO TIP. In fact, this tool installs `kyso` and `docker-kyso` commands, and both will use the docker image, so you can use both consistently. Just be careful if you have a previous installation of kyso cli, because in that case, depending on the import order in your $PATH, you will use the docker based one, or the previously installed kyso cli. In case of doubt, just use `docker-kyso`.

```shell
$ touch hello_kyso.ipynb
$ touch README.md
$ nano kyso.yaml
$ ls
hello_kyso.ipynb  kyso.yaml  README.md
$ docker-kyso login
? What is the url of your kyso installation? https://kyso.io
? Select a provider Access token
? What is your email? xxx@xxx.xx
? What is your access token (Get one from https://kyso.io/settings )? xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx
Logged successfully
$ docker-kyso push
Uploading report '.'
🎉🎉🎉 Report test xxxx to: https://kyso.io/xxx 🎉🎉🎉
```

# Troubleshooting

## Permission denied message appears

1. Check that your user has not permissions on docker

```shell
$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/images/json": dial unix /var/run/docker.sock: connect: permission denied
```

2. Execute the following command to grant permissions to your user (substitute "ec2-user" with the name of your user)

```shell
sudo setfacl --modify user:ec2-user:rw /var/run/docker.sock
```

3. Now your user will have access. Try again

## Can't use docker-kyso outside the $HOME folder

Per security, the `docker-kyso` command only has access to your user's directory ($HOME). That means, you can't use docker-kyso in folders like /tmp /usr, etc.
