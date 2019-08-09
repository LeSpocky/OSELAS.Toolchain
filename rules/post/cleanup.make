
TOOLCHAIN_CLEANUP_HOST_DIRS := \
	"$(PTXCONF_SYSROOT_CROSS)/lib" \
	"$(PTXCONF_SYSROOT_CROSS)/libexec" \
	"$(PTXCONF_SYSROOT_CROSS)/bin" \
	"$(PTXCONF_SYSROOT_CROSS)/$(call remove_quotes,$(PTXCONF_GNU_TARGET))/bin"

$(STATEDIR)/world.cleanup: $(STATEDIR)/world.targetinstall
	@$(call targetinfo)
ifndef PTXDIST_TOOLCHCAIN_KEEP_DEBUG
#	# strip all host binaries
	find $(TOOLCHAIN_CLEANUP_HOST_DIRS) \
		-wholename "$(PTXCONF_SYSROOT_CROSS)/lib/gcc" -prune -o \
		-type f \( -executable -o -name "*.so*" \) -print0 \
		| xargs -0 -n1 --verbose strip --preserve-dates || true
endif
	@$(call touch)

world: $(STATEDIR)/world.cleanup

# vim: syntax=make
