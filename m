From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH] ext4: fix xfstest generic/269 double revoked buffer bug
Date: Thu, 15 Oct 2015 09:23:18 +0900
Message-ID: <1444868598-16188-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbbJOAXH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2015 20:23:07 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NW8002WRJQH3200@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 15 Oct 2015 09:23:05 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When you repeatly execute xfstest generic/269 with bigalloc_1k option
enabled using the below command:

"./kvm-xfstests -c bigalloc_1k -m nodelalloc -C 1000 generic/269"

you can easily see the below bug message.

"JBD2 unexpected failure: jbd2_journal_revoke: !buffer_revoked(bh);"

This means that an already revoked buffer is erroneously revoked again
and it is caused by doing revoke for the buffer at the wrong position
in ext4_free_blocks(). We need to re-position the buffer revoke
procedure for an unspecified buffer after checking the cluster boundary
for bigalloc option. If not, some part of the cluster can be doubly
revoked.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
---
 fs/ext4/mballoc.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 34b610e..abea276 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4682,22 +4682,11 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	ext4_debug("freeing block %llu\n", block);
 	trace_ext4_free_blocks(inode, block, count, flags);
 
-	if (flags & EXT4_FREE_BLOCKS_FORGET) {
-		struct buffer_head *tbh = bh;
-		int i;
-
-		BUG_ON(bh && (count > 1));
+	if (bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		BUG_ON(count > 1);
 
-		for (i = 0; i < count; i++) {
-			cond_resched();
-			if (!bh)
-				tbh = sb_find_get_block(inode->i_sb,
-							block + i);
-			if (!tbh)
-				continue;
-			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
-				    inode, tbh, block + i);
-		}
+		ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
+			    inode, bh, block);
 	}
 
 	/*
@@ -4742,6 +4731,20 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			count += sbi->s_cluster_ratio - overflow;
 	}
 
+	if (!bh && (flags & EXT4_FREE_BLOCKS_FORGET)) {
+		int i;
+
+		for (i = 0; i < count; i++) {
+			cond_resched();
+			bh = sb_find_get_block(inode->i_sb,
+					       block + i);
+			if (!bh)
+				continue;
+			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
+				    inode, bh, block + i);
+		}
+	}
+
 do_more:
 	overflow = 0;
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
-- 
1.7.9.5

