#!/bin/bash
#
# Copyright (C) 2020 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# The search paths added with these variables are needed in a BSP because
# there are two sysroots: The one from the toolchain and the BSP. This is
# not the case when building a toolchain, so they are not necessary here.
#
ptxd_init_cross_env_toolchain() {
    unset PTXDIST_CROSS_CPPFLAGS
    unset PTXDIST_CROSS_LDFLAGS
}

ptxd_init_cross_env_toolchain
