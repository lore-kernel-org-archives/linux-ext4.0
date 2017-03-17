From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] libext2fs: apply LDFLAGS when building tst_inline_data
Date: Fri, 17 Mar 2017 15:38:36 -0700
Message-ID: <20170317223836.61289-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35246 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdCQWlQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Mar 2017 18:41:16 -0400
Received: by mail-pf0-f196.google.com with SMTP id x63so9843245pfx.2
        for <linux-ext4@vger.kernel.org>; Fri, 17 Mar 2017 15:39:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

If libext2fs was compiled with an external libblkid pointed to by
LDFLAGS, then linking the tst_inline_data program failed because the
requested linker flags were not used.  Fix this by adding $(ALL_LDFLAGS)
to the build rule, as is done for the other test programs.

Fixes: 31253488385a ("libext2fs: add a unit test for inline data")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/ext2fs/Makefile.in | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 2081da82..425b8561 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -501,7 +501,8 @@ tst_inline: $(srcdir)/inline.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 tst_inline_data: inline_data.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR)
 	$(E) "	LD $@"
 	$(Q) $(CC) -o tst_inline_data $(srcdir)/inline_data.c $(ALL_CFLAGS) \
-	-DDEBUG $(STATIC_LIBEXT2FS) $(STATIC_LIBCOM_ERR) $(SYSLIBS)
+		$(ALL_LDFLAGS) -DDEBUG $(STATIC_LIBEXT2FS) \
+		$(STATIC_LIBCOM_ERR) $(SYSLIBS)
 
 tst_csum: csum.c $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBCOM_ERR) $(STATIC_LIBE2P) \
 		$(top_srcdir)/lib/e2p/e2p.h
-- 
2.12.0.367.g23dc2f6d3c-goog
