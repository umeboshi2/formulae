# tools-formula

Salt Stack Formula to set up and configure a set of handy tools which are too simple/ small to dedicate individual formulas to

## NOTICE BEFORE USE

* This formula aims to follow the conventions and recommendations described at [http://docs.saltstack.com/topics/conventions/formulas.html](http://docs.saltstack.com/topics/conventions/formulas.html)

## TODO

Define tasks to complete:

* provide removing the tools/ packages, too ("state")

## Instructions

1. Add this repository as a [GitFS](http://docs.saltstack.com/topics/tutorials/gitfs.html) backend in your Salt master config.

2. Configure your Pillar top file (`/srv/pillar/top.sls`), see pillar.example

3. Include this Formula within another Formula or simply define your needed states within the Salt top file (`/srv/salt/top.sls`).

## Available states

### tools

Installs tools with the correct software packages

## Additional resources

None

## Formula Dependencies

None

## Compatibility

*DOES* work on:

* GNU/ Linux Debian Wheezy

*SHOULD* work on:

* GNU/ Linux Debian Squeeze
