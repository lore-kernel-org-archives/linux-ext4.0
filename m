From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/4] e2scrub: add service (cron, systemd) support
Date: Thu, 07 Dec 2017 10:48:42 -0800
Message-ID: <151267252240.1350.14080940928827658377.stgit@magnolia>
References: <151267250365.1350.7799938074608034424.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59768 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbdLGSss (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Dec 2017 13:48:48 -0500
In-Reply-To: <151267250365.1350.7799938074608034424.stgit@magnolia>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Add the ability to run the e2scrub utilities as a periodically scheduled
system service.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 MCONFIG.in                     |    4 ++
 configure                      |   24 +++++++++++++++
 configure.ac                   |   28 ++++++++++++++++-
 debian/e2fsprogs.files         |    2 +
 debian/e2fsprogs.postinst      |   19 ++++++++++++
 scrub/Makefile.in              |   66 ++++++++++++++++++++++++++++++++++++++--
 scrub/e2scrub.in               |   12 +++++++
 scrub/e2scrub@.service.in      |   18 +++++++++++
 scrub/e2scrub_all.cron.in      |    2 +
 scrub/e2scrub_all.in           |   24 ++++++++++++++-
 scrub/e2scrub_all.service.in   |    8 +++++
 scrub/e2scrub_all.timer.in     |   11 +++++++
 scrub/e2scrub_fail.in          |   26 ++++++++++++++++
 scrub/e2scrub_fail@.service.in |   10 ++++++
 util/subst.conf.in             |    2 +
 15 files changed, 250 insertions(+), 6 deletions(-)
 create mode 100644 scrub/e2scrub@.service.in
 create mode 100644 scrub/e2scrub_all.cron.in
 create mode 100644 scrub/e2scrub_all.service.in
 create mode 100644 scrub/e2scrub_all.timer.in
 create mode 100644 scrub/e2scrub_fail.in
 create mode 100644 scrub/e2scrub_fail@.service.in


diff --git a/MCONFIG.in b/MCONFIG.in
index a244728..aa7d0d1 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -23,6 +23,7 @@ libdir = @libdir@
 datadir= @datadir@
 localedir = $(datadir)/locale
 root_sysconfdir= @root_sysconfdir@
+root_crondir= @root_crondir@
 includedir = @includedir@
 mandir = @mandir@
 man1dir = $(mandir)/man1
@@ -32,6 +33,9 @@ man8dir = $(mandir)/man8
 infodir = @infodir@
 datadir = @datadir@
 pkgconfigdir = $(libdir)/pkgconfig
+pkglibdir = @pkglibdir@
+HAVE_SYSTEMD= @have_systemd@
+SYSTEMDSYSTEMUNITDIR= @systemdsystemunitdir@
 
 HAVE_UDEV = @have_udev@
 UDEVRULESDIR = @udevrulesdir@
diff --git a/configure b/configure
index c911469..cca0c23 100755
--- a/configure
+++ b/configure
@@ -625,6 +625,8 @@ gl_use_threads_default=
 ac_func_list=
 ac_subst_vars='LTLIBOBJS
 LIBOBJS
+systemdsystemunitdir
+have_systemd
 udevrulesdir
 have_udev
 LDFLAGS_SHLIB
@@ -636,6 +638,8 @@ MKINSTALLDIRS
 INCLUDES
 DO_TEST_SUITE
 LDFLAGS_STATIC
+pkglibdir
+root_crondir
 root_sysconfdir
 root_libdir
 root_sbindir
@@ -13749,11 +13753,13 @@ if test "$root_prefix" = NONE ; then
 	root_sbindir=$sbindir
 	root_libdir=$libdir
 	root_sysconfdir=$sysconfdir
+	root_crondir=$sysconfdir/cron.d
 else
 	root_bindir='${root_prefix}/bin'
 	root_sbindir='${root_prefix}/sbin'
 	root_libdir='${root_prefix}/lib'
 	root_sysconfdir='${root_prefix}/etc'
+	root_crondir='${root_sysconfdir}/cron.d'
 fi
 if test "$bindir" != '${exec_prefix}/bin'; then
     root_bindir=$bindir
@@ -13781,6 +13787,7 @@ fi
 
 
 
+
 # Check whether --with-multiarch was given.
 if test "${with_multiarch+set}" = set; then :
   withval=$with_multiarch; if test "$withval" = "lib64"; then
@@ -13792,6 +13799,9 @@ else
 fi
 
 fi
+
+pkglibdir=$libdir/e2fsprogs
+
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking whether we can link with -static" >&5
 $as_echo_n "checking whether we can link with -static... " >&6; }
 if ${ac_cv_e2fsprogs_use_static+:} false; then :
