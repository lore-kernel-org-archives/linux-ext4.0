From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: link the test programs with static libraries
Date: Mon, 24 Dec 2012 11:06:06 -0500
Message-ID: <1356365166-4684-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40145 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXQGI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Dec 2012 11:06:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Force the use of the static libraries when linking the test program so
that "make check" works when the shared libraries have not been
installed, and so that we test against the version of the libraries in
the source tree.

Reported-by: g.esp@free.fr
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in | 58 +++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 8eb2f7c..75d6125 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -219,45 +219,47 @@ ext2fs.pc: $(srcdir)/ext2fs.pc.in $(top_builddir)/config.status
 	$(E) "	CONFIG.STATUS $@"
 	$(Q) cd $(top_builddir); CONFIG_FILES=lib/ext2fs/ext2fs.pc ./config.status
 
-tst_badblocks: tst_badblocks.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_badblocks: tst_badblocks.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_badblocks tst_badblocks.o $(STATIC_LIBEXT2FS) \
-		$(LIBCOM_ERR)
+		$(STATIC_LIBCOM_ERR)
 
-tst_icount: $(srcdir)/icount.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_icount: $(srcdir)/icount.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_icount $(srcdir)/icount.c -DDEBUG $(ALL_CFLAGS) \
-		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
 
-tst_iscan: tst_iscan.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_iscan: tst_iscan.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
-	$(Q) $(CC) -o tst_iscan tst_iscan.o $(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+	$(Q) $(CC) -o tst_iscan tst_iscan.o $(STATIC_LIBEXT2FS) \
+		$(STATIC_LIBCOM_ERR)
 
-tst_getsize: tst_getsize.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_getsize: tst_getsize.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_getsize tst_getsize.o $(STATIC_LIBEXT2FS) \
-		$(LIBCOM_ERR)
+		$(STATIC_LIBCOM_ERR)
 
-tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_ismounted: $(srcdir)/ismounted.c $(STATIC_LIBEXT2FS) \
+		$(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_ismounted $(srcdir)/ismounted.c \
 		$(STATIC_LIBEXT2FS) -DDEBUG $(ALL_CFLAGS) \
-		$(LIBCOM_ERR) 
+		$(STATIC_LIBCOM_ERR)
 
-tst_byteswap: tst_byteswap.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_byteswap: tst_byteswap.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_byteswap tst_byteswap.o $(STATIC_LIBEXT2FS) \
-		$(LIBCOM_ERR)
+		$(STATIC_LIBCOM_ERR)
 
-tst_bitops: tst_bitops.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_bitops: tst_bitops.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_bitops tst_bitops.o $(ALL_CFLAGS) \
-		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
 
-tst_getsectsize: tst_getsectsize.o $(STATIC_LIBEXT2FS) $(DEPLIBCOM_ERR)
+tst_getsectsize: tst_getsectsize.o $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_sectgetsize tst_getsectsize.o \
-		$(STATIC_LIBEXT2FS) $(LIBCOM_ERR)
+		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
 
 tst_types.o: $(srcdir)/tst_types.c ext2_types.h 
 
@@ -363,30 +365,31 @@ tst_bitmaps_cmd.c: tst_bitmaps_cmd.ct
 	$(E) "	MK_CMDS $@"
 	$(Q) DIR=$(srcdir) $(MK_CMDS) $(srcdir)/tst_bitmaps_cmd.ct
 
-tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(STATIC_LIBEXT2FS) $(DEPLIBSS) \
-		$(DEPSTATIC_LIBCOM_ERR)
+tst_bitmaps: tst_bitmaps.o tst_bitmaps_cmd.o $(STATIC_LIBEXT2FS) \
+		$(DEPSTATIC_LIBSS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o $@ tst_bitmaps.o tst_bitmaps_cmd.o $(ALL_CFLAGS) \
-		$(STATIC_LIBEXT2FS) $(LIBSS) $(STATIC_LIBCOM_ERR)
+		$(STATIC_LIBEXT2FS) $(STATIC_LIBSS) $(STATIC_LIBCOM_ERR)
 
-tst_extents: $(srcdir)/extent.c $(DEBUG_OBJS) $(DEPLIBSS) \
-	$(LIBE2P) $(DEPLIBUUID) $(DEPLIBBLKID) $(DEPSTATIC_LIBCOM_ERR)
+tst_extents: $(srcdir)/extent.c $(DEBUG_OBJS) $(DEPSTATIC_LIBSS) \
+	$(STATIC_LIBE2P) $(DEPLIBUUID) $(DEPLIBBLKID) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_extents $(srcdir)/extent.c \
-		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
-		$(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) $(STATIC_LIBCOM_ERR) \
-		-I $(top_srcdir)/debugfs
+		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(STATIC_LIBSS) \
+		$(STATIC_LIBE2P) $(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBUUID) \
+		$(STATIC_LIBCOM_ERR) -I $(top_srcdir)/debugfs
 
 tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_inline $(srcdir)/inline.c $(ALL_CFLAGS) -DDEBUG \
 		$(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
 
-tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) \
+tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) $(STATIC_LIBE2P) \
 		$(top_srcdir)/lib/e2p/e2p.h
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_csum $(srcdir)/csum.c -DDEBUG \
-		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) $(LIBE2P)
+		$(ALL_CFLAGS) $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) \
+		$(STATIC_LIBE2P)
 
 tst_crc32c: $(srcdir)/crc32c.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(Q) $(CC) $(BUILD_LDFLAGS) $(ALL_CFLAGS) -o tst_crc32c $(srcdir)/crc32c.c \
@@ -453,7 +456,8 @@ clean::
 		tst_badblocks tst_iscan ext2_err.et ext2_err.c ext2_err.h \
 		tst_byteswap tst_ismounted tst_getsize tst_sectgetsize \
 		tst_bitops tst_types tst_icount tst_super_size tst_csum \
-		tst_bitmaps tst_bitmaps_out tst_bitmaps_cmd.c \
+		tst_bitmaps tst_bitmaps_out tst_extents tst_inline \
+		tst_inline_data tst_inode_size tst_bitmaps_cmd.c \
 		ext2_tdbtool mkjournal debug_cmds.c extent_cmds.c \
 		../libext2fs.a ../libext2fs_p.a ../libext2fs_chk.a \
 		crc32c_table.h gen_crc32ctable tst_crc32c
-- 
1.7.12.rc0.22.gcdd159b

