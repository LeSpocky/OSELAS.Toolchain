#!/bin/bash
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# custom ptxd_make_world_install_pack
#
# * skip rpath fixup. Not needed and may cause problems with target file
#   in cross packages
# * skip anything else that is not needed for the toolchain
#
ptxd_make_world_install_pack() {
    ptxd_make_world_init &&

    if [ -z "${pkg_pkg_dir}" ]; then
	# no pkg dir -> assume the package has nothing to install.
	return
    fi &&

    # created during install but not needed here
    if [ "${pkg_type}" = "cross" ]; then
	rm "${pkg_pkg_dir}/lib64"
    fi &&

    # remove empty dirs
    test \! -e "${pkg_pkg_dir}" || \
	find "${pkg_pkg_dir}" -depth -type d -print0 | xargs -r -0 -- \
	rmdir --ignore-fail-on-non-empty -- &&
    check_pipe_status &&

    if [ \! -e "${pkg_pkg_dir}" ]; then
	if [ -e "${pkg_dir}" ]; then
	    ptxd_warning "PKG didn't install anything to '${pkg_pkg_dir}'"
	fi
	return
    fi &&

    # remove la files. They are not needed
    find "${pkg_pkg_dir}" \( -type f -o -type l \) -name "*.la" -print0 | xargs -r -0 rm &&
    check_pipe_status

    # ensure PATH is set correctly to find cross tools if necessary
    eval "${pkg_path}"

    local ptxconf_gnu_target="$(ptxd_get_ptxconf PTXCONF_GNU_TARGET)"
    local ptxconf_prefix="$(ptxd_get_ptxconf PTXCONF_PREFIX_CROSS)"
    if [ "${pkg_type}" = "cross" ]; then
	local -a host_dirs
	for dir in \
	    "${pkg_pkg_dir}${ptxconf_prefix}/lib" \
	    "${pkg_pkg_dir}${ptxconf_prefix}/libexec" \
	    "${pkg_pkg_dir}${ptxconf_prefix}/bin" \
	    "${pkg_pkg_dir}${ptxconf_prefix}/${ptxconf_gnu_target}/bin"; do
	    if [ -d "${dir}" ]; then
		host_dirs[${#host_dirs[*]}]="${dir}"
	    fi
	done
	if [ ${#host_dirs[*]} -eq 0 ]; then
	    ptxd_bailout "cross package '${pkg_pkg}' not properly installed"
	fi
	# remove all static host libraries
	find "${host_dirs[@]}" \
	    -wholename "${pkg_pkg_dir}${ptxconf_prefix}/lib/gcc" -prune -o \
	    -type f -name "*.a" -print0 | xargs -0 -r rm -v
    fi
    local -a strip_dirs
    case "${pkg_type}" in
	target)
	    strip_dirs=( "${pkg_pkg_dir}" )
	    ;;
	cross)
	    if [ -d "${pkg_pkg_dir}${ptxconf_prefix}/lib/gcc" ]; then
		strip_dirs[${#strip_dirs[*]}]="${pkg_pkg_dir}${ptxconf_prefix}/lib/gcc"
	    fi
	    if [ -d "${pkg_pkg_dir}${ptxconf_prefix}/${ptxconf_gnu_target}/lib" ]; then
		strip_dirs[${#strip_dirs[*]}]="${pkg_pkg_dir}${ptxconf_prefix}/${ptxconf_gnu_target}/lib"
	    fi
	    ;;
    esac
    if [ ${#strip_dirs[*]} -gt 0 ]; then
	local objcopy="$(ptxd_get_ptxconf PTXCONF_COMPILER_PREFIX)objcopy"
	find "${strip_dirs[@]}" \
	    -wholename "${pkg_pkg_dir}${ptxconf_prefix}/lib/gcc/${ptxconf_gnu_target}/*/plugin" -prune -o \
	    -name "*.py" -prune -o \
	    -type f ! -type l \
	    \( -executable -o -name "*.so*" -o -name "*.a" -o -name "*.o" \) -print \
	    | while read f; do
		# ignore ld scripts
		case "$(file -b "${f}")" in
		    *ASCII*|*script*) continue ;;
		esac
		# size compromise: compressed debug sections in static libraries are too large
		if [[ "${pkg_type}" = "target" && "${f}" =~ \.a$ ]]; then
		    echo "Stripping $(ptxd_print_path "${f}") ..."
		    ${objcopy} \
			--preserve-dates --strip-debug --keep-file-symbols \
			"${f}"
		else
		    # compress debug sections and remove any bogus paths
		    echo "Compressing $(ptxd_print_path "${f}") ..."
		    ${objcopy} \
			--wildcard \
			--strip-symbol=${pkg_pkg_dir}${ptxconf_prefix}/usr/lib/*.o \
			--strip-symbol=${PTXDIST_SYSROOT_TARGET}/usr/lib/*.o \
			--strip-symbol=${pkg_build_dir}/*.o \
			--strip-symbol=${pkg_build_dir}/*.os \
			--preserve-dates --compress-debug-sections \
			"${f}" &&
		    if [[ "$(file "${f}")" =~ "dynamically linked" ]]; then
			chrpath -d "${f}"
		    fi
		fi || exit 1
	    done
    fi
}
export -f ptxd_make_world_install_pack
