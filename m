From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/4] e2scrub: create online fsck tool of sorts
Date: Thu, 07 Dec 2017 10:48:29 -0800
Message-ID: <151267250988.1350.5015827346025680275.stgit@magnolia>
References: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57348 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbdLGSsg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 13:48:36 -0500
In-Reply-To: <151267250365.1350.7799938074608034424.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Implement online fsck for ext* filesystems which live on LVM-managed
logical volumes.  The basic strategy mirrors that of e2croncheck --
create a snapshot, fsck the snapshot, report whatever errors appear,
remove snapshot.  Unlike e2croncheck, this utility accepts any LVM
device path, knows about snapshots running out of space, and can call
fstrim having validated that the fs metadata is ok.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in             |    3 +
 Makefile.in            |    3 +
 configure              |   21 +++++-
 configure.ac           |   24 ++++++
 debian/control.in      |    2 -
 debian/e2fsprogs.files |    1 
 scrub/Makefile.in      |   97 ++++++++++++++++++++++++++
 scrub/e2scrub.8.in     |   31 ++++++++
 scrub/e2scrub.conf.in  |   10 +++
 scrub/e2scrub.in       |  182 ++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/e2scrub.rules.in |    2 +
 util/subst.conf.in     |    2 +
 12 files changed, 374 insertions(+), 4 deletions(-)
 create mode 100644 scrub/Makefile.in
 create mode 100644 scrub/e2scrub.8.in
 create mode 100644 scrub/e2scrub.conf.in
 create mode 100644 scrub/e2scrub.in
 create mode 100644 scrub/e2scrub.rules.in


diff --git a/MCONFIG.in b/MCONFIG.in
index 22b74eb..a244728 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -33,6 +33,9 @@ infodir = @infodir@
 datadir = @datadir@
 pkgconfigdir = $(libdir)/pkgconfig
 
+HAVE_UDEV = @have_udev@
+UDEVRULESDIR = @udevrulesdir@
+
 @SET_MAKE@
 
 @ifGNUmake@ V =
diff --git a/Makefile.in b/Makefile.in
index 37b6069..ddd94ec 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -13,10 +13,11 @@ INSTALL = @INSTALL@
 @DEBUGFS_CMT@DEBUGFS_DIR= debugfs
 @UUID_CMT@UUID_LIB_SUBDIR= lib/uuid
 @BLKID_CMT@BLKID_LIB_SUBDIR= lib/blkid
+@E2SCRUB_CMT@E2SCRUB_DIR= scrub
 SUPPORT_LIB_SUBDIR= lib/support
 
 LIB_SUBDIRS=lib/et lib/ss lib/e2p $(UUID_LIB_SUBDIR) $(BLKID_LIB_SUBDIR) $(SUPPORT_LIB_SUBDIR) lib/ext2fs intl
-PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po
+PROG_SUBDIRS=e2fsck $(DEBUGFS_DIR) misc $(RESIZE_DIR) tests/progs po $(E2SCRUB_DIR)
 SUBDIRS=util $(LIB_SUBDIRS) $(PROG_SUBDIRS) tests
 
 SUBS= util/subst.conf lib/config.h $(top_builddir)/lib/dirpaths.h \
diff --git a/configure b/configure
index b62da1b..c911469 100755
--- a/configure
+++ b/configure
@@ -625,6 +625,8 @@ gl_use_threads_default=
 ac_func_list=
 ac_subst_vars='LTLIBOBJS
 LIBOBJS
+udevrulesdir
+have_udev
 LDFLAGS_SHLIB
 CFLAGS_STLIB
 CFLAGS_SHLIB
@@ -639,6 +641,7 @@ root_libdir
 root_sbindir
 root_bindir
 root_prefix
+E2SCRUB_CMT
 UNIX_CMT
 CYGWIN_CMT
 LINUX_CMT
@@ -13711,6 +13714,8 @@ esac
 
 
 
+E2SCRUB_CMT="$LINUX_CMT"
+
 case "$host_os" in
 linux* | gnu* | k*bsd*-gnu)
 	if test "$prefix" = NONE -a "$root_prefix" = NONE ; then
@@ -13876,6 +13881,20 @@ LDFLAGS_SHLIB=${LDFLAGS_SHLIB:-$LDFLAGS}
 
 
 
