From: Ikey Doherty <michael.i.doherty@intel.com>
Subject: [PATCH] Support a stateless configuration by default
Date: Fri, 22 May 2015 15:57:00 +0100
Message-ID: <1432306620-6368-1-git-send-email-michael.i.doherty@intel.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:52352 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbbEVO5a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 May 2015 10:57:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With this change, distribution defaults are now read from the distribution defaults
directory, /usr/share/defaults/e2fsprogs. These files are expected to be the
sensible defaults required for basic operation.

Site administrators may still override the default configuration by placing the
files within the site config directory (i.e. /etc) - and those configuration values
will be read instead. The distribution files within the defaults directory are
percieved as immutable, and as such resiliant to upgrades over time.

A side effect of this stateless configuration is that a site admiministrator is
able to reset their configuration to the sane defaults by simply removing the files
they placed within the site configuration directory.

To users already making use of an altered configuration within /etc, this change
is transparent and does not affect existing operation.

The fundamental goal within this change, and stateless itself, is to separate
OS configuration from the system administrator configuration.

Signed-off-by: Ikey Doherty <michael.i.doherty@intel.com>
---
 MCONFIG.in         |  1 +
 configure.in       |  2 ++
 e2fsck/unix.c      |  6 ++++--
 ext2ed/Makefile.in |  4 ++--
 lib/dirpaths.h.in  |  3 +++
 misc/Makefile.in   | 36 ++++++++++++++++++------------------
 misc/mke2fs.c      |  4 ++++
 util/subst.conf.in |  1 +
 8 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index 29505da..5b5e054 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -21,6 +21,7 @@ libdir = @libdir@
 datadir= @datadir@
 localedir = $(datadir)/locale
 root_sysconfdir= @root_sysconfdir@
+confdir= @confdir@
 includedir = @includedir@
 mandir = @mandir@
 man1dir = $(mandir)/man1
diff --git a/configure.in b/configure.in
index 9a18617..2bcd81e 100644
--- a/configure.in
+++ b/configure.in
@@ -1268,11 +1268,13 @@ if test "$sysconfdir" != '${prefix}/etc'; then
     root_sysconfdir=$sysconfdir
     AC_MSG_RESULT([Setting root_sysconfdir to $root_sysconfdir])
 fi
+confdir=$datadir/defaults/e2fsprogs
 AC_SUBST(root_prefix)
 AC_SUBST(root_bindir)
 AC_SUBST(root_sbindir)
 AC_SUBST(root_libdir)
 AC_SUBST(root_sysconfdir)
+AC_SUBST(confdir)
 dnl
 dnl Allow specification of the multiarch arch
 dnl
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9ef4b1e..57b08aa 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -755,6 +755,7 @@ static void syntax_err_report(const char *filename, long err, int line_num)
 }
 
 static const char *config_fn[] = { ROOT_SYSCONFDIR "/e2fsck.conf", 0 };
