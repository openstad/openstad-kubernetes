
# OpenStad

This chart handles the deployemont of the OpenStad application.

## Makefile

I use [make](Makefile) to make commands easier and faster for me to type. This isn't a requirement, you can also stick with `helm` commands.

### Requirements

To be able to use Make you have to have `build-essentials` installed on Linux or on the Windows Subsystem for Linux.

```sh
sudo apt-get install build-essentials
```

### Commands

`make install-dependencies` install any required chart, run this before any other command

`make install` install the chart on the current cluster

`make upgrade` (if exists) upgrade the chart on the current cluster

`make get-values` Get a list of custom-values in this chart

`make uninstall` Uninstall the chart from the cluster but keep logs

`make debug` Put the resulting YAML file into the debug folder without installing

`make clean` Remove the debug folder AND everything inside of it