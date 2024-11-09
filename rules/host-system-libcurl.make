# -*-makefile-*-
#
# Copyright (C) 2024 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_LIBCURL) += host-system-libcurl
HOST_SYSTEM_LIBCURL_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-libcurl.prepare:
	@$(call targetinfo)
	@echo "Checking for libcurl ..."
	@pkg-config libcurl || \
		ptxd_bailout "curl development files not found!" \
		"Please install libcurl4-openssl-dev (debian) or libcurl-devel (fedora)"
	@$(call touch)

# vim: syntax=make
