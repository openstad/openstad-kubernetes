
# Charts

This directory holds the OpenStad chart and the Subcharts.

## Makefile

[Make](Makefile) is used here to automatically package the subcharts and put it into the OpenStad-Chart.
Later this will be updated to a more conventional method.

### Requirements

To be able to use Make you have to have `build-essentials` installed on Linux or on the Windows Subsystem for Linux.

```sh
sudo apt-get install build-essentials
```

### Commands

`make get-subcharts` Update the subcharts for OpenStad
