From: David Michael <fedora.dm0@gmail.com>
Subject: [PATCH] e2fsprogs: add a make variable for the pkgconfig install dir
Date: Wed, 30 Apr 2014 22:18:03 -0400
Message-ID: <87tx9ajl7o.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:51049 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaEACR1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Apr 2014 22:17:27 -0400
Received: by mail-qg0-f44.google.com with SMTP id i50so1421773qgf.3
        for <linux-ext4@vger.kernel.org>; Wed, 30 Apr 2014 19:17:26 -0700 (PDT)
Received: from callisto (c-68-81-204-146.hsd1.pa.comcast.net. [68.81.204.146])
        by mx.google.com with ESMTPSA id n3sm49546265qaf.36.2014.04.30.19.17.25
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Apr 2014 19:17:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Adding the pkgconfigdir variable allows specifying an installation
location for pkg-config files independent of libdir.

Signed-off-by: David Michael <fedora.dm0@gmail.com>
---

Hi,

Can something like this be applied to be able to install pkg-config
files to somewhere in PKG_CONFIG_PATH that doesn't depend on the value
of $(libdir)?

Thanks.

David


 MCONFIG.in             | 1 +
 lib/blkid/Makefile.in  | 8 ++++----
 lib/e2p/Makefile.in    | 8 ++++----
 lib/et/Makefile.in     | 8 ++++----
 lib/ext2fs/Makefile.in | 8 ++++----
 lib/quota/Makefile.in  | 8 ++++----
 lib/ss/Makefile.in     | 8 ++++----
 lib/uuid/Makefile.in   | 8 ++++----
 8 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/MCONFIG.in b/MCONFIG.in
index 9b411d6..d47847c 100644
--- a/MCONFIG.in
+++ b/MCONFIG.in
@@ -29,6 +29,7 @@ man5dir = $(mandir)/man5
 man8dir = $(mandir)/man8
 infodir = @infodir@
 datadir = @datadir@
+pkgconfigdir = $(libdir)/pkgconfig
 
 @SET_MAKE@
 
diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 69b5b4c..f18d422 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -149,7 +149,7 @@ blkid.pc: $(srcdir)/blkid.pc.in $(top_builddir)/config.status
 installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/blkid"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
