#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#


ptxd_make_image_tgz() {
    ptxd_make_image_init || return

    local prefix_cross="$(ptxd_get_ptxconf PTXCONF_PREFIX_CROSS)"
    local src="${PTXDIST_SYSROOT_CROSS}${prefix_cross}"
    local dst="${pkg_dir}/$(dirname ${prefix_cross})"
    local sysroot="${pkg_dir}${prefix_cross}"
    local -a host_dirs=( \
	"${sysroot}/lib" \
	"${sysroot}/libexec" \
	"${sysroot}/bin" \
	"${sysroot}/${ptxconf_gnu_target}/bin" \
    )

    rm -rf "${pkg_dir}" &&
    rm -f "${image_image}" &&
    mkdir -p "${dst}" &&
    cp -a "${src}" "${dst}" || return

    # strip all host binaries
    find "${host_dirs[@]}" \
	-wholename "${PTXDIST_SYSROOT_CROSS}${prefix_cross}/lib/gcc" -prune -o \
	-type f \( -executable -o -name "*.so*" \) -print0 \
	| xargs -0 -n1 --verbose strip --preserve-dates

    mkdir -p "$(dirname "${image_image}")" &&
    echo "Creating $(ptxd_print_path "${image_image}") ..." &&
    cd "${pkg_dir}/$(ptxd_get_ptxconf PTXCONF_PREFIX)" &&
    echo "tar -cJf '${image_image}' *" | fakeroot &&
    rm -rf "${pkg_dir}"
}
export -f ptxd_make_image_tgz
