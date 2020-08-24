# -*-makefile-*-
#
# Copyright (C) 2020 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_MPC) += host-system-mpc
HOST_SYSTEM_MPC_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-mpc.prepare:
	@$(call targetinfo)
	@echo "Checking for mpc ..."
	@echo "#include <mpc.h>" | $(HOSTCC) -x c -c -o /dev/null - 2>/dev/null || \
		ptxd_bailout "mpc development files not found!" \
		"Please install libmpc-dev (debian)"
	@$(call touch)

# vim: syntax=make
