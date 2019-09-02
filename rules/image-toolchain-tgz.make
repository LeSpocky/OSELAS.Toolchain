# -*-makefile-*-
#
# Copyright (C) 2014 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
IMAGE_PACKAGES-$(PTXCONF_IMAGE_TOOLCHAIN_TGZ) += image-toolchain-tgz

#
# Paths and names
#
IMAGE_TOOLCHAIN_TGZ_VERSION	:= $(shell ./scripts/setlocalversion ./.tarball-version)
IMAGE_TOOLCHAIN_TGZ		:= image-toolchain-tgz-$(IMAGE_TOOLCHAIN_TGZ_VERSION)
IMAGE_TOOLCHAIN_TGZ_DIR		:= $(BUILDDIR)/$(IMAGE_TOOLCHAIN_TGZ)
IMAGE_TOOLCHAIN_TGZ_IMAGE	:= $(PTXDIST_WORKSPACE)/dist/oselas.toolchain-$(IMAGE_TOOLCHAIN_TGZ_VERSION)-$(subst _,-,$(PTXCONF_PLATFORM))_$(PTX_TOOLCHAIN_HOST_ARCH).tar.xz

# ----------------------------------------------------------------------------
# Image
# ----------------------------------------------------------------------------

$(IMAGE_TOOLCHAIN_TGZ_IMAGE): $(STATEDIR)/world.targetinstall
	@$(call targetinfo)
	@$(call world/image/env, IMAGE_TOOLCHAIN_TGZ) \
		ptxd_make_image_tgz
	@$(call finish)

# vim: syntax=make