+
+pkg_udevrulesdir="$(pkg-config --variable=udevdir udev 2>/dev/null)/rules"
+case "${pkg_udevrulesdir}" in
+"")
+	udevrulesdir=""
+	have_udev=no
+	;;
+*)
+	udevrulesdir="${pkg_udevrulesdir}"
+	have_udev=yes
+	;;
+esac
+
+
 test -d lib || mkdir lib
 test -d include || mkdir include
 test -d include/linux || mkdir include/linux
@@ -13897,7 +13916,7 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
 	debugfs/Makefile tests/Makefile tests/progs/Makefile \
 	resize/Makefile doc/Makefile intl/Makefile \
-	intl/libgnuintl.h po/Makefile.in ; do
+	intl/libgnuintl.h po/Makefile.in scrub/Makefile; do
 	if test -d `dirname ${srcdir}/$i` ; then
 		outlist="$outlist $i"
 	fi
diff --git a/configure.ac b/configure.ac
index 4ec4617..ad2884d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1311,6 +1311,11 @@ AC_SUBST(LINUX_CMT)
 AC_SUBST(CYGWIN_CMT)
 AC_SUBST(UNIX_CMT)
 dnl
+dnl e2scrub only builds on linux
+dnl
+E2SCRUB_CMT="$LINUX_CMT"
+AC_SUBST(E2SCRUB_CMT)
+dnl
 dnl Linux and Hurd places root files in the / by default
 dnl
 case "$host_os" in
@@ -1468,6 +1473,23 @@ LDFLAGS_SHLIB=${LDFLAGS_SHLIB:-$LDFLAGS}
 AC_SUBST(CFLAGS_SHLIB)
 AC_SUBST(CFLAGS_STLIB)
 AC_SUBST(LDFLAGS_SHLIB)
+
+dnl
+dnl Where do udev rules go?
+dnl
+pkg_udevrulesdir="$(pkg-config --variable=udevdir udev 2>/dev/null)/rules"
+case "${pkg_udevrulesdir}" in
+"")
+	udevrulesdir=""
+	have_udev=no
+	;;
+*)
+	udevrulesdir="${pkg_udevrulesdir}"
+	have_udev=yes
+	;;
+esac
+AC_SUBST([have_udev])
+AC_SUBST([udevrulesdir])
 dnl
 dnl Make our output files, being sure that we create the some miscellaneous 
 dnl directories
@@ -1493,7 +1515,7 @@ for i in MCONFIG Makefile e2fsprogs.spec \
 	misc/Makefile ext2ed/Makefile e2fsck/Makefile \
 	debugfs/Makefile tests/Makefile tests/progs/Makefile \
 	resize/Makefile doc/Makefile intl/Makefile \
-	intl/libgnuintl.h po/Makefile.in ; do
+	intl/libgnuintl.h po/Makefile.in scrub/Makefile; do
 	if test -d `dirname ${srcdir}/$i` ; then
 		outlist="$outlist $i"
 	fi
diff --git a/debian/control.in b/debian/control.in
index 89e8801..6efaef9 100644
--- a/debian/control.in
+++ b/debian/control.in
@@ -155,7 +155,7 @@ Essential: yes
 Pre-Depends: ${shlibs:Depends}, ${misc:Depends}, libblkid1, libuuid1
 Multi-Arch: foreign
 Suggests: gpart, parted, fuse2fs, e2fsck-static
-Recommends: e2fsprogs-l10n
+Recommends: e2fsprogs-l10n, lvm2, util-linux, coreutils
 Architecture: any
 Description: ext2/ext3/ext4 file system utilities
  The ext2, ext3 and ext4 file systems are successors of the original ext
diff --git a/debian/e2fsprogs.files b/debian/e2fsprogs.files
index 37e54da..7dd64ac 100644
--- a/debian/e2fsprogs.files
+++ b/debian/e2fsprogs.files
@@ -4,3 +4,4 @@ usr/sbin
 usr/share/man
 usr/share/locale
 etc
