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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_NCURSES) += host-system-ncurses
HOST_SYSTEM_NCURSES_LICENSE	:= ignore

$(STATEDIR)/host-system-ncurses.prepare:
	@$(call targetinfo)
	@echo "Checking for ncurses ..."
	@pkg-config ncursesw || \
		ptxd_bailout "ncurses development files not found!" \
		"Please install libncurses-dev (debian) or ncurses-devel (fedora)"
	@$(call touch)

# vim: syntax=make
