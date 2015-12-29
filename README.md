# coreos-app-installer

This image made for CoreOS.

You can install applications into host environment from inside docker container to run this docker container with volume options.

## usage

**Build the image**

`$ docker build -t knjcode/coreos-app-installer github.com/knjcode/coreos-app-installer`

**Run the container**

`$ docker run --rm -v /opt/bin:/target-bin -v /var:/target-var -v $HOME:/target-home knjcode/coreos-app-installer`

Then, you can install applications into /opt/bin and add settings $HOME/.bashrc.

If you want to install direnv and bash-completion, you should unlink .bashrc as below.

```
$ cd ~
$ cp $(readlink .bashrc) .bashrc.new && mv .bashrc.new .bashrc
```

## Installing applications

- direnv
- fugu
- cf
- docker-compose
- docker-machine
- make
- jq
- ghq
- peco

## Additional settings

- direnv hook for bash
- bash completion
- repository listing alias (using ghq and peco)
