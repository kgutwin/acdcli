# sedlund/acdcli

Alpine Linux base with [acd_cli](https://github.com/yadayada/acd_cli) and fuse installed

## usage opportunities

### Pass your docker hosts local directory where your acd_cli oauth files are and run a listing

* `--entrypoint` tells docker what to command run.  The normal command arguments are passed to it.  This is a good line to wrap in a script

----
    docker run -it --rm -v /home/ubuntu/.cache/acd_cli:/root/.cache/acd_cli --entrypoint=/usr/bin/acdcli sedlund/acdcli:1.0 ls

### Create a data volume that will contain your oauth, and other acd_cli files
    docker run -d --name acdcli-data -v /root/.cache/acd_cli tianon/true

### Generate a oauth token in that container

* This will start an elinks terminal for you to authorize the connection and create your token

----
    docker run -it --rm --volumes-from acdcli-data sedlund/acdcli acd_cli init

### Copy existing token inside the data container
    docker cp ~/.cache/acd_cli acdcli-data:/root/.cache

### Mounting via fuse inside the container
* `--privileged` is required to use the docker hosts /dev/fuse for mounting
* `sh -c "acdcli -v mount; sh"` shows how to run a command that would fork (causing the container to exit), and running sh to keep it running

**NOTE** you cannot export a fuse mount as a volume from the container.  Check out `sedlund/acdcli-webdav` (based on this image) to mount ACD and provide a secure webdav share.  You could do other things like setup a sftp server in this container, but that is left as an excersize to the user.

----
    docker run -itd --privileged --name acdmount --volumes-from acdcli-data  sedlund/acdcli sh -c "acdcli -v mount /acd; sh"

