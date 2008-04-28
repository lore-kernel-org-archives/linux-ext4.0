From: akpm@linux-foundation.org
Subject: - ext2-use-ext2_fsblk_t-type.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:20 -0700
Message-ID: <200804282200.m3SM0Kuf018685@imap1.linux-foundation.org>
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965548AbYD1WAX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:00:23 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext2: use ext2_fsblk_t type
has been removed from the -mm tree.  Its filename was
     ext2-use-ext2_fsblk_t-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext2: use ext2_fsblk_t type
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

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
idr-create-idr_layer_cache-at-boot-time.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch

