From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [17/23] EXT3: Fix set but unused variables
Date: Thu, 10 Jun 2010 13:10:53 +0200 (CEST)
Message-ID: <20100610111053.43E78B1A2B@basil.firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I think it's mostly dead code, but needs more review. I was not fully sure
about the jbd case.

cc: tytso@mit.edu
cc: linux-ext4@vger.kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext3/namei.c   |    3 +--
 fs/ext3/resize.c  |    2 --
 fs/jbd/journal.c  |    7 -------
 fs/jbd/recovery.c |    7 -------
 4 files changed, 1 insertion(+), 18 deletions(-)

Index: linux-2.6.35-rc2-gcc/fs/ext3/namei.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext3/namei.c
+++ linux-2.6.35-rc2-gcc/fs/ext3/namei.c
@@ -1447,7 +1447,6 @@ static int ext3_add_entry (handle_t *han
 	struct inode *inode)
 {
 	struct inode *dir = dentry->d_parent->d_inode;
-	unsigned long offset;
 	struct buffer_head * bh;
 	struct ext3_dir_entry_2 *de;
 	struct super_block * sb;
@@ -1469,7 +1468,7 @@ static int ext3_add_entry (handle_t *han
 		ext3_mark_inode_dirty(handle, dir);
 	}
 	blocks = dir->i_size >> sb->s_blocksize_bits;
-	for (block = 0, offset = 0; block < blocks; block++) {
+	for (block = 0; block < blocks; block++) {
 		bh = ext3_bread(handle, dir, block, 0, &retval);
 		if(!bh)
 			return retval;
Index: linux-2.6.35-rc2-gcc/fs/ext3/resize.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext3/resize.c
+++ linux-2.6.35-rc2-gcc/fs/ext3/resize.c
@@ -964,7 +964,6 @@ int ext3_group_extend(struct super_block
 		      ext3_fsblk_t n_blocks_count)
 {
 	ext3_fsblk_t o_blocks_count;
-	unsigned long o_groups_count;
 	ext3_grpblk_t last;
 	ext3_grpblk_t add;
 	struct buffer_head * bh;
@@ -976,7 +975,6 @@ int ext3_group_extend(struct super_block
 	 * yet: we're going to revalidate es->s_blocks_count after
 	 * taking the s_resize_lock below. */
 	o_blocks_count = le32_to_cpu(es->s_blocks_count);
-	o_groups_count = EXT3_SB(sb)->s_groups_count;
 
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT3-fs: extending last group from "E3FSBLK" uto "E3FSBLK" blocks\n",
Index: linux-2.6.35-rc2-gcc/fs/jbd/journal.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/jbd/journal.c
+++ linux-2.6.35-rc2-gcc/fs/jbd/journal.c
@@ -1281,13 +1281,9 @@ int journal_check_used_features (journal
 int journal_check_available_features (journal_t *journal, unsigned long compat,
 				      unsigned long ro, unsigned long incompat)
 {
-	journal_superblock_t *sb;
-
 	if (!compat && !ro && !incompat)
 		return 1;
 
-	sb = journal->j_superblock;
-
 	/* We can support any known requested features iff the
 	 * superblock is in version 2.  Otherwise we fail to support any
 	 * extended sb features. */
@@ -1481,7 +1477,6 @@ int journal_flush(journal_t *journal)
 
 int journal_wipe(journal_t *journal, int write)
 {
-	journal_superblock_t *sb;
 	int err = 0;
 
 	J_ASSERT (!(journal->j_flags & JFS_LOADED));
@@ -1490,8 +1485,6 @@ int journal_wipe(journal_t *journal, int
 	if (err)
 		return err;
 
-	sb = journal->j_superblock;
-
 	if (!journal->j_tail)
 		goto no_recovery;
 
Index: linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/jbd/recovery.c
+++ linux-2.6.35-rc2-gcc/fs/jbd/recovery.c
@@ -283,12 +283,10 @@ int journal_recover(journal_t *journal)
 int journal_skip_recovery(journal_t *journal)
 {
 	int			err;
-	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
 
 	memset (&info, 0, sizeof(info));
-	sb = journal->j_superblock;
 
 	err = do_one_pass(journal, &info, PASS_SCAN);
 
@@ -321,11 +319,6 @@ static int do_one_pass(journal_t *journa
 	unsigned int		sequence;
 	int			blocktype;
 
-	/* Precompute the maximum metadata descriptors in a descriptor block */
-	int			MAX_BLOCKS_PER_DESC;
-	MAX_BLOCKS_PER_DESC = ((journal->j_blocksize-sizeof(journal_header_t))
-			       / sizeof(journal_block_tag_t));
-
 	/*
 	 * First thing is to establish what we expect to find in the log
 	 * (in terms of transaction IDs), and where (in terms of log
