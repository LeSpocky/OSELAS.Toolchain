#!/bin/bash
#
# Copyright (C) 2015 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

ptxd_make_world_copy_license() {
    local license_dir license_url name
    ptxd_make_world_license_init || return

    local ptxconf_prefix="$(ptxd_get_ptxconf PTXCONF_PREFIX_CROSS)"
    if [ "${pkg_type}" = "target" ]; then
	license_dir="${PTXDIST_SYSROOT_CROSS}${ptxconf_prefix}/share/compliance"
    else
	license_dir="${pkg_pkg_dir}${ptxconf_prefix}/share/compliance"
    fi
    license_url="file://\$(PTXDIST_PLATFORMDIR)/selected_toolchain/../share/compliance"
    name="${pkg_label#host-}"
    name="${name#cross-}"
    pkg_license_target="${pkg_license_target:-${pkg_label}}"
    pkg_license_target_license="${pkg_license_target_license:-${pkg_license}}"
    pkg_license_target_pattern="${pkg_license_target_pattern:-*}"

    echo "Exporting license information..."

    rm -rf "${license_dir}/${name}" &&
    mkdir -p "${license_dir}/${name}" &&
    cp "${pkg_license_dir}/license/"* \
	"${license_dir}/${name}" &&
    rm "${license_dir}/${name}/MD5SUM"
    (
	local TARGET="$(ptxd_name_to_NAME ${pkg_license_target})"
	echo "${TARGET}_LICENSE := ${pkg_license_target_license}" &&
	echo -n "${TARGET}_LICENSE_FILES := " &&
	cd "${license_dir}/${name}" &&
	md5sum ${pkg_license_target_pattern} | \
	sed -n -e "s@\([^ ]*\)  \(.*\)@\t${license_url}/${name}/\2;md5=\1@" \
		-e H -e '${g;s/\n/ \\\n/g;p}'
	check_pipe_status
    ) > "${license_dir}/${pkg_license_target}.make"
}
export -f ptxd_make_world_copy_license
