From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH e2fsprogs] fuse2fs: needs SYSLIBS
Date: Wed, 22 Jun 2016 20:58:53 -0300
Message-ID: <1466639933-8892-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([176.9.42.171]:34786 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcFVX7A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2016 19:59:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It otherwise leads to build failure when using an unbundled libintl.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 misc/Makefile.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/Makefile.in b/misc/Makefile.in
index f67c9c7..e487692 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -389,7 +389,7 @@ fuse2fs: $(FUSE2FS_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o fuse2fs $(FUSE2FS_OBJS) $(LIBS) \
 		$(LIBFUSE) $(LIBBLKID) $(LIBUUID) $(LIBEXT2FS) $(LIBINTL) \
-		$(CLOCK_GETTIME_LIB)
+		$(CLOCK_GETTIME_LIB) $(SYSLIBS)
 
 journal.o: $(srcdir)/../debugfs/journal.c
 	$(E) "	CC $@"
-- 
2.7.3

