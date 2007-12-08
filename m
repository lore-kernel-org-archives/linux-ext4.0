From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext[234]: remove unused argument for ext[234]_find_goal()
Date: Sun, 9 Dec 2007 00:36:10 +0900
Message-ID: <20071208153610.GD4878@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:18734 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbXLHPhA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2007 10:37:00 -0500
Received: by py-out-1112.google.com with SMTP id u77so2286131pyb
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2007 07:36:59 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The argument chain for ext[234]_find_goal() is not used.
This patch removes it and fixes comment as well.

Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: adilger@clusterfs.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/ext2/inode.c |    7 ++-----
 fs/ext3/inode.c |    8 +++-----
 fs/ext4/inode.c |    8 +++-----
 3 files changed, 8 insertions(+), 15 deletions(-)

Index: 2.6-git/fs/ext2/inode.c
===================================================================
--- 2.6-git.orig/fs/ext2/inode.c
+++ 2.6-git/fs/ext2/inode.c
@@ -286,15 +286,12 @@ static unsigned long ext2_find_near(stru
  *	ext2_find_goal - find a prefered place for allocation.
  *	@inode: owner
  *	@block:  block we want
- *	@chain:  chain of indirect blocks
  *	@partial: pointer to the last triple within a chain
  *
  *	Returns preferred place for a block (the goal).
  */
 
-static inline int ext2_find_goal(struct inode *inode,
-				 long block,
-				 Indirect chain[4],
+static inline int ext2_find_goal(struct inode *inode, long block,
 				 Indirect *partial)
 {
 	struct ext2_block_alloc_info *block_i;
@@ -639,7 +636,7 @@ reread:
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext2_init_block_alloc_info(inode);
 
-	goal = ext2_find_goal(inode, iblock, chain, partial);
+	goal = ext2_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
Index: 2.6-git/fs/ext3/inode.c
===================================================================
--- 2.6-git.orig/fs/ext3/inode.c
+++ 2.6-git/fs/ext3/inode.c
@@ -439,16 +439,14 @@ static ext3_fsblk_t ext3_find_near(struc
  *	ext3_find_goal - find a prefered place for allocation.
  *	@inode: owner
  *	@block:  block we want
- *	@chain:  chain of indirect blocks
  *	@partial: pointer to the last triple within a chain
- *	@goal:	place to store the result.
  *
  *	Normally this function find the prefered place for block allocation,
- *	stores it in *@goal and returns zero.
+ *	returns it.
  */
 
 static ext3_fsblk_t ext3_find_goal(struct inode *inode, long block,
-		Indirect chain[4], Indirect *partial)
+				   Indirect *partial)
 {
 	struct ext3_block_alloc_info *block_i;
 
@@ -884,7 +882,7 @@ int ext3_get_blocks_handle(handle_t *han
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext3_init_block_alloc_info(inode);
 
-	goal = ext3_find_goal(inode, iblock, chain, partial);
+	goal = ext3_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
Index: 2.6-git/fs/ext4/inode.c
===================================================================
--- 2.6-git.orig/fs/ext4/inode.c
+++ 2.6-git/fs/ext4/inode.c
@@ -437,16 +437,14 @@ static ext4_fsblk_t ext4_find_near(struc
  *	ext4_find_goal - find a prefered place for allocation.
  *	@inode: owner
  *	@block:  block we want
- *	@chain:  chain of indirect blocks
  *	@partial: pointer to the last triple within a chain
- *	@goal:	place to store the result.
  *
  *	Normally this function find the prefered place for block allocation,
- *	stores it in *@goal and returns zero.
+ *	returns it.
  */
 
 static ext4_fsblk_t ext4_find_goal(struct inode *inode, long block,
-		Indirect chain[4], Indirect *partial)
+				   Indirect *partial)
 {
 	struct ext4_block_alloc_info *block_i;
 
@@ -883,7 +881,7 @@ int ext4_get_blocks_handle(handle_t *han
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext4_init_block_alloc_info(inode);
 
-	goal = ext4_find_goal(inode, iblock, chain, partial);
+	goal = ext4_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
