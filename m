From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] Fix build failures due to missing $(SYSLIBS)
Date: Fri, 19 Sep 2014 01:50:57 -0400
Message-ID: <1411105858-21120-3-git-send-email-tytso@mit.edu>
References: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36939 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615AbaISFvE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 01:51:04 -0400
In-Reply-To: <1411105858-21120-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Two link lines were missing $(SYSLIBS), which is needed for dietlibc.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in | 2 +-
 misc/Makefile.in       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 45e733c..f155233 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -476,7 +476,7 @@ tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 tst_inline_data: inline_data.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_inline_data $(srcdir)/inline_data.c $(ALL_CFLAGS) \
-	-DDEBUG $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR)
+	-DDEBUG $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) $(SYSLIBS)
 
 tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) $(STATIC_LIBE2P) \
 		$(top_srcdir)/lib/e2p/e2p.h
diff --git a/misc/Makefile.in b/misc/Makefile.in
index 0b59c0c..d4a02d3 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -351,7 +351,7 @@ e2fuzz: $(E2FUZZ_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
 		$(DEPLIBQUOTA) $(LIBEXT2FS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o e2fuzz $(E2FUZZ_OBJS) $(LIBS) \
-		$(LIBBLKID) $(LIBUUID) $(LIBEXT2FS)
+		$(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(SYSLIBS)
 
 filefrag: $(FILEFRAG_OBJS)
 	$(E) "	LD $@"
-- 
2.1.0

