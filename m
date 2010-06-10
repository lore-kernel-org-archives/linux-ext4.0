From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [15/23] EXT4: Fix initialized but not read variables
Date: Thu, 10 Jun 2010 13:10:51 +0200 (CEST)
Message-ID: <20100610111051.36EFEB1A2B@basil.firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758855Ab0FJLKx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jun 2010 07:10:53 -0400
In-Reply-To: <20100610110.764742110@firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


No real bugs found, just various dead code removed I believe.
Some review would be good.

Found by gcc 4.6's new warnings

Cc: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ext4/balloc.c   |    2 --
 fs/ext4/extents.c  |    8 ++------
 fs/ext4/inode.c    |    5 -----
 fs/ext4/mballoc.c  |   23 ++++++++---------------
 fs/ext4/namei.c    |    2 --
 fs/ext4/resize.c   |    2 --
 fs/jbd2/journal.c  |   12 ------------
 fs/jbd2/recovery.c |    7 -------
 8 files changed, 10 insertions(+), 51 deletions(-)

Index: linux-2.6.35-rc2-gcc/fs/ext4/balloc.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/balloc.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/balloc.c
@@ -377,14 +377,12 @@ void ext4_add_groupblocks(handle_t *hand
 	ext4_grpblk_t bit;
 	unsigned int i;
 	struct ext4_group_desc *desc;
-	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi;
 	int err = 0, ret, blk_free_count;
 	ext4_grpblk_t blocks_freed;
 	struct ext4_group_info *grp;
 
 	sbi = EXT4_SB(sb);
-	es = sbi->s_es;
 	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
 
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
Index: linux-2.6.35-rc2-gcc/fs/ext4/extents.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/extents.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/extents.c
@@ -1083,7 +1083,6 @@ static int ext4_ext_grow_indepth(handle_
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
-	struct ext4_extent_idx *fidx;
 	struct buffer_head *bh;
 	ext4_fsblk_t newblock;
 	int err = 0;
@@ -1144,10 +1143,10 @@ static int ext4_ext_grow_indepth(handle_
 	ext4_idx_store_pblock(curp->p_idx, newblock);
 
 	neh = ext_inode_hdr(inode);
-	fidx = EXT_FIRST_INDEX(neh);
 	ext_debug("new root: num %d(%d), lblock %d, ptr %llu\n",
 		  le16_to_cpu(neh->eh_entries), le16_to_cpu(neh->eh_max),
-		  le32_to_cpu(fidx->ei_block), idx_pblock(fidx));
+		  le32_to_cpu(EXT_FIRST_INDEX(neh)->ei_block),
+		  idx_pblock(fidx));
 
 	neh->eh_depth = cpu_to_le16(path->p_depth + 1);
 	err = ext4_ext_dirty(handle, inode, curp);
@@ -2954,7 +2953,6 @@ static int ext4_split_unwritten_extents(
 	struct ext4_extent *ex1 = NULL;
 	struct ext4_extent *ex2 = NULL;
 	struct ext4_extent *ex3 = NULL;
-	struct ext4_extent_header *eh;
 	ext4_lblk_t ee_block, eof_block;
 	unsigned int allocated, ee_len, depth;
 	ext4_fsblk_t newblock;
@@ -2971,7 +2969,6 @@ static int ext4_split_unwritten_extents(
 		eof_block = map->m_lblk + map->m_len;
 
 	depth = ext_depth(inode);
-	eh = path[depth].p_hdr;
 	ex = path[depth].p_ext;
 	ee_block = le32_to_cpu(ex->ee_block);
 	ee_len = ext4_ext_get_actual_len(ex);
@@ -3058,7 +3055,6 @@ static int ext4_split_unwritten_extents(
 			err = PTR_ERR(path);
 			goto out;
 		}
-		eh = path[depth].p_hdr;
 		ex = path[depth].p_ext;
 		if (ex2 != &newex)
 			ex2 = ex;
Index: linux-2.6.35-rc2-gcc/fs/ext4/inode.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/inode.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/inode.c
@@ -3146,13 +3146,10 @@ static int ext4_da_write_begin(struct fi
 	int ret, retries = 0;
 	struct page *page;
 	pgoff_t index;
-	unsigned from, to;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
 
 	index = pos >> PAGE_CACHE_SHIFT;
-	from = pos & (PAGE_CACHE_SIZE - 1);
-	to = from + len;
 
 	if (ext4_nonda_switch(inode->i_sb)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
@@ -5754,7 +5751,6 @@ static int ext4_expand_extra_isize(struc
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
-	struct ext4_xattr_entry *entry;
 
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
 		return 0;
@@ -5762,7 +5758,6 @@ static int ext4_expand_extra_isize(struc
 	raw_inode = ext4_raw_inode(&iloc);
 
 	header = IHDR(inode, raw_inode);
-	entry = IFIRST(header);
 
 	/* No extended attributes present */
 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
Index: linux-2.6.35-rc2-gcc/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/mballoc.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/mballoc.c
@@ -1999,7 +1999,6 @@ ext4_mb_regular_allocator(struct ext4_al
 	ext4_group_t ngroups, group, i;
 	int cr;
 	int err = 0;
-	int bsbits;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
@@ -2041,8 +2040,6 @@ ext4_mb_regular_allocator(struct ext4_al
 			ac->ac_2order = i - 1;
 	}
 
-	bsbits = ac->ac_sb->s_blocksize_bits;
-
 	/* if stream allocation is enabled, use global goal */
 	if (ac->ac_flags & EXT4_MB_STREAM_ALLOC) {
 		/* TBD: may be hot point */
@@ -2712,7 +2709,6 @@ ext4_mb_mark_diskspace_used(struct ext4_
 				handle_t *handle, unsigned int reserv_blks)
 {
 	struct buffer_head *bitmap_bh = NULL;
-	struct ext4_super_block *es;
 	struct ext4_group_desc *gdp;
 	struct buffer_head *gdp_bh;
 	struct ext4_sb_info *sbi;
@@ -2725,8 +2721,6 @@ ext4_mb_mark_diskspace_used(struct ext4_
 
 	sb = ac->ac_sb;
 	sbi = EXT4_SB(sb);
-	es = sbi->s_es;
-
 
 	err = -EIO;
 	bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
@@ -2849,8 +2843,8 @@ ext4_mb_normalize_request(struct ext4_al
 {
 	int bsbits, max;
 	ext4_lblk_t end;
-	loff_t size, orig_size, start_off;
-	ext4_lblk_t start, orig_start;
+	loff_t size, start_off;
+	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *pa;
 
@@ -2922,8 +2916,9 @@ ext4_mb_normalize_request(struct ext4_al
 		start_off = (loff_t)ac->ac_o_ex.fe_logical << bsbits;
 		size	  = ac->ac_o_ex.fe_len << bsbits;
 	}
-	orig_size = size = size >> bsbits;
-	orig_start = start = start_off >> bsbits;
+
+	/* FIXME: start_off is not used for anything. bug? */
+	/* FIXME: start may be uninitialized? */
 
 	/* don't cover already allocated blocks in selected range */
 	if (ar->pleft && start <= ar->lleft) {
@@ -3547,7 +3542,6 @@ ext4_mb_release_inode_pa(struct ext4_bud
 	ext4_group_t group;
 	ext4_grpblk_t bit;
 	unsigned long long grp_blk_start;
-	sector_t start;
 	int err = 0;
 	int free = 0;
 
@@ -3567,9 +3561,10 @@ ext4_mb_release_inode_pa(struct ext4_bud
 		if (bit >= end)
 			break;
 		next = mb_find_next_bit(bitmap_bh->b_data, end, bit);
-		start = ext4_group_first_block_no(sb, group) + bit;
 		mb_debug(1, "    free preallocated %u/%u in group %u\n",
-				(unsigned) start, (unsigned) next - bit,
+				(unsigned)
+			 ext4_group_first_block_no(sb, group) + bit,
+			 	(unsigned) next - bit,
 				(unsigned) group);
 		free += next - bit;
 
@@ -4494,7 +4489,6 @@ void ext4_free_blocks(handle_t *handle,
 	struct super_block *sb = inode->i_sb;
 	struct ext4_allocation_context *ac = NULL;
 	struct ext4_group_desc *gdp;
-	struct ext4_super_block *es;
 	unsigned long freed = 0;
 	unsigned int overflow;
 	ext4_grpblk_t bit;
@@ -4513,7 +4507,6 @@ void ext4_free_blocks(handle_t *handle,
 	}
 
 	sbi = EXT4_SB(sb);
-	es = EXT4_SB(sb)->s_es;
 	if (!(flags & EXT4_FREE_BLOCKS_VALIDATED) &&
 	    !ext4_data_block_valid(sbi, block, count)) {
 		ext4_error(sb, "Freeing blocks not in datazone - "
Index: linux-2.6.35-rc2-gcc/fs/ext4/namei.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/namei.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/namei.c
@@ -1088,7 +1088,6 @@ static struct dentry *ext4_lookup(struct
 struct dentry *ext4_get_parent(struct dentry *child)
 {
 	__u32 ino;
-	struct inode *inode;
 	static const struct qstr dotdot = {
 		.name = "..",
 		.len = 2,
@@ -1097,7 +1096,6 @@ struct dentry *ext4_get_parent(struct de
 	struct buffer_head *bh;
 
 	bh = ext4_find_entry(child->d_inode, &dotdot, &de);
-	inode = NULL;
 	if (!bh)
 		return ERR_PTR(-ENOENT);
 	ino = le32_to_cpu(de->inode);
Index: linux-2.6.35-rc2-gcc/fs/ext4/resize.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/ext4/resize.c
+++ linux-2.6.35-rc2-gcc/fs/ext4/resize.c
@@ -953,7 +953,6 @@ int ext4_group_extend(struct super_block
 		      ext4_fsblk_t n_blocks_count)
 {
 	ext4_fsblk_t o_blocks_count;
-	ext4_group_t o_groups_count;
 	ext4_grpblk_t last;
 	ext4_grpblk_t add;
 	struct buffer_head *bh;
@@ -965,7 +964,6 @@ int ext4_group_extend(struct super_block
 	 * yet: we're going to revalidate es->s_blocks_count after
 	 * taking the s_resize_lock below. */
 	o_blocks_count = ext4_blocks_count(es);
-	o_groups_count = EXT4_SB(sb)->s_groups_count;
 
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: extending last group from %llu uto %llu blocks\n",
Index: linux-2.6.35-rc2-gcc/fs/jbd2/journal.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/jbd2/journal.c
+++ linux-2.6.35-rc2-gcc/fs/jbd2/journal.c
@@ -1392,13 +1392,9 @@ int jbd2_journal_check_used_features (jo
 int jbd2_journal_check_available_features (journal_t *journal, unsigned long compat,
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
@@ -1618,7 +1614,6 @@ int jbd2_journal_flush(journal_t *journa
 
 int jbd2_journal_wipe(journal_t *journal, int write)
 {
-	journal_superblock_t *sb;
 	int err = 0;
 
 	J_ASSERT (!(journal->j_flags & JBD2_LOADED));
@@ -1627,8 +1622,6 @@ int jbd2_journal_wipe(journal_t *journal
 	if (err)
 		return err;
 
-	sb = journal->j_superblock;
-
 	if (!journal->j_tail)
 		goto no_recovery;
 
@@ -2202,8 +2195,6 @@ void jbd2_journal_init_jbd_inode(struct
 void jbd2_journal_release_jbd_inode(journal_t *journal,
 				    struct jbd2_inode *jinode)
 {
-	int writeout = 0;
-
 	if (!journal)
 		return;
 restart:
@@ -2220,9 +2211,6 @@ restart:
 		goto restart;
 	}
 
-	/* Do we need to wait for data writeback? */
-	if (journal->j_committing_transaction == jinode->i_transaction)
-		writeout = 1;
 	if (jinode->i_transaction) {
 		list_del(&jinode->i_list);
 		jinode->i_transaction = NULL;
Index: linux-2.6.35-rc2-gcc/fs/jbd2/recovery.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/jbd2/recovery.c
+++ linux-2.6.35-rc2-gcc/fs/jbd2/recovery.c
@@ -285,12 +285,10 @@ int jbd2_journal_recover(journal_t *jour
 int jbd2_journal_skip_recovery(journal_t *journal)
 {
 	int			err;
-	journal_superblock_t *	sb;
 
 	struct recovery_info	info;
 
 	memset (&info, 0, sizeof(info));
-	sb = journal->j_superblock;
 
 	err = do_one_pass(journal, &info, PASS_SCAN);
 
@@ -365,11 +363,6 @@ static int do_one_pass(journal_t *journa
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
 
-	/* Precompute the maximum metadata descriptors in a descriptor block */
-	int			MAX_BLOCKS_PER_DESC;
-	MAX_BLOCKS_PER_DESC = ((journal->j_blocksize-sizeof(journal_header_t))
-			       / tag_bytes);
