From: akpm@linux-foundation.org
Subject: [patch 263/307] ext2: use ext2_fsblk_t type
Date: Mon, 28 Apr 2008 02:16:02 -0700
Message-ID: <200804280916.m3S9G2hX019105@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, akinobu.mita@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760341AbYD1JUz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:20:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext2_fsblk_t type for filesystem-wide blocks number

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ext2/inode.c~ext2-use-ext2_fsblk_t-type fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext2-use-ext2_fsblk_t-type
+++ a/fs/ext2/inode.c
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
 
_