@@ -13895,6 +13905,20 @@ case "${pkg_udevrulesdir}" in
 esac
 
 
+pkg_systemdsystemunitdir="$(pkg-config --variable=systemdsystemunitdir systemd 2>/dev/null)"
+case "${pkg_systemdsystemunitdir}" in
+"")
+	systemdsystemunitdir=""
+	have_systemd=no
+	;;
+*)
+	systemdsystemunitdir="${pkg_systemdsystemunitdir}"
+	have_systemd=yes
+	;;
+esac
+
+
+
 test -d lib || mkdir lib
 test -d include || mkdir include
 test -d include/linux || mkdir include/linux
diff --git a/configure.ac b/configure.ac
index ad2884d..28172bd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1351,11 +1351,13 @@ if test "$root_prefix" = NONE ; then
 	root_sbindir=$sbindir
 	root_libdir=$libdir
 	root_sysconfdir=$sysconfdir
+	root_crondir=$sysconfdir/cron.d
 else
 	root_bindir='${root_prefix}/bin'
 	root_sbindir='${root_prefix}/sbin'
 	root_libdir='${root_prefix}/lib'
 	root_sysconfdir='${root_prefix}/etc'
+	root_crondir='${root_sysconfdir}/cron.d'
 fi
 if test "$bindir" != '${exec_prefix}/bin'; then
     root_bindir=$bindir
@@ -1378,6 +1380,7 @@ AC_SUBST(root_bindir)
 AC_SUBST(root_sbindir)
 AC_SUBST(root_libdir)
 AC_SUBST(root_sysconfdir)
+AC_SUBST(root_crondir)
 dnl
 dnl Allow specification of the multiarch arch
 dnl
@@ -1390,7 +1393,13 @@ else
     libdir=$libdir/$withval
     root_libdir=$root_libdir/$withval
 fi
-)dnl
+)
+dnl
+dnl define pkglibdir for /usr/lib/e2fsprogs
+dnl
+pkglibdir=$libdir/e2fsprogs
+AC_SUBST(pkglibdir)
+dnl
 dnl
 dnl See if -static works.  This could fail if the linker does not
 dnl support -static, or if required external libraries are not available
@@ -1491,6 +1500,23 @@ esac
 AC_SUBST([have_udev])
 AC_SUBST([udevrulesdir])
 dnl
+dnl Where do systemd services go?
+dnl
+pkg_systemdsystemunitdir="$(pkg-config --variable=systemdsystemunitdir systemd 2>/dev/null)"
+case "${pkg_systemdsystemunitdir}" in
+"")
+	systemdsystemunitdir=""
+	have_systemd=no
+	;;
+*)
+	systemdsystemunitdir="${pkg_systemdsystemunitdir}"
+	have_systemd=yes
+	;;
+esac
+AC_SUBST([have_systemd])
+AC_SUBST([systemdsystemunitdir])
+
+dnl
 dnl Make our output files, being sure that we create the some miscellaneous 
 dnl directories
 dnl
diff --git a/debian/e2fsprogs.files b/debian/e2fsprogs.files
index 7dd64ac..677367c 100644
--- a/debian/e2fsprogs.files
+++ b/debian/e2fsprogs.files
@@ -1,7 +1,9 @@
 sbin
 usr/bin
+usr/lib
 usr/sbin
 usr/share/man
 usr/share/locale
 etc
+lib/systemd/system
 lib/udev/rules
diff --git a/debian/e2fsprogs.postinst b/debian/e2fsprogs.postinst
index 00ac363..fceda61 100644
--- a/debian/e2fsprogs.postinst
+++ b/debian/e2fsprogs.postinst
@@ -10,4 +10,23 @@ fi
 
 #DEBHELPER#
 
+# debhelper doesn't know what timers are...
+deb-systemd-helper unmask e2scrub_all.timer >/dev/null || true
+
+if deb-systemd-helper --quiet was-enabled e2scrub_all.timer; then
+        # Enables the unit on first installation, creates new
+        # symlinks on upgrades if the unit file has changed.
+        deb-systemd-helper enable e2scrub_all.timer >/dev/null || true
+else
+        # Update the statefile to add new symlinks (if any), which need to be
+        # cleaned up on purge. Also remove old symlinks.
+        deb-systemd-helper update-state e2scrub_all.timer >/dev/null || true
+fi
+
+# Start our new services
+if [ -d /run/systemd/system ]; then
+	systemctl --system daemon-reload >/dev/null || true
+	deb-systemd-invoke start e2scrub_all.timer >/dev/null || true
+fi
+
 exit 0
