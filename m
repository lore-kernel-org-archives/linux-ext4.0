From: David Woodhouse <dwmw2@infradead.org>
Subject: [EXT2] Discard unused sectors
Date: Thu, 14 Aug 2008 09:59:39 +0100
Message-ID: <1218704379.4620.46.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33530 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYHNI7l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Aug 2008 04:59:41 -0400
Received: from pmac.infradead.org ([2001:8b0:10b:1:20d:93ff:fe7a:3f2c])
	by bombadil.infradead.org with esmtpsa (Exim 4.68 #1 (Red Hat Linux))
	id 1KTYgH-0003vZ-3K
	for linux-ext4@vger.kernel.org; Thu, 14 Aug 2008 08:59:41 +0000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a file is deleted, tell the block device that we don't care about
its blocks any more.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
For linux-next, where sb_issue_discard() has been implemented.
http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/for-next

 fs/ext2/balloc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 10bb02c..03fc2dc 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
+#include <linux/blkdev.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -478,13 +479,13 @@ void ext2_discard_reservation(struct inode *inode)
 }
 
 /**
- * ext2_free_blocks_sb() -- Free given blocks and update quota and i_blocks
+ * ext2_free_blocks() -- Free given blocks and update quota and i_blocks
  * @inode:		inode
  * @block:		start physcial block to free
  * @count:		number of blocks to free
  */
-void ext2_free_blocks (struct inode * inode, unsigned long block,
-		       unsigned long count)
+void ext2_free_blocks(struct inode * inode, unsigned long block,
+		      unsigned long count)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head * bh2;
@@ -555,6 +556,8 @@ do_more:
 		}
 	}
 
+	sb_issue_discard(sb, block, count);
+
 	mark_buffer_dirty(bitmap_bh);
 	if (sb->s_flags & MS_SYNCHRONOUS)
 		sync_dirty_buffer(bitmap_bh);
-- 
1.5.5.1


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