+lib/udev/rules
diff --git a/scrub/Makefile.in b/scrub/Makefile.in
new file mode 100644
index 0000000..1f3253d
--- /dev/null
+++ b/scrub/Makefile.in
@@ -0,0 +1,97 @@
+#
+# Makefile for e2scrub
+#
+
+srcdir = @srcdir@
+top_srcdir = @top_srcdir@
+VPATH = @srcdir@
+top_builddir = ..
+my_dir = scrub
+INSTALL = @INSTALL@
+
+@MCONFIG@
+
+PROGS=		e2scrub
+MANPAGES=	e2scrub.8
+CONFFILES=	e2scrub.conf
+
+ifeq ($(HAVE_UDEV),yes)
+UDEVRULES	= e2scrub.rules
+INSTALLDIRS_TGT	+= installdirs-udev
+INSTALL_TGT	+= install-udev
+UNINSTALL_TGT	+= uninstall-udev
+endif
+
+all:: $(PROGS) $(MANPAGES) $(CONFFILES) $(UDEVRULES)
+
+e2scrub: $(DEP_SUBSTITUTE) e2scrub.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2scrub.in $@
+	$(Q) chmod a+x $@
+
+%.8: %.8.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+%.conf: %.conf.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+%.rules: %.rules.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+installdirs-udev:
+	$(E) "	MKINSTALLDIRS $(udevdir)"
+	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(UDEVRULESDIR)
+
+installdirs: $(INSTALLDIRS_TGT)
+	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir) $(root_sysconfdir)"
+	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
+		$(DESTDIR)$(man8dir) $(DESTDIR)$(root_sysconfdir)
+
+install-udev:
+	$(Q) for i in $(UDEVRULES); do \
+		$(ES) "	INSTALL $(UDEVRULESDIR)/$$i"; \
+		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(UDEVRULESDIR)/96-$$i; \
+	done
+
+install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs $(INSTALL_TGT)
+	$(Q) for i in $(PROGS); do \
+		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
+		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+	$(Q) for i in $(MANPAGES); do \
+		for j in $(COMPRESS_EXT); do \
+			$(RM) -f $(DESTDIR)$(man8dir)/$$i.$$j; \
+		done; \
+		$(ES) "	INSTALL_DATA $(man8dir)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(man8dir)/$$i; \
+	done
+	$(Q) for i in $(CONFFILES); do \
+		$(ES) "	INSTALL_DATA $(root_sysconfdir)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(root_sysconfdir)/$$i; \
+	done
+
+uninstall-udev:
+	for i in $(UDEVRULES); do \
+		$(RM) -f $(DESTDIR)$(UDEVRULESDIR)/$$i; \
+	done
+
+uninstall: $(UNINSTALL_TGT)
+	for i in $(PROGS); do \
+		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
+	done
+	for i in $(MANPAGES); do \
+		$(RM) -f $(DESTDIR)$(man8dir)/$$i; \
+	done
+	for i in $(CONFFILES); do \
+		$(RM) -f $(DESTDIR)$(root_sysconfdir)/$$i; \
+	done
+
+clean::
+	$(RM) -f $(PROGS)
+
+mostlyclean: clean
+distclean: clean
+	$(RM) -f .depend Makefile $(srcdir)/TAGS $(srcdir)/Makefile.in.old
diff --git a/scrub/e2scrub.8.in b/scrub/e2scrub.8.in
new file mode 100644
index 0000000..e3d037b
--- /dev/null
+++ b/scrub/e2scrub.8.in
@@ -0,0 +1,31 @@
+.TH E2SCRUB 8 "@E2FSPROGS_MONTH@ @E2FSPROGS_YEAR@" "E2fsprogs version @E2FSPROGS_VERSION@"
+.SH NAME
+e2scrub - check a mounted ext2/ext3/ext4 file system on an LVM volume for errors.
+.SH SYNOPSYS
+.B
+e2scrub [OPTION] [LVM DEVICE PATH]
+.SH DESCRIPTION
+Given a live file system on a LVM volume, this program snapshots the
+logical volume and runs a file system check to look for serious errors.
+If no errors are found, fstrim can be called on the mounted file system.
+However, if errors are found, the file system should be unmounted and
+fixed.
+.SH OPTIONS
+.TP
+\fB-t\fR
+Run
+.B
+fstrim(1)
+on the mounted filesystem if no errors are found.
+.SH EXIT CODE
+The exit codes are the same as in
+.BR e2fsck (8)
+.SH BUGS
+This utility is capable of checking any ext* filesystem on an LVM volume,
+regardless of whether it is mounted.
+.SH SEE ALSO
+.BR e2fsck (8)
+.SH AUTHOR
+Darrick J. Wong <darrick.wong@oracle.com>
+.SH COPYRIGHT
+Copyright ©2017 Darrick J. Wong.  License is GPLv2+. <http://www.gnu.org/licenses/gpl-2.0.html>
diff --git a/scrub/e2scrub.conf.in b/scrub/e2scrub.conf.in
new file mode 100644
index 0000000..fec828a
--- /dev/null
+++ b/scrub/e2scrub.conf.in
@@ -0,0 +1,10 @@
+# e2scrub configuration file
+
+# Snapshots will be created to run fsck; the snapshot will be of this size.
+# snap_size_mb=256
+
+# Set this to 1 to enable fstrim for everyone
+# fstrim=0
+
+# Arguments passed into e2fsck
+# e2fsck_opts="-vtt"
diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
new file mode 100644
index 0000000..75e0639
--- /dev/null
+++ b/scrub/e2scrub.in
@@ -0,0 +1,182 @@
+#!/bin/bash
+
+#  Copyright (C) 2017 Oracle.  All Rights Reserved.
+#
+#  Author: Darrick J. Wong <darrick.wong@oracle.com>
+#
+#  This program is free software; you can redistribute it and/or
+#  modify it under the terms of the GNU General Public License
+#  as published by the Free Software Foundation; either version 2
+#  of the License, or (at your option) any later version.
+#
+#  This program is distributed in the hope that it would be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write the Free Software Foundation,
+#  Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+
+# Automatically check a LVM-managed filesystem online.
+# We use lvm snapshots to do this, which means that we can only
+# check filesystems in VGs that have at least 256mb (or so) of
+# free space.
+
+snap_size_mb=256
+fstrim=0
+e2fsck_opts=""
+conffile="@root_sysconfdir@/e2scrub.conf"
+
+test -f "${conffile}" && . "${conffile}"
+
+print_help() {
+	echo "Usage: $0 [-t] device"
+	echo
+	echo "device must be a LVM-managed block device"
+	echo "-t: Run fstrim if successful."
+}
+
+exitcode() {
+	ret="$1"
+
+	exit "${ret}"
+}
+
+prog_path() {
+	path="$1"
+	displayname="$2"
+
+	if ! type -P "${path}" && [ -n "${displayname}" ]; then
+		echo "${displayname}: Command not found."
+		exitcode 8
+	fi
+}
+
+LVS_PROG="$(prog_path "@root_sbindir@/lvs" "lvs")"
+BLKID_PROG="$(prog_path "@root_sbindir@/blkid" "blkid")"
+LVCREATE_PROG="$(prog_path "@root_sbindir@/lvcreate" "lvcreate")"
+LVREMOVE_PROG="$(prog_path "@root_sbindir@/lvremove" "lvremove")"
+FSTRIM_PROG="$(prog_path "@root_sbindir@/fstrim")"
+UDEVADM_PROG="$(prog_path "@root_sbindir@/udevadm")"
+SLEEP_PROG="$(prog_path "@root_bindir@/sleep")"
+
+while getopts "t" opt; do
+	case "${opt}" in
+	"t") fstrim=1;;
+	*) print_help; exitcode 2;;
+	esac
+done
+shift "$((OPTIND - 1))"
+
+dev="$1"
+if [ -z "${dev}" ]; then
+	print_help
+	exitcode 1
+elif [ ! -b "${dev}" ]; then
+	echo "${dev}: Not a block device?"
+	print_help
+	exitcode 16
+fi
+
+# Make sure this is an LVM device we can snapshot
+vg="$("${LVS_PROG}" --noheadings -o vg_name "${dev}" 2> /dev/null | sed -e 's/^  //g')"
+lv="$("${LVS_PROG}" --noheadings -o lv_name "${dev}" 2> /dev/null | sed -e 's/^  //g')"
+if [ -z "${vg}" ] || [ -z "${lv}" ]; then
+	echo "${dev}: Not a LVM device."
+	exitcode 16
+fi
+start_time="$(date +'%Y%m%d%H%M%S')"
+snap="${lv}.e2scrub"
+snap_dev="/dev/${vg}/${snap}"
+fstype="$("${BLKID_PROG}" -p -s TYPE "${dev}" | sed -e 's/^.*TYPE="\(.*\)".*$/\1/g')"
+
+case "${fstype}" in
+"ext2"|"ext3"|"ext4")
+	;;
+*)
+	echo "${dev}: Filesystem of type ${fstype} not supported."
+	exitcode 16
+	;;
+esac
+
+teardown() {
+	# Remove and wait for removal to succeed.
+	"${LVREMOVE_PROG}" -f "${vg}/${snap}" 3>&-
+	while [ -b "${snap_dev}" ] && [ "$?" -eq "5" ]; do
+		/bin/sleep 0.5
+		"${LVREMOVE_PROG}" -f "${vg}/${snap}" 3>&-
+	done
+}
+
+check() {
+	# First we preen the filesystem to recover the journal, then
+	# we see if e2fsck tries any non-optimization repairs.  If
+	# either of these two returns a non-zero status (errors fixed
+	# or remaining) then this fs is bad.
+	E2FSCK_FIXES_ONLY=1
+	export E2FSCK_FIXES_ONLY
+	${DBG} "@root_sbindir@/e2fsck" -p ${e2fsck_opts} "${snap_dev}" || return 1
+	${DBG} "@root_sbindir@/e2fsck" -fy ${e2fsck_opts} "${snap_dev}" || return 1
+	return 0
+}
+
+mark_clean() {
+	${DBG} "@root_sbindir@/tune2fs" -C 0 -T "${start_time}" "${dev}"
+}
+
+mark_corrupt() {
+	${DBG} "@root_sbindir@/tune2fs" -C 16000 -T "19000101" "${dev}"
+}
+
+setup() {
+	# Create the snapshot, wait for device to appear
+	teardown > /dev/null 2> /dev/null
+	"${LVCREATE_PROG}" -s -L "${snap_size_mb}m" -n "${snap}" "${vg}/${lv}" 3>&-
+	test $? -ne 0 && return 1
+	test -x "${UDEVADM_PROG}" && "${UDEVADM_PROG}" settle
+	return 0
+}
+
+trap "teardown" EXIT INT QUIT TERM
+if ! setup; then
+	echo "Snapshot of ${dev} FAILED, will not check!"
+	exitcode 1
+fi
+
+# Check and react
+if check; then
+	echo "Scrub of ${dev} succeeded."
+	mark_clean
+
+	if [ "${fstrim}" -eq 1 ] && [ -x "${FSTRIM_PROG}" ]; then
+		dir="$(lsblk -o MOUNTPOINT -n "${dev}")"
+		if [ -d "${dir}" ]; then
+			# NB: fstrim fails with snapshot present
+			trap '' EXIT
+			teardown
+			"${FSTRIM_PROG}" -v "${dir}"
+		fi
+	fi
+
+	ret=0
+else
+	# fsck failed.  Check if the snapshot is invalid; if so, make a
+	# note of that at the end of the log.  This isn't necessarily a
+	# failure because the mounted fs could have overflowed the
+	# snapshot with regular disk writes /or/ our repair process
+	# could have done it by repairing too much.
+	#
+	# If it's really corrupt we ought to fsck at next boot.
+	is_invalid="$("${LVS_PROG}" -o lv_snapshot_invalid --noheadings "${snapdev}")"
+	if [ -n "${is_invalid}" ]; then
+		echo "Scrub of ${dev} FAILED due to invalid snapshot."
+		ret=8
+	else
+		echo "Scrub of ${dev} FAILED!  Reboot soon to fsck."
+		mark_corrupt
+		ret=6
+	fi
+fi
+
+exitcode "${ret}"
diff --git a/scrub/e2scrub.rules.in b/scrub/e2scrub.rules.in
new file mode 100644
index 0000000..5e1b35b
--- /dev/null
+++ b/scrub/e2scrub.rules.in
@@ -0,0 +1,2 @@
+# Try to hide our fsck snapshots from udev's /dev/disk linking...
+ACTION=="add|change", ENV{DM_LV_NAME}=="*.e2scrub", OPTIONS="link_priority=-100"
diff --git a/util/subst.conf.in b/util/subst.conf.in
index fbc044d..effac78 100644
--- a/util/subst.conf.in
+++ b/util/subst.conf.in
@@ -18,3 +18,5 @@ $prefix			@prefix@
 JDEV			
 # Enable the documentation for the tdb profile in e2fsck.conf's man page
 TDB_MAN_COMMENT		@TDB_MAN_COMMENT@
+root_sbindir		@root_sbindir@
+root_bindir		@root_bindir@
