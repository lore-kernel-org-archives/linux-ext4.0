From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/5] Fix tst_extents build
Date: Mon,  7 Apr 2008 22:00:56 -0500
Message-ID: <1207623660-1088-2-git-send-email-sandeen@redhat.com>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758425AbYDKSQD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:16:03 -0400
In-Reply-To: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

tst_extents needs libdl & libuuid to build, for me

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/Makefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 4f49575..1ed3b07 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -312,7 +312,7 @@ tst_extents: $(srcdir)/extent.c extent_dbg.c $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) $(
 	@$(CC) -o tst_extents $(srcdir)/extent.c extent_dbg.c \
 		$(ALL_CFLAGS) -DDEBUG $(DEBUG_OBJS) $(LIBSS) $(LIBE2P) \
 		$(LIBUUID) $(STATIC_LIBEXT2FS) $(LIBBLKID) $(LIBCOM_ERR) \
-		-I $(top_srcdir)/debugfs
+		-I $(top_srcdir)/debugfs -ldl -luuid
 
 tst_csum: tst_csum.c csum.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
-- 
1.5.4.1

