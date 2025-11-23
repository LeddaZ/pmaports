# Device Maintainers

This document outlines guidelines and suggestions for maintainers of device
ports and relevant packages (`device-*`, `linux-*`, `firmware-*`, etc.).

## Maintainer responsibilities

Device maintainers should:

* Test their ports regularly (at least once every few months) to ensure that
  there are no regressions.
  * Maintainers are encouraged to find other testers to help with this task.
* Continuously ensure that the email address listed in the "Maintainer" field
  in their packages' APKBUILD files is up to date.
  * This address must not be a "no-reply" dummy email, as it may be used for
    communication with the maintainer.
* Monitor and review merge requests that make changes to the device.
  * In the case of merge requests that make changes to multiple ports,
    only reviewing the part that concerns the maintained device is accepted.
* Monitor and respond to issues regarding the device port in the pmaports
  repository.
* For devices running a (close-to) mainline kernel, update the kernel package
  regularly (at least once every 6 months). This ensures that work in (close-to)
  mainline forks does not drift too far from upstream and encourages early
  upstreaming.

Additionally, maintainers of devices in the *community* and *main* categories
must ensure that their port remains suitable for the requirements of these
categories - see [Device Categorization](device-categorization.md).

It is recommended that device maintainers join the
[#postmarketOS-testing Matrix/IRC channel](https://wiki.postmarketos.org/wiki/Matrix_and_IRC)
to receive notifications about potentially breaking changes that are worth
testing.

## Getting help

Maintaining a device comes with many responsibilities; as such, it is important
to recognize your limits when it comes to working on the port.

It is useful to find co-maintainers for the packages so that maintainership
duties can be split across the maintainer team.

For testing, finding testers can also prove helpful (see the
[Testing Team](https://wiki.postmarketos.org/wiki/Testing_Team)).
