From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/3] ext2: use ext2_fsblk_t type
Date: Sun, 17 Feb 2008 15:00:03 +0900
Message-ID: <20080217060002.GC3390@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:39968 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYBQGGV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2008 01:06:21 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2074201wah.23
        for <linux-ext4@vger.kernel.org>; Sat, 16 Feb 2008 22:06:20 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext2_fsblk_t type for filesystem-wide blocks number

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext2/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: 2.6-rc/fs/ext2/inode.c
===================================================================
--- 2.6-rc.orig/fs/ext2/inode.c
+++ 2.6-rc/fs/ext2/inode.c
@@ -254,13 +254,13 @@ no_block:
  *	Caller must make sure that @ind is valid and will stay that way.
  */
 
-static unsigned long ext2_find_near(struct inode *inode, Indirect *ind)
+static ext2_fsblk_t ext2_find_near(struct inode *inode, Indirect *ind)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	__le32 *start = ind->bh ? (__le32 *) ind->bh->b_data : ei->i_data;
 	__le32 *p;
-	unsigned long bg_start;
-	unsigned long colour;
+	ext2_fsblk_t bg_start;
+	ext2_fsblk_t colour;
 
 	/* Try to find previous block */
 	for (p = ind->p - 1; p >= start; p--)
@@ -290,8 +290,8 @@ static unsigned long ext2_find_near(stru
  *	Returns preferred place for a block (the goal).
  */
 
-static inline int ext2_find_goal(struct inode *inode, long block,
-				 Indirect *partial)
+static inline ext2_fsblk_t ext2_find_goal(struct inode *inode, long block,
+					  Indirect *partial)
 {
 	struct ext2_block_alloc_info *block_i;
 
