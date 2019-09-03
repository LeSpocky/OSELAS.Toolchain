# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

.PHONY: install

toolchain/install = \
	$(call ptx/env) \
	ptx_install_destdir=$(DESTDIR) \
	ptxd_make_toolchain_install

install: world
	@$(call targetinfo)
	@$(call toolchain/install)
	@$(call finish)

# vim: syntax=make