-		$(DESTDIR)$(includedir)/blkid $(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(includedir)/blkid $(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs 
 	$(E) "	INSTALL_DATA $(libdir)/libblkid.a"
@@ -164,12 +164,12 @@ install:: all installdirs
 		echo "	INSTALL_DATA $(man3dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man3dir)/$$i; \
 	done
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/blkid.pc"
-	$(Q) $(INSTALL_DATA) blkid.pc $(DESTDIR)$(libdir)/pkgconfig/blkid.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/blkid.pc"
+	$(Q) $(INSTALL_DATA) blkid.pc $(DESTDIR)$(pkgconfigdir)/blkid.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libblkid.a \
-		$(DESTDIR)$(libdir)/pkgconfig/blkid.pc
+		$(DESTDIR)$(pkgconfigdir)/blkid.pc
 	$(RM) -rf $(DESTDIR)$(includedir)/blkid
 	for i in $(SMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man3dir)/$$i; \
diff --git a/lib/e2p/Makefile.in b/lib/e2p/Makefile.in
index 761ac48..f87b164 100644
--- a/lib/e2p/Makefile.in
+++ b/lib/e2p/Makefile.in
@@ -83,7 +83,7 @@ check::	tst_ostype tst_feature
 installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/e2p"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
-		$(DESTDIR)$(includedir)/e2p $(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(includedir)/e2p $(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs 
 	$(E) "	INSTALL_DATA $(libdir)/libe2p.a"
@@ -94,12 +94,12 @@ install:: all installdirs
 	  echo "	INSTALL_DATA $(includedir)/e2p/$$i"; \
 	  $(INSTALL_DATA) $(srcdir)/$$i $(DESTDIR)$(includedir)/e2p/$$i; \
 	done
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/e2p.pc"
-	$(Q) $(INSTALL_DATA) e2p.pc $(DESTDIR)$(libdir)/pkgconfig/e2p.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/e2p.pc"
+	$(Q) $(INSTALL_DATA) e2p.pc $(DESTDIR)$(pkgconfigdir)/e2p.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libe2p.a \
-		$(DESTDIR)$(libdir)/pkgconfig/e2p.pc
+		$(DESTDIR)$(pkgconfigdir)/e2p.pc
 	$(RM) -rf $(DESTDIR)$(includedir)/e2p
 
 clean::
diff --git a/lib/et/Makefile.in b/lib/et/Makefile.in
index 4f2d31f..9fdf988 100644
--- a/lib/et/Makefile.in
+++ b/lib/et/Makefile.in
@@ -106,7 +106,7 @@ installdirs::
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/et $(DESTDIR)$(datadir)/et \
 		$(DESTDIR)$(bindir) $(DESTDIR)$(man1dir) \
-		$(DESTDIR)$(man3dir) $(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(man3dir) $(DESTDIR)$(pkgconfigdir)
 
 install:: compile_et libcom_err.a $(HFILES) installdirs com_err.pc
 	$(E) "	INSTALL_DATA $(libdir)/libcom_err.a"
@@ -130,13 +130,13 @@ install:: compile_et libcom_err.a $(HFILES) installdirs com_err.pc
 	$(E) "	INSTALL_DATA $(man1dir)/compile_et.1"
 	$(Q) $(INSTALL_DATA) $(srcdir)/compile_et.1 \
 			$(DESTDIR)$(man1dir)/compile_et.1
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/com_err.pc"
-	$(Q) $(INSTALL_DATA) com_err.pc $(DESTDIR)$(libdir)/pkgconfig/com_err.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/com_err.pc"
+	$(Q) $(INSTALL_DATA) com_err.pc $(DESTDIR)$(pkgconfigdir)/com_err.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libcom_err.a \
 		$(DESTDIR)$(bindir)/compile_et \
-		$(DESTDIR)$(libdir)/pkgconfig/com_err.pc
+		$(DESTDIR)$(pkgconfigdir)/com_err.pc
 	$(RM) -rf $(DESTDIR)$(includedir)/et $(DESTDIR)$(datadir)/et
 
 check:: compile_et
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 0c880c7..135272a 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -450,7 +450,7 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
-		$(DESTDIR)$(includedir)/ext2fs $(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(includedir)/ext2fs $(DESTDIR)$(pkgconfigdir)
 
 install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
 	$(E) "	INSTALL_DATA $(libdir)/libext2fs.a"
@@ -465,12 +465,12 @@ install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
 		echo "	INSTALL_DATA $(includedir)/ext2fs/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(includedir)/ext2fs/$$i; \
 	done
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/ext2fs.pc"
-	$(Q) $(INSTALL_DATA) ext2fs.pc $(DESTDIR)$(libdir)/pkgconfig/ext2fs.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/ext2fs.pc"
+	$(Q) $(INSTALL_DATA) ext2fs.pc $(DESTDIR)$(pkgconfigdir)/ext2fs.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libext2fs.a \
-		$(DESTDIR)$(libdir)/pkgconfig/ext2fs.pc
+		$(DESTDIR)$(pkgconfigdir)/ext2fs.pc
 	$(RM) -rf $(DESTDIR)$(includedir)/ext2fs 
 
 clean::
diff --git a/lib/quota/Makefile.in b/lib/quota/Makefile.in
index 0344d09..6de70c7 100644
--- a/lib/quota/Makefile.in
+++ b/lib/quota/Makefile.in
@@ -76,7 +76,7 @@ installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/quota $(man3dir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
 		$(DESTDIR)$(includedir)/quota $(DESTDIR)$(man3dir) \
-		$(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs
 	$(E) "	INSTALL_DATA $(libdir)/libquota.a"
@@ -90,12 +90,12 @@ install:: all installdirs
 		echo "	INSTALL_DATA $(man3dir)/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(man3dir)/$$i; \
 	done
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/quota.pc"
-	$(Q) $(INSTALL_DATA) quota.pc $(DESTDIR)$(libdir)/pkgconfig/quota.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/quota.pc"
+	$(Q) $(INSTALL_DATA) quota.pc $(DESTDIR)$(pkgconfigdir)/quota.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libquota.a \
-		$(DESTDIR)$(libdir)/pkgconfig/quota.pc
+		$(DESTDIR)$(pkgconfigdir)/quota.pc
 	for i in $(SMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man3dir)/$$i; \
 	done
diff --git a/lib/ss/Makefile.in b/lib/ss/Makefile.in
index 4c1ef8f..14597c9 100644
--- a/lib/ss/Makefile.in
+++ b/lib/ss/Makefile.in
@@ -129,7 +129,7 @@ installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ss $(datadir)/ss $(bindir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir) \
 		$(DESTDIR)$(includedir)/ss $(DESTDIR)$(datadir)/ss \
-		$(DESTDIR)$(bindir) $(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(bindir) $(DESTDIR)$(pkgconfigdir)
 
 install:: libss.a $(INSTALL_HFILES) installdirs ss_err.h mk_cmds ss.pc
 	$(E) "	INSTALL_DATA $(DESTDIR)$(libdir)/libss.a"
@@ -151,12 +151,12 @@ install:: libss.a $(INSTALL_HFILES) installdirs ss_err.h mk_cmds ss.pc
 	$(Q) $(INSTALL) mk_cmds $(DESTDIR)$(bindir)/mk_cmds
 	$(E) "	INSTALL_DATA $(man1dir)/mk_cmds.1"
 	$(Q) $(INSTALL_DATA) $(srcdir)/mk_cmds.1 $(DESTDIR)$(man1dir)/mk_cmds.1
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/ss.pc"
-	$(Q) $(INSTALL_DATA) ss.pc $(DESTDIR)$(libdir)/pkgconfig/ss.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/ss.pc"
+	$(Q) $(INSTALL_DATA) ss.pc $(DESTDIR)$(pkgconfigdir)/ss.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libss.a $(DESTDIR)$(bindir)/mk_cmds \
-		$(DESTDIR)$(libdir)/pkgconfig/ss.pc \
+		$(DESTDIR)$(pkgconfigdir)/ss.pc \
 		$(DESTDIR)$(man1dir)/mk_cmds.1 
 	$(RM) -rf $(DESTDIR)$(includedir)/ss $(DESTDIR)$(datadir)/ss
 
diff --git a/lib/uuid/Makefile.in b/lib/uuid/Makefile.in
index f5b767e..62a8f70 100644
--- a/lib/uuid/Makefile.in
+++ b/lib/uuid/Makefile.in
@@ -135,7 +135,7 @@ installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/uuid $(man3dir)"
 	$(Q) $(MKINSTALLDIRS) $(DESTDIR)$(libdir)  \
 		$(DESTDIR)$(includedir)/uuid $(DESTDIR)$(man3dir) \
-		$(DESTDIR)$(libdir)/pkgconfig
+		$(DESTDIR)$(pkgconfigdir)
 
 install:: all installdirs 
 	$(E) "	INSTALL_DATA $(libdir)/libuuid.a"
@@ -157,12 +157,12 @@ install:: all installdirs
 	$(E) "	LINK $(man3dir)/uuid_generate_time.3"
 	$(Q) (cd $(DESTDIR)$(man3dir); \
 	    $(LN) $(LINK_INSTALL_FLAGS) uuid_generate.3 uuid_generate_time.3)
-	$(E) "	INSTALL_DATA $(libdir)/pkgconfig/uuid.pc"
-	$(Q) $(INSTALL_DATA) uuid.pc $(DESTDIR)$(libdir)/pkgconfig/uuid.pc
+	$(E) "	INSTALL_DATA $(pkgconfigdir)/uuid.pc"
+	$(Q) $(INSTALL_DATA) uuid.pc $(DESTDIR)$(pkgconfigdir)/uuid.pc
 
 uninstall::
 	$(RM) -f $(DESTDIR)$(libdir)/libuuid.a \
-		$(DESTDIR)$(libdir)/pkgconfig/uuid.pc
+		$(DESTDIR)$(pkgconfigdir)/uuid.pc
 	for i in $(SMANPAGES); do \
 		$(RM) -f $(DESTDIR)$(man3dir)/$$i; \
 	done
-- 
1.9.0