diff --git a/scrub/Makefile.in b/scrub/Makefile.in
index ce8c85f..65ecc8c 100644
--- a/scrub/Makefile.in
+++ b/scrub/Makefile.in
@@ -22,7 +22,18 @@ INSTALL_TGT	+= install-udev
 UNINSTALL_TGT	+= uninstall-udev
 endif
 
-all:: $(PROGS) $(MANPAGES) $(CONFFILES) $(UDEVRULES)
+CRONTABS=	e2scrub_all.cron
+
+ifeq ($(HAVE_SYSTEMD),yes)
+INSTALLDIRS_TGT	+= installdirs-systemd
+INSTALL_TGT	+= install-systemd
+UNINSTALL_TGT	+= uninstall-systemd
+LIBPROGS	+= e2scrub_fail
+SERVICE_FILES	= e2scrub@.service e2scrub_all.service e2scrub_all.timer e2scrub_fail@.service
+SYSTEMD_DIRS	= $(DESTDIR)/$(pkglibdir) $(DESTDIR)$(SYSTEMDSYSTEMUNITDIR)
+endif
+
+all:: $(PROGS) $(MANPAGES) $(CONFFILES) $(UDEVRULES) $(SERVICE_FILES) $(CRONTABS) $(LIBPROGS)
 
 e2scrub: $(DEP_SUBSTITUTE) e2scrub.in
 	$(E) "	SUBST $@"
@@ -34,6 +45,11 @@ e2scrub_all: e2scrub_all.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2scrub_all.in $@
 	$(Q) chmod a+x $@
 
+e2scrub_fail: e2scrub_fail.in
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/e2scrub_fail.in $@
+	$(Q) chmod a+x $@
+
 %.8: %.8.in $(DEP_SUBSTITUTE)
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $< $@
@@ -46,14 +62,31 @@ e2scrub_all: e2scrub_all.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $< $@
 
+%.service: %.service.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+%.cron: %.cron.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
+%.timer: %.timer.in $(DEP_SUBSTITUTE)
+	$(E) "	SUBST $@"
+	$(Q) $(SUBSTITUTE_UPTIME) $< $@
+
 installdirs-udev:
 	$(E) "	MKINSTALLDIRS $(udevdir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(UDEVRULESDIR)
 
+installdirs-systemd:
+	$(E) "	MKINSTALLDIRS $(SYSTEMD_DIRS) $(pkglibdir)"
+	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(SYSTEMD_DIRS) $(DESTDIR)$(pkglibdir)
+
 installdirs: $(INSTALLDIRS_TGT)
-	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir) $(root_sysconfdir)"
+	$(E) "	MKINSTALLDIRS $(root_sbindir) $(man8dir) $(root_sysconfdir) $(root_crondir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(root_sbindir) \
-		$(DESTDIR)$(man8dir) $(DESTDIR)$(root_sysconfdir)
+		$(DESTDIR)$(man8dir) $(DESTDIR)$(root_sysconfdir) \
+		$(DESTDIR)$(root_crondir)
 
 install-udev:
 	$(Q) for i in $(UDEVRULES); do \
@@ -61,7 +94,17 @@ install-udev:
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(UDEVRULESDIR)/96-$$i; \
 	done
 
-install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs $(INSTALL_TGT)
+install-systemd: $(SERVICE_FILES)
+	$(Q) for i in $(SERVICE_FILES); do \
+		$(ES) "	INSTALL_DATA $(SYSTEMDSYSTEMUNITDIR)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(SYSTEMDSYSTEMUNITDIR)/$$i; \
+	done
+	$(Q) for i in $(LIBPROGS); do \
+		$(ES) "	INSTALL $(pkglibdir)/$$i"; \
+		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(pkglibdir)/$$i; \
+	done
+
+install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs $(INSTALL_TGT) $(CRONTABS)
 	$(Q) for i in $(PROGS); do \
 		$(ES) "	INSTALL $(root_sbindir)/$$i"; \
 		$(INSTALL_PROGRAM) $$i $(DESTDIR)$(root_sbindir)/$$i; \
@@ -77,12 +120,24 @@ install: $(PROGS) $(MANPAGES) $(FMANPAGES) installdirs $(INSTALL_TGT)
 		$(ES) "	INSTALL_DATA $(root_sysconfdir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(root_sysconfdir)/$$i; \
 	done