+static const char *config_default_fn[] = { DEFAULT_CONFDIR "e2fsck.conf", 0};
 
 static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 {
@@ -996,8 +997,9 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if ((cp = getenv("E2FSCK_CONFIG")) != NULL)
 		config_fn[0] = cp;
 	profile_set_syntax_err_cb(syntax_err_report);
-	profile_init(config_fn, &ctx->profile);
-
+	retval = profile_init(config_fn, &ctx->profile);
+	if (retval == ENOENT)
+		retval = profile_init(config_default_fn, &ctx->profile);
 	profile_get_boolean(ctx->profile, "options", "report_time", 0, 0,
 			    &c);
 	if (c)
diff --git a/ext2ed/Makefile.in b/ext2ed/Makefile.in
index 0697431..f1853e1 100644
--- a/ext2ed/Makefile.in
+++ b/ext2ed/Makefile.in
@@ -71,10 +71,10 @@ clean::
 	-rmdir doc
 
 install: ext2ed
-	install -d $(root_sysconfdir)
+	install -d $(confdir)
 	install -m 755 ext2ed $(sbindir)
 	install -m 644 $(srcdir)/ext2.descriptors $(datadir)
-	install -m 644 ext2ed.conf $(root_sysconfdir)
+	install -m 644 ext2ed.conf $(confdir)
 	install -m 644 ext2ed.8 $(man8dir)
 
 # +++ Dependency line eater +++
diff --git a/lib/dirpaths.h.in b/lib/dirpaths.h.in
index 6ccb55b..e99020f 100644
--- a/lib/dirpaths.h.in
+++ b/lib/dirpaths.h.in
@@ -8,3 +8,6 @@
 
 /* Where to find the mke2fs.conf and e2fsck.conf files */
 #define ROOT_SYSCONFDIR		"@root_sysconfdir@"
+
+/* Where to find the default mke2fs.conf and e2fsck.conf files */
+#define DEFAULT_CONFDIR		"@datadir@/defaults/e2fsprogs"
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 872d8b7..287253d 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -486,12 +486,12 @@ filefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/filefrag.8.in
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/filefrag.8.in filefrag.8
 
 installdirs:
-	$(E) "	MKINSTALLDIRS $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(root_sysconfdir)"
+	$(E) "	MKINSTALLDIRS $(sbindir) $(root_sbindir) $(bindir) $(man1dir) $(man8dir) $(libdir) $(confdir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(sbindir) \
 		$(DESTDIR)$(root_sbindir) $(DESTDIR)$(bindir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man8dir) \
 		$(DESTDIR)$(man1dir) $(DESTDIR)$(man5dir) \
-		$(DESTDIR)$(libdir) $(DESTDIR)/$(root_sysconfdir)
+		$(DESTDIR)$(libdir) $(DESTDIR)/$(confdir)
 
 install: all $(SMANPAGES) $(UMANPAGES) installdirs
 	$(Q) for i in $(SPROGS); do \
@@ -555,33 +555,33 @@ install: all $(SMANPAGES) $(UMANPAGES) installdirs
 		(cd $(DESTDIR)$(man5dir); \
 			$(LN) $(LINK_INSTALL_FLAGS) ext4.5 $$i.5); \
 	done
-	$(Q) if test -f $(DESTDIR)$(root_sysconfdir)/mke2fs.conf; then \
-		if cmp -s $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
+	$(Q) if test -f $(DESTDIR)$(confdir)/mke2fs.conf; then \
+		if cmp -s $(DESTDIR)$(confdir)/mke2fs.conf \
 			mke2fs.conf; then \
 			true; \
 		else \
-			if grep -q ext4dev $(DESTDIR)$(root_sysconfdir)/mke2fs.conf ; then \
-				$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
+			if grep -q ext4dev $(DESTDIR)$(confdir)/mke2fs.conf ; then \
+				$(ES) "	INSTALL_DATA $(confdir)/mke2fs.conf.e2fsprogs-new"; \
 				$(INSTALL_DATA) mke2fs.conf \
-					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new; \
-				echo "Warning: installing mke2fs.conf in $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-new"; \
-				echo "Check to see if you need to update your $(root_sysconfdir)/mke2fs.conf"; \
+					$(DESTDIR)$(confdir)/mke2fs.conf.e2fsprogs-new; \
+				echo "Warning: installing mke2fs.conf in $(DESTDIR)$(confdir)/mke2fs.conf.e2fsprogs-new"; \
+				echo "Check to see if you need to update your $(confdir)/mke2fs.conf"; \
 			else \
-				$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
-				mv $(DESTDIR)$(root_sysconfdir)/mke2fs.conf \
-				   $(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old; \
+				$(ES) "	INSTALL_DATA $(confdir)/mke2fs.conf"; \
+				mv $(DESTDIR)$(confdir)/mke2fs.conf \
+				   $(DESTDIR)$(confdir)/mke2fs.conf.e2fsprogs-old; \
 				$(INSTALL_DATA) mke2fs.conf \
-					$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
+					$(DESTDIR)$(confdir)/mke2fs.conf; \
 				echo "Your mke2fs.conf is too old.  Backing up old version in"; \
-				echo "$(DESTDIR)$(root_sysconfdir)/mke2fs.conf.e2fsprogs-old.  Please check to see"; \
+				echo "$(DESTDIR)$(confdir)/mke2fs.conf.e2fsprogs-old.  Please check to see"; \
 				echo "if you have any local customizations that you wish to preserve."; \
 			fi; \
 			echo " "; \
 		fi; \
 	else \
-		$(ES) "	INSTALL_DATA $(root_sysconfdir)/mke2fs.conf"; \
+		$(ES) "	INSTALL_DATA $(confdir)/mke2fs.conf"; \
 		$(INSTALL_DATA) mke2fs.conf \
-			$(DESTDIR)$(root_sysconfdir)/mke2fs.conf; \
+			$(DESTDIR)$(confdir)/mke2fs.conf; \
 	fi
 
 install-strip: install
@@ -636,8 +636,8 @@ uninstall:
 		$(ES) "	LINK $$i.5"; \
 		$(RM) -f $(DESTDIR)$(man5dir)/$$i.5; \
 	done
-	if cmp -s mke2fs.conf $(DESTDIR)/$(root_sysconfdir)/mke2fs.conf; then \
-		$(RM) $(DESTDIR)/$(root_sysconfdir)/mke2fs.conf; \
+	if cmp -s mke2fs.conf $(DESTDIR)/$(confdir)/mke2fs.conf; then \
+		$(RM) $(DESTDIR)/$(confdir)/mke2fs.conf; \
 	fi
 
 clean::
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 78b1252..6c07fd1 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1104,6 +1104,7 @@ static void syntax_err_report(const char *filename, long err, int line_num)
 }
 
 static const char *config_fn[] = { ROOT_SYSCONFDIR "/mke2fs.conf", 0 };
+static const char *config_default_fn[] = { DEFAULT_CONFDIR "/mke2fs.conf", 0};
 
 static void edit_feature(const char *str, __u32 *compat_array)
 {
@@ -1521,6 +1522,9 @@ static void PRS(int argc, char *argv[])
 	profile_set_syntax_err_cb(syntax_err_report);
 	retval = profile_init(config_fn, &profile);
 	if (retval == ENOENT) {
+		retval = profile_init(config_default_fn, &profile);
+	}
+	if (retval == ENOENT) {
 		retval = profile_init(default_files, &profile);
 		if (retval)
 			goto profile_error;
diff --git a/util/subst.conf.in b/util/subst.conf.in
index 64fde7a..8793509 100644
--- a/util/subst.conf.in
+++ b/util/subst.conf.in
@@ -12,6 +12,7 @@ SIZEOF_SHORT		@SIZEOF_SHORT@
 datarootdir		@datarootdir@
 datadir			@datadir@
 root_sysconfdir		@root_sysconfdir@
+confdir			@confdir@
 $datarootdir		@datarootdir@
 $root_prefix		@root_prefix@
 $prefix			@prefix@
-- 
1.9.1

---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

