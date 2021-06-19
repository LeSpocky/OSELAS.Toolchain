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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_ISL) += host-system-isl
HOST_SYSTEM_ISL_LICENSE	:= ignore

$(STATEDIR)/host-system-isl.prepare:
	@$(call targetinfo)
	@echo "Checking for isl ..."
	@echo "#include <isl/version.h>" | $(HOSTCC) -x c -c -o /dev/null - 2>/dev/null || \
		ptxd_bailout "isl development files not found!" \
		"Please install libisl-dev (debian) or isl-devel (fedora)"
	@$(call touch)

# vim: syntax=make