+	$(Q) for i in $(CRONTABS); do \
+		$(ES) "	INSTALL_DATA $(root_crondir)/$$i"; \
+		$(INSTALL_DATA) $$i $(DESTDIR)$(root_crondir)/$$i; \
+	done
 
 uninstall-udev:
 	for i in $(UDEVRULES); do \
 		$(RM) -f $(DESTDIR)$(UDEVRULESDIR)/$$i; \
 	done
 
+uninstall-systemd:
+	for i in $(SERVICE_FILES); do \
+		$(RM) -f $(DESTDIR)$(SYSTEMDSYSTEMUNITDIR)/$$i; \
+	done
+	for i in $(LIBPROGS); do \
+		$(RM) -f $(DESTDIR)$(pkglibdir)/$(package)/$$i; \
+	done
+
 uninstall: $(UNINSTALL_TGT)
 	for i in $(PROGS); do \
 		$(RM) -f $(DESTDIR)$(root_sbindir)/$$i; \
@@ -93,6 +148,9 @@ uninstall: $(UNINSTALL_TGT)
 	for i in $(CONFFILES); do \
 		$(RM) -f $(DESTDIR)$(root_sysconfdir)/$$i; \
 	done
+	for i in $(CRONTABS); do \
+		$(RM) -f $(DESTDIR)$(root_crondir)/$$i; \
+	done
 
 clean::
 	$(RM) -f $(PROGS)
