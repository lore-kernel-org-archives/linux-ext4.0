From: Liu Bo <bo.li.liu@oracle.com>
Subject: [PATCH] E2fsprogs: introduce FIEMAP_EXTENT_SHARED support
Date: Mon, 16 Sep 2013 15:41:24 +0800
Message-ID: <1379317284-20311-1-git-send-email-bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jeff.liu@oracle.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41802 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3IPHlk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Sep 2013 03:41:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Filesystems, such as ocfs2 and btrfs, support shared space that is
shared among different files, so the upstream introduces flag
FIEMAP_EXTENT_SHARED for that.

With this, e2fsprogs's filefrag also support the flag.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 lib/ext2fs/fiemap.h |    2 ++
 misc/filefrag.c     |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/fiemap.h b/lib/ext2fs/fiemap.h
index 30bf555..895cd0b 100644
--- a/lib/ext2fs/fiemap.h
+++ b/lib/ext2fs/fiemap.h
@@ -64,5 +64,7 @@ struct fiemap {
 #define FIEMAP_EXTENT_MERGED		0x00001000 /* File does not natively
 						    * support extents. Result
 						    * merged for efficiency. */
+#define FIEMAP_EXTENT_SHARED		0x00002000 /* Space shared with other
+						    * files. */
 
 #endif /* _LINUX_FIEMAP_H */
diff --git a/misc/filefrag.c b/misc/filefrag.c
index 35b3544..31dfb64 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -165,6 +165,8 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 		strcat(flags, "unwritten,");
 	if (fm_extent->fe_flags & FIEMAP_EXTENT_MERGED)
 		strcat(flags, "merged,");
+	if (fm_extent->fe_flags & FIEMAP_EXTENT_SHARED)
+		strcat(flags, "shared,");
 
 	if (fm_extent->fe_logical + fm_extent->fe_length >= (__u64) st->st_size)
 		strcat(flags, "eof,");
-- 
1.7.7

