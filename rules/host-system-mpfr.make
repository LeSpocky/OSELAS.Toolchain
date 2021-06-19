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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_MPFR) += host-system-mpfr
HOST_SYSTEM_MPFR_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-mpfr.prepare:
	@$(call targetinfo)
	@echo "Checking for mpfr ..."
	@echo "#include <mpfr.h>" | $(HOSTCC) -x c -c -o /dev/null - 2>/dev/null || \
		ptxd_bailout "mpfr development files not found!" \
		"Please install libmpfr-dev (debian) or mpfr-devel (fedora)"
	@$(call touch)

# vim: syntax=make
