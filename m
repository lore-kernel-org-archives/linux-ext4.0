From: akpm@linux-foundation.org
Subject: - ext-remove-unused-argument-for-ext_find_goal.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:48 -0800
Message-ID: <200802070030.m170UTWN007395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext[234]: remove unused argument for ext[234]_find_goal()
has been removed from the -mm tree.  Its filename was
     ext-remove-unused-argument-for-ext_find_goal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext[234]: remove unused argument for ext[234]_find_goal()
From: Akinobu Mita <akinobu.mita@gmail.com>

The argument chain for ext[234]_find_goal() is not used.  This patch removes
it and fixes comment as well.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    7 ++-----
 fs/ext3/inode.c |    8 +++-----
 fs/ext4/inode.c |    9 +++------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff -puN fs/ext2/inode.c~ext-remove-unused-argument-for-ext_find_goal fs/ext2/inode.c
--- a/fs/ext2/inode.c~ext-remove-unused-argument-for-ext_find_goal
+++ a/fs/ext2/inode.c
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
@@ -638,7 +635,7 @@ reread:
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext2_init_block_alloc_info(inode);
 
-	goal = ext2_find_goal(inode, iblock, chain, partial);
+	goal = ext2_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
diff -puN fs/ext3/inode.c~ext-remove-unused-argument-for-ext_find_goal fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext-remove-unused-argument-for-ext_find_goal
+++ a/fs/ext3/inode.c
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
diff -puN fs/ext4/inode.c~ext-remove-unused-argument-for-ext_find_goal fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext-remove-unused-argument-for-ext_find_goal
+++ a/fs/ext4/inode.c
@@ -429,16 +429,13 @@ static ext4_fsblk_t ext4_find_near(struc
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
-
 static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_lblk_t block,
-		Indirect chain[4], Indirect *partial)
+		Indirect *partial)
 {
 	struct ext4_block_alloc_info *block_i;
 
@@ -839,7 +836,7 @@ int ext4_get_blocks_handle(handle_t *han
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext4_init_block_alloc_info(inode);
 
-	goal = ext4_find_goal(inode, iblock, chain, partial);
+	goal = ext4_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
