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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_GMP) += host-system-gmp
HOST_SYSTEM_GMP_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-gmp.prepare:
	@$(call targetinfo)
	@echo "Checking for gmp ..."
	@echo "#include <gmp.h>" | $(HOSTCC) -x c -c -o /dev/null - 2>/dev/null || \
		ptxd_bailout "gmp development files not found!" \
		"Please install libgmp-dev (debian) or gmp-devel (fedora)"
	@$(call touch)


# vim: syntax=make
