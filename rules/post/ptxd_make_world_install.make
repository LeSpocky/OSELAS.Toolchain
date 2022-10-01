# -*-makefile-*-
#
# Copyright (C) 2022 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

world/install-src = \
	$(call world/env, $(1)) \
	ptxd_make_world_install_src

# vim: syntax=make

