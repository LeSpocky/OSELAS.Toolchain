# -*-makefile-*-
#
# Copyright (C) 2024 by Markus Heidelberg <m.heidelberg@cab.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_RSYNC) += host-system-rsync
HOST_SYSTEM_RSYNC_LICENSE := ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-rsync.prepare:
	@$(call targetinfo)
	@echo "Checking for rsync ..."
	@rsync --version >/dev/null 2>&1 || \
		ptxd_bailout "'rsync' not found! Please install.";
	@$(call touch)

# vim: syntax=make
