# Authors

This document lists all authors who contributed to the Linux kernel patches for the Retroid Pocket 5.

## Patch Authors

- **Alexey Andreev** <dev@aa13q.ru>
  - Initiator of the patches adaptation for postmarketOS

- **BigfootACA** <bigfoot@classfun.cn>
  - AYN Odin2 Gamepad driver

- **Daniel Martin** <dmanlfc@gmail.com>
  - PWM fan initial speed configuration (70% instead of maximum)

- **Krishna Kurapati** <krishna.kurapati@oss.qualcomm.com>
  - USB U1/U2 power-saving states fix for improved stability

- **Molly Sophia** <mollysophia379@gmail.com>
  - AYN Odin2 Gamepad driver

- **Philippe Simons** <simons.philippe@gmail.com>
  - Kernel log spam reduction (disabled debug messages in Bluetooth, remoteproc, audio, etc.)

- **ROCKNIX Team** <admin@rocknix.org> / **rocknix** <macebrooks@gmail.com>
  - Force feedback (rumble) support for RP5 gamepad driver
  - Additional GPU OPP values (650/700/750/800 MHz frequencies)

- **spycat88** <spycat88@users.noreply.github.com>
  - Force feedback (rumble) support for RP5 gamepad driver
  - WiFi and Bluetooth MAC address generation from device serial number

- **Teguh Sobirin** <teguh@sobir.in>
  - Panel driver for DDIC CH13726A (including RPminiV2 support and stutter fix)
  - AYN Odin2 Gamepad driver
  - PM8150B SPMI haptics support
  - LED HTR3212 driver
  - SM8250 UART16 support
  - Retroid Pocket 5 device tree support
  - Retroid Pocket Mini device tree support
  - Retroid Pocket variant support
  - Volume up button fix for custom U-Boot
  - Qualcomm SPMI haptics driver
  - ASoC audio improvements (q6asm-dai default periods)

## Upstream Contributors

The following people contributed to upstream patches that were adapted:

- **Bjorn Andersson** <andersson@kernel.org>
  - Kernel maintainer (upstream reviews and approvals)

- **Konrad Dybcio** <konrad.dybcio@oss.qualcomm.com>
  - Reviewed USB stability improvements

- **Prashanth K** <quic_prashk@quicinc.com>
  - Qualcomm USB improvements (contributor to original patches)

## License

All patches are licensed under GPL-2.0 or GPL-2.0-only unless otherwise specified in the individual patch files.