diff --git a/scrub/e2scrub.in b/scrub/e2scrub.in
index 75e0639..9ea9b19 100644
--- a/scrub/e2scrub.in
+++ b/scrub/e2scrub.in
@@ -40,6 +40,18 @@ print_help() {
 exitcode() {
 	ret="$1"
 
+	# If we're in service mode, add 150 to the error code to
+	# avoid conflicting with sysvinit error codes
+	if [ -n "${SERVICE_MODE}" ] && [ "${ret}" -ne 0 ]; then
+		ret="$((ret + 150))"
+	fi
+
+	# Stupid journald bug where the process still has to exist for
+	# the last few messages to get tagged to the service...
+	if [ -n "${SERVICE_MODE}" ] && [ -x "${SLEEP_PROG}" ]; then
+		"${SLEEP_PROG}" 2
+	fi
+
 	exit "${ret}"
 }
 
diff --git a/scrub/e2scrub@.service.in b/scrub/e2scrub@.service.in
new file mode 100644
index 0000000..213cffc
--- /dev/null
+++ b/scrub/e2scrub@.service.in
@@ -0,0 +1,18 @@
+[Unit]
+Description=Online ext4 Metadata Check for %I
+OnFailure=e2scrub_fail@%i.service
+
+[Service]
+Type=oneshot
+WorkingDirectory=/
+PrivateNetwork=true
+ProtectSystem=true
+ProtectHome=read-only
+PrivateTmp=yes
+AmbientCapabilities=CAP_SYS_ADMIN CAP_SYS_RAWIO
+NoNewPrivileges=yes
+User=root
+IOSchedulingClass=idle
+CPUSchedulingPolicy=idle
+Environment=SERVICE_MODE=1
+ExecStart=@root_sbindir@/e2scrub -t %I
diff --git a/scrub/e2scrub_all.cron.in b/scrub/e2scrub_all.cron.in
new file mode 100644
index 0000000..6551a77
--- /dev/null
+++ b/scrub/e2scrub_all.cron.in
@@ -0,0 +1,2 @@
+SERVICE_MODE=1
+10 3 * * 0 root test -e /run/systemd/system || @root_sbindir@/e2scrub_all
diff --git a/scrub/e2scrub_all.in b/scrub/e2scrub_all.in
index a9ba670..71fb343 100644
--- a/scrub/e2scrub_all.in
+++ b/scrub/e2scrub_all.in
@@ -24,6 +24,18 @@ types="ext2,ext3,ext4"
 exitcode() {
 	ret="$1"
 
+	# If we're in service mode, add 150 to the error code to
+	# avoid conflicting with sysvinit error codes
+	if [ -n "${SERVICE_MODE}" ] && [ "${ret}" -ne 0 ]; then
+		ret="$((ret + 150))"
+	fi
+
+	# Stupid journald bug where the process still has to exist for
+	# the last few messages to get tagged to the service...
+	if [ -n "${SERVICE_MODE}" ]; then
+		"${SLEEP_PROG}" 2
+	fi
+
 	exit "${ret}"
 }
 
@@ -39,13 +51,23 @@ prog_path() {
 
 LVS_PROG="$(prog_path "@root_sbindir@/lvs" "lvs")"
 BLKID_PROG="$(prog_path "@root_sbindir@/blkid" "blkid")"
+SYSTEMCTL_PROG="$(prog_path "@root_bindir@/systemctl")"
+SLEEP_PROG="$(prog_path "@root_bindir@/sleep")"
 
 # Scrub any fs on lvm by creating a snapshot and fscking that.
 "${LVS_PROG}" -o vg_name,lv_name --noheadings 2> /dev/null | while read vg lv; do
 	dev="/dev/${vg}/${lv}"
 	"${BLKID_PROG}" -p -n "${types}" "${dev}" > /dev/null 2>&1 || continue
 
-	${DBG} "@root_sbindir@/e2scrub" "${dev}"
+	if [ ! -x "${SYSTEMCTL_PROG}" ]; then
+		${DBG} "@root_sbindir@/e2scrub" "${dev}"
+	else
+		${DBG} "${SYSTEMCTL_PROG}" start "e2scrub@${dev}" 2> /dev/null
+		res=$?
+		if [ "${res}" -ne 0 ] && [ "${res}" -ne 1 ]; then
+			${DBG} "@root_sbindir@/e2scrub" "${dev}"
+		fi
+	fi
 done
 
 exitcode 0
diff --git a/scrub/e2scrub_all.service.in b/scrub/e2scrub_all.service.in
new file mode 100644
index 0000000..89a76e2
--- /dev/null
+++ b/scrub/e2scrub_all.service.in
@@ -0,0 +1,8 @@
+[Unit]
+Description=Online ext4 Metadata Check for All Filesystems
+ConditionACPower=true
+
+[Service]
+Type=oneshot
+Environment=SERVICE_MODE=1
+ExecStart=@root_sbindir@/e2scrub_all
diff --git a/scrub/e2scrub_all.timer.in b/scrub/e2scrub_all.timer.in
new file mode 100644
index 0000000..3d558bb
--- /dev/null
+++ b/scrub/e2scrub_all.timer.in
@@ -0,0 +1,11 @@
+[Unit]
+Description=Periodic ext4 Online Metadata Check for All Filesystems
+
+[Timer]
+# Run on Sunday at 3:10am, to avoid running afoul of DST changes
+OnCalendar=Sun *-*-* 03:10:00
+RandomizedDelaySec=60
+Persistent=true
+
+[Install]
+WantedBy=timers.target
diff --git a/scrub/e2scrub_fail.in b/scrub/e2scrub_fail.in
new file mode 100644
index 0000000..b95db1b
--- /dev/null
+++ b/scrub/e2scrub_fail.in
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# Email logs of failed e2scrub unit runs
+
+mailer=/usr/sbin/sendmail
+recipient="$1"
+test -z "${recipient}" && exit 0
+mntpoint="$2"
+test -z "${mntpoint}" && exit 0
+hostname="$(hostname -f 2>/dev/null)"
+test -z "${hostname}" && hostname="${HOSTNAME}"
+if [ ! -x "${mailer}" ]; then
+	echo "${mailer}: Mailer program not found."
+	exit 1
+fi
+
+(cat << ENDL
+To: $1
+From: <e2scrub@${hostname}>
+Subject: e2scrub failure on ${mntpoint}
+
+So sorry, the automatic e2scrub of ${mntpoint} on ${hostname} failed.
+
+A log of what happened follows:
+ENDL
+systemctl status --full --lines 4294967295 "e2scrub@${mntpoint}") | "${mailer}" -t -i
diff --git a/scrub/e2scrub_fail@.service.in b/scrub/e2scrub_fail@.service.in
new file mode 100644
index 0000000..df87949
--- /dev/null
+++ b/scrub/e2scrub_fail@.service.in
@@ -0,0 +1,10 @@
+[Unit]
+Description=Online ext4 Metadata Check Failure Reporting for %I
+
+[Service]
+Type=oneshot
+Environment=EMAIL_ADDR=root
+ExecStart=@pkglibdir@/e2scrub_fail "${EMAIL_ADDR}" %I
+User=mail
+Group=mail
+SupplementaryGroups=systemd-journal
diff --git a/util/subst.conf.in b/util/subst.conf.in
index effac78..f534f67 100644
--- a/util/subst.conf.in
+++ b/util/subst.conf.in
@@ -20,3 +20,5 @@ JDEV
 TDB_MAN_COMMENT		@TDB_MAN_COMMENT@
 root_sbindir		@root_sbindir@
 root_bindir		@root_bindir@
+pkglibdir		@pkglibdir@
+$exec_prefix		@exec_prefix@
