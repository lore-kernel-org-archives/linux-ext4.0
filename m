From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: ext2/3 create large filesystem takes too much time; solutions
Date: Sun, 17 Sep 2006 01:57:12 -0600
Message-ID: <20060917075712.GJ6441@schatzie.adilger.int>
References: <401f4f10609120407j6816372mfdfea392dcae9e00@mail.gmail.com> <20060915212034.GB11237@thunk.org> <401f4f10609160756jc8c6a3eu9925b3678d0f6793@mail.gmail.com> <20060916200617.GA14999@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="p4qYPpj5QlsIQJ0K"
Cc: Pavel Mironchik <tibor0@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50848 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S1751153AbWIQH5R
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Sep 2006 03:57:17 -0400
To: Theodore Tso <tytso@mit.edu>
Content-Disposition: inline
In-Reply-To: <20060916200617.GA14999@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sep 16, 2006  16:06 -0400, Theodore Tso wrote:
> On Sat, Sep 16, 2006 at 05:56:02PM +0300, Pavel Mironchik wrote:
> > I agree with you and I would prefer to send something more
> > serious on that list than those previous patches - I like your
> > idea with counters. Btw I assume crc is more preferable than
> > just control sum for block group descriptors....
> 
> Yes, when I said checksum I meant a cyclic redundancy checksum, and
> not an additive checksum...  (and one of the things we can do is to
> build in the superblock UUID into the CRC, so that if the filesystem
> gets recreated we can distinguish an old inode from a new one).

Just to avoid duplication of effort, I'm attaching the current
work-in-progress patches for the uninitialized groups (kernel + e2fsprogs).
They are really at the "barely compile" stage (if that), but at least
people can look at them and start improving them instead of starting from
scratch.  The patches are based on work done by Anshu Goel
<anshu@linsyssoft.com>, but have been reworked a fair amount since they
were given to me (i.e. bugs added are mine).  I've been sitting on them
for too long and they should see the light of day instead of continuing
to stagnate.

I also just incorporated Ted's suggestion to include the filesystem UUID
into the checksum.  I previously had added in the group number, so that
if the block is written out to the wrong location it wouldn't verify
correctly.

Things that need to be done:
- the kernel block/inode allocation needs to be reworked:
  - initialize a whole block worth of inodes at one time instead
    of single inodes.
  - I don't think we need to zero out the unused inodes - the kernel
    should already be doing this if the inode block is unused
  - find a happy medium between using existing groups (inodes/blocks)
    and initializing new ones
- we likely need to verify the checksum in more places in e2fsck before
  trusting the UNINIT flags

I won't be able to work more on this for a while, so have at it :-).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ext3-uninit_groups-2.6.12.patch"

Index: linux-stage/fs/ext3/mballoc.c
===================================================================
--- linux-stage.orig/fs/ext3/mballoc.c	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/fs/ext3/mballoc.c	2006-09-17 00:59:44.000000000 -0600
@@ -198,7 +198,8 @@
 void ext3_mb_release_blocks(struct super_block *, int);
 void ext3_mb_poll_new_transaction(struct super_block *, handle_t *);
 void ext3_mb_free_committed_blocks(struct super_block *);
-
+unsigned long free_blks_after_init(struct super_block *,
+						struct ext3_group_desc *, int);
 #if BITS_PER_LONG == 64
 #define mb_correct_addr_and_bit(bit,addr)		\
 {							\
@@ -527,7 +528,12 @@
 			unlock_buffer(bh[i]);
 			continue;
 		}
-
+		if (desc->bg_flags & EXT3_BG_BLOCK_UNINIT) {
+			init_block_bitmap(sb, bh[i], desc, first_group + i);
+			set_buffer_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
@@ -1525,9 +1531,16 @@
 	mb_set_bits(bitmap_bh->b_data, ac.ac_b_ex.fe_start, ac.ac_b_ex.fe_len);
 
 	spin_lock(sb_bgl_lock(sbi, ac.ac_b_ex.fe_group));
+	if (gdp->bg_flags & EXT3_BG_BLOCK_UNINIT) {
+		gdp->bg_flags &= ~EXT3_BG_BLOCK_UNINIT;
+		gdp->bg_free_blocks_count =
+			cpu_to_le16(free_blks_after_init(sb, gdp,
+				ac.ac_b_ex.fe_group));
+	}
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)
 					- ac.ac_b_ex.fe_len);
+	gdp->bg_checksum = ext3_group_desc_csum(es, gdp, ac.ac_b_ex.fe_group);
 	spin_unlock(sb_bgl_lock(sbi, ac.ac_b_ex.fe_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, - ac.ac_b_ex.fe_len);
 
@@ -2377,6 +2390,7 @@
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) + count);
+	gdp->bg_checksum = ext3_group_desc_csum(es, gdp, block_group);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
Index: linux-stage/fs/ext3/ialloc.c
===================================================================
--- linux-stage.orig/fs/ext3/ialloc.c	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/fs/ext3/ialloc.c	2006-09-17 00:59:44.000000000 -0600
@@ -23,7 +23,6 @@
 #include <linux/buffer_head.h>
 #include <linux/random.h>
 #include <linux/bitops.h>
-
 #include <asm/byteorder.h>
 
 #include "xattr.h"
@@ -59,8 +58,14 @@
 	desc = ext3_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_inode_bitmap));
+	if (desc->bg_flags & EXT3_BG_INODE_UNINIT) {
+		bh = sb_getblk(sb, le32_to_cpu(desc->bg_inode_bitmap));
+		if (!buffer_uptodate(bh)) {
+			memset(bh->b_data,0,bh->b_size);
+			set_buffer_uptodate(bh);
+		}
+	} else
+		bh = sb_bread(sb, le32_to_cpu(desc->bg_inode_bitmap));
 	if (!bh)
 		ext3_error(sb, "read_inode_bitmap",
 			    "Cannot read inode bitmap - "
@@ -169,6 +174,8 @@
 			if (is_directory)
 				gdp->bg_used_dirs_count = cpu_to_le16(
 				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+			gdp->bg_checksum = ext3_group_desc_csum(es, gdp,
+								block_group);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
@@ -202,7 +209,7 @@
 static int find_group_dir(struct super_block *sb, struct inode *parent)
 {
 	int ngroups = EXT3_SB(sb)->s_groups_count;
-	int freei, avefreei;
+	int freei, avefreei, freeb = 0, best_freeb = 0;
 	struct ext3_group_desc *desc, *best_desc = NULL;
 	struct buffer_head *bh;
 	int group, best_group = -1;
@@ -212,15 +219,17 @@
 
 	for (group = 0; group < ngroups; group++) {
 		desc = ext3_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		freei = EXT3_FREE_INODES_COUNT(desc);
+		freeb = EXT3_FREE_BLOCKS_COUNT(desc);
+		if (!desc || !freei)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
+		if (le16_to_cpu(freei) < avefreei)
 			continue;
-		if (!best_desc || 
-		    (le16_to_cpu(desc->bg_free_blocks_count) >
-		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
+		if (!best_desc ||
+		    (le16_to_cpu(freeb) > le16_to_cpu(best_freeb))) {
 			best_group = group;
-			best_desc = desc;
+			best_desc  = desc;
+			best_freeb = freeb;
 		}
 	}
 	return best_group;
@@ -284,14 +293,16 @@
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
 			group = (parent_group + i) % ngroups;
-			desc = ext3_get_group_desc (sb, group, &bh);
-			if (!desc || !desc->bg_free_inodes_count)
+			desc = ext3_get_group_desc(sb, group, &bh);
+			freei = EXT3_FREE_INODES_COUNT(desc);
+			if (!desc || !freei)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
 				continue;
-			if (le16_to_cpu(desc->bg_free_inodes_count) < avefreei)
+			if (le16_to_cpu(freei) < avefreei)
 				continue;
-			if (le16_to_cpu(desc->bg_free_blocks_count) < avefreeb)
+			freeb = EXT3_FREE_BLOCKS_COUNT(desc);
+			if (le16_to_cpu(freeb) < avefreeb)
 				continue;
 			best_group = group;
 			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
@@ -318,13 +329,15 @@
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
 		desc = ext3_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		freei = EXT3_FREE_INODES_COUNT(desc);
+		freeb = EXT3_FREE_BLOCKS_COUNT(desc);
+		if (!desc || !freei)
 			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) < min_inodes)
+		if (le16_to_cpu(freei) < min_inodes)
 			continue;
-		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
+		if (le16_to_cpu(freeb) < min_blocks)
 			continue;
 		return group;
 	}
@@ -333,9 +346,10 @@
 	for (i = 0; i < ngroups; i++) {
 		group = (parent_group + i) % ngroups;
 		desc = ext3_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		freei = EXT3_FREE_INODES_COUNT(desc);
+		if (!desc || !freei)
 			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
+		if (le16_to_cpu(freei) >= avefreei)
 			return group;
 	}
 
@@ -362,6 +376,7 @@
 	int group, i;
 	int best_group = -1;
 	int avefreeb, freeb, best_group_freeb = 0;
+	int freei;
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -392,11 +407,13 @@
 		if (group >= ngroups)
 			group -= ngroups;
 		desc = ext3_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		freei = EXT3_FREE_INODES_COUNT(desc);
+		if (!desc || !freei)
 			continue;
 		if (!S_ISREG(mode))
 			return group;
-		if (le16_to_cpu(desc->bg_free_blocks_count) >= avefreeb)
+		freeb = EXT3_FREE_BLOCKS_COUNT(desc);
+		if (freeb >= avefreeb)
 			return group;
 	}
 
@@ -413,9 +430,10 @@
 		if (++group >= ngroups)
 			group = 0;
 		desc = ext3_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
+		freei = EXT3_FREE_INODES_COUNT(desc);
+		if (!desc || !freei)
 			continue;
-		freeb = le16_to_cpu(desc->bg_free_blocks_count);
+		freeb = EXT3_FREE_BLOCKS_COUNT(desc);
 		if (freeb > best_group_freeb) {
 			best_group_freeb = freeb;
 			best_group = group;
@@ -453,6 +471,7 @@
 	int err = 0;
 	struct inode *ret;
 	int i;
+	int unused_flag = 0;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -582,18 +601,33 @@
 	err = ext3_journal_get_write_access(handle, bh2);
 	if (err) goto fail;
 	spin_lock(sb_bgl_lock(sbi, group));
-	gdp->bg_free_inodes_count =
-		cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
+	if (gdp->bg_free_inodes_count == 0) {
+		if (gdp->bg_flags & EXT3_BG_INODE_UNINIT) {
+			gdp->bg_itable_unused =
+				cpu_to_le16(le16_to_cpu(es->s_inodes_per_group));
+			gdp->bg_flags &= ~EXT3_BG_INODE_UNINIT;
+		}
+		/* If we didn't allocate from free initialized inodes,
+		 * then we allocated from uninitialized inodes. In which
+		 * case initialize one inode. */
+		gdp->bg_itable_unused =
+			cpu_to_le16(le16_to_cpu(gdp->bg_itable_unused) - 1);
+		unused_flag = 1;
+	} else
+		gdp->bg_free_inodes_count =
+			cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) -1);
 	if (S_ISDIR(mode)) {
 		gdp->bg_used_dirs_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
 	}
+	gdp->bg_checksum = ext3_group_desc_csum(es, gdp, group);
 	spin_unlock(sb_bgl_lock(sbi, group));
 	BUFFER_TRACE(bh2, "call ext3_journal_dirty_metadata");
 	err = ext3_journal_dirty_metadata(handle, bh2);
 	if (err) goto fail;
 
-	percpu_counter_dec(&sbi->s_freeinodes_counter);
+	if (!unused_flag)
+		percpu_counter_dec(&sbi->s_freeinodes_counter);
 	if (S_ISDIR(mode))
 		percpu_counter_inc(&sbi->s_dirs_counter);
 	sb->s_dirt = 1;
Index: linux-stage/fs/ext3/balloc.c
===================================================================
--- linux-stage.orig/fs/ext3/balloc.c	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/fs/ext3/balloc.c	2006-09-17 01:07:33.000000000 -0600
@@ -73,6 +73,88 @@
 	return desc + offset;
 }
 
+unsigned long free_blks_after_init(struct super_block *sb,
+				    struct ext3_group_desc *desc,
+				    int block_group)
+{
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	unsigned long blks;
+	unsigned long first_meta_bg;
+	int yes_super;
+
+	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
+
+	/* Last and first groups are always initialized */
+	blks = le32_to_cpu(EXT3_BLOCKS_PER_GROUP(sb));
+	/* Account for for sb, gdt */
+	yes_super = ext3_bg_has_super(sb, block_group);
+	if (yes_super)
+		blks--;
+
+	if (!EXT3_HAS_RO_COMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_META_BG) ||
+	    block_group < first_meta_bg) {
+		if (yes_super) {
+			blks -= le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
+			blks -= ext3_bg_num_gdb(sb, block_group);
+		}
+	} else { /* For META_BG BLOCK GROUPS*/
+		int group_rel = (block_group - first_meta_bg) %
+				EXT3_DESC_PER_BLOCK(sb);
+		if (group_rel == 0 || group_rel == 1 ||
+		    (group_rel == EXT3_DESC_PER_BLOCK(sb) - 1))
+			blks--;
+	}
+
+	/* Account for bitmaps and inode table */
+	blks -= sbi->s_itb_per_group + 2;
+	return blks;
+}
+
+/* Initializes an uninitialized block bitmap */
+void init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
+		       struct ext3_group_desc *desc, int block_group)
+{
+	unsigned startblk;
+	int bit, bit_max;
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	unsigned long first_data_block, first_meta_bg;
+
+	first_data_block = le32_to_cpu(sbi->s_es->s_first_data_block);
+	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
+	memset(bh->b_data, 0, bh->b_size);
+
+	/* Set bits for sb, gdt */
+	startblk = block_group * EXT3_BLOCKS_PER_GROUP(sb) +
+		le32_to_cpu(sbi->s_es->s_first_data_block);
+
+	bit = 0;
+	bit_max = ext3_bg_has_super(sb, block_group);
+
+	if (!EXT3_HAS_RO_COMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_META_BG) ||
+	    block_group < first_meta_bg) {
+		if (bit_max) {
+			bit_max += ext3_bg_num_gdb(sb, block_group);
+			bit_max +=le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
+		}
+	} else { /* For META_BG_BLOCK_GROUPS */
+		int group_rel = (block_group - first_meta_bg) %
+				EXT3_DESC_PER_BLOCK(sb);
+		if (group_rel == 0 || group_rel == 1 ||
+		    (group_rel == EXT3_DESC_PER_BLOCK(sb) - 1))
+			bit_max += 1;
+	}
+	for (; bit < bit_max; bit++)
+		ext3_set_bit(bit, bh->b_data);
+
+	/* Set bits for bitmaps and inode table */
+	ext3_set_bit(le32_to_cpu(desc->bg_block_bitmap) - startblk, bh->b_data);
+	ext3_set_bit(le32_to_cpu(desc->bg_inode_bitmap) - startblk, bh->b_data);
+	bit_max = bit + sbi->s_itb_per_group;
+	for (bit = le32_to_cpu(desc->bg_inode_table) - startblk;
+	     bit < bit_max; bit++)
+		ext3_set_bit(bit, bh->b_data);
+}
+
 /*
  * Read the bitmap for a given block_group, reading into the specified 
  * slot in the superblock's bitmap cache.
@@ -88,7 +170,18 @@
 	desc = ext3_get_group_desc (sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
+	if (desc->bg_flags & EXT3_BG_BLOCK_UNINIT) {
+		bh = sb_getblk(sb, le32_to_cpu(desc->bg_block_bitmap));
+		if (!buffer_uptodate(bh)) {
+			lock_buffer(bh);
+			if (!buffer_uptodate(bh)) {
+				init_block_bitmap(sb, bh, desc, block_group);
+				set_buffer_uptodate(bh);
+			}
+			unlock_buffer(bh);
+		}
+	} else
+		bh = sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
 	if (!bh)
 		ext3_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
@@ -465,6 +558,7 @@
 	desc->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
+	desc->bg_checksum = ext3_group_desc_csum(es, desc, block_group);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
@@ -1168,6 +1262,7 @@
 	static int goal_hits, goal_attempts;
 #endif
 	unsigned long ngroups;
+	unsigned long free_blks;
 
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
@@ -1218,7 +1313,10 @@
 
 	goal_group = group_no;
 retry:
-	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+	if (gdp->bg_flags & EXT3_BG_BLOCK_UNINIT)
+		free_blocks = free_blks_after_init(sb, gdp, group_no);
+	else
+		free_blocks = EXT3_FREE_BLOCKS_COUNT(gdp);
 	/*
 	 * if there is not enough free blocks to make a new resevation
 	 * turn off reservation for this allocation
@@ -1257,7 +1355,11 @@
 			*errp = -EIO;
 			goto out;
 		}
-		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
+		if (gdp->bg_flags & EXT3_BG_BLOCK_UNINIT)
+			free_blocks = cpu_to_le16(free_blks_after_init(sb, gdp,
+								     group_no));
+		else
+			free_blocks = EXT3_FREE_BLOCKS_COUNT(gdp);
 		/*
 		 * skip this group if the number of
 		 * free blocks is less than half of the reservation
@@ -1362,11 +1464,18 @@
 			ret_block, goal_hits, goal_attempts);
 
 	spin_lock(sb_bgl_lock(sbi, group_no));
+	free_blks = 0;
+	if (gdp->bg_flags & EXT3_BG_BLOCK_UNINIT) {
+		gdp->bg_flags &= ~EXT3_BG_BLOCK_UNINIT;
+		free_blks = cpu_to_le16(free_blks_after_init(sb, gdp,group_no));
+		gdp->bg_free_blocks_count = free_blks;
+	}
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) - 1);
+	gdp->bg_checksum = ext3_group_desc_csum(es, gdp, group_no);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, -1);
-
+	percpu_counter_mod(&sbi->s_freeblocks_counter, free_blks);
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
 	if (!fatal)
Index: linux-stage/fs/ext3/super.c
===================================================================
--- linux-stage.orig/fs/ext3/super.c	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/fs/ext3/super.c	2006-09-17 01:13:43.000000000 -0600
@@ -1093,6 +1093,51 @@
 	return res;
 }
 
+static __u16 crc16(__u16 crc, const u8 *buf, size_t len)
+{
+	__u16 tmp;
+
+	while (len--) {
+		crc ^= *buf++;
+		crc ^= (u8)crc >> 4;
+		tmp = (u8)crc;
+		crc ^= (tmp ^ (tmp << 1)) << 4;
+	}
+	return crc;
+}
+
+__u16 ext3_group_desc_csum(struct ext3_super_block *sb,
+			   struct ext3_group_desc *desc, __u32 group)
+{
+	__u16 crc = 0;
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		int offset = offsetof(struct ext3_group_desc, bg_checksum);
+
+		group = cpu_to_le32(group);
+		crc = crc16(~0, (__u8 *)&group, sizeof(group));
+		crc = crc16(crc, (__u8 *)desc, offset);
+		offset += sizeof(desc->bg_checksum); /* skip checksum */
+		BUG_ON(offset != sizeof(*desc)); /* XXX handle s_desc_size */
+		/*
+		if (offset < sb->s_desc_size) {
+			crc = crc16(crc, (__u8 *)desc + offset,
+				    sb->s_desc_size - offset);
+		 */
+	}
+
+	return cpu_to_le16(crc);
+}
+
+int ext3_group_desc_csum_verify(struct ext3_super_block *sb,
+				struct ext3_group_desc *desc, __u32 group)
+{
+	if (desc->bg_checksum != ext3_group_desc_csum(sb, desc, group))
+		return 0;
+
+	return 1;
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext3_check_descriptors (struct super_block * sb)
 {
@@ -1142,6 +1187,13 @@
 					le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
+		if (!ext3_group_desc_csum_verify(sb, gdp, i)) {
+			ext3_error(sb, __FUNCTION__,
+				   "Checksum for group %d failed (%u != %u)\n",
+				   i, ext3_group_desc_csum(sb, gdp, i),
+				   gdp->bg_checksum);
+			return 0;
+		}
 		block += EXT3_BLOCKS_PER_GROUP(sb);
 		gdp++;
 	}
Index: linux-stage/fs/ext3/resize.c
===================================================================
--- linux-stage.orig/fs/ext3/resize.c	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/fs/ext3/resize.c	2006-09-17 00:59:44.000000000 -0600
@@ -19,7 +19,6 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 
-
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
 
@@ -807,6 +806,7 @@
 	gdp->bg_inode_table = cpu_to_le32(input->inode_table);
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT3_INODES_PER_GROUP(sb));
+	gdp->bg_checksum = ext3_group_desc_csum(es, gdp, input->group);
 
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
Index: linux-stage/include/linux/ext3_fs.h
===================================================================
--- linux-stage.orig/include/linux/ext3_fs.h	2006-09-17 00:59:44.000000000 -0600
+++ linux-stage/include/linux/ext3_fs.h	2006-09-17 01:02:00.000000000 -0600
@@ -118,6 +118,16 @@
 				 (s)->s_first_ino)
 #endif
 
+//Macro-instructions used to calculate Free inodes and blocks count
+
+#define EXT3_FREE_INODES_COUNT(desc)	(desc->bg_flags &EXT3_BG_INODE_UNINIT)?\
+					EXT3_INODES_PER_GROUP(sb) : \
+					(desc->bg_free_inodes_count + \
+					desc->bg_itable_unused)
+#define EXT3_FREE_BLOCKS_COUNT(desc)	(desc->bg_flags &EXT3_BG_BLOCK_UNINIT)?\
+					EXT3_BLOCKS_PER_GROUP(sb) : \
+					(desc->bg_free_blocks_count)
+
 /*
  * Macro-instructions used to manage fragments
  */
@@ -137,16 +147,21 @@
  */
 struct ext3_group_desc
 {
-	__le32	bg_block_bitmap;		/* Blocks bitmap block */
-	__le32	bg_inode_bitmap;		/* Inodes bitmap block */
+	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-	__u16	bg_pad;
-	__le32	bg_reserved[3];
+	__le16  bg_flags;
+	__le32	bg_reserved[2];
+	__le16	bg_itable_unused;	/*Unused inodes count*/
+	__le16	bg_checksum;
 };
 
+#define EXT3_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
+#define EXT3_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
+
 /*
  * Macro-instructions used to manage group descriptors
  */
@@ -565,6 +580,7 @@
 #define EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT3_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT3_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010 /* Descriptor checksum */
 
 #define EXT3_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT3_FEATURE_INCOMPAT_FILETYPE		0x0002
@@ -580,7 +596,8 @@
 					 EXT3_FEATURE_INCOMPAT_EXTENTS)
 #define EXT3_FEATURE_RO_COMPAT_SUPP	(EXT3_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT3_FEATURE_RO_COMPAT_LARGE_FILE| \
-					 EXT3_FEATURE_RO_COMPAT_BTREE_DIR)
+					 EXT3_FEATURE_RO_COMPAT_BTREE_DIR|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 
 /*
  * Default values for user and/or group using reserved blocks
@@ -830,6 +847,10 @@
 extern void ext3_warning (struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern void ext3_update_dynamic_rev (struct super_block *sb);
+extern __u16 ext3_group_desc_csum(struct ext3_super_block *sb,
+				  struct ext3_group_desc *desc, __u32 group);
+extern int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb,
+				  struct ext2_group_desc *desc, __u32 group);
 
 #define ext3_std_error(sb, errno)				\
 do {								\

--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="e2fsprogs-uninit.patch"

Index: e2fsprogs/debugfs/debugfs.c
===================================================================
--- e2fsprogs.orig/debugfs/debugfs.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/debugfs/debugfs.c	2006-09-16 17:31:15.000000000 -0600
@@ -321,7 +321,8 @@ void do_show_super_stats(int argc, char 
 		        "inode table at %u\n"
 		        "           %d free %s, "
 		        "%d free %s, "
-		        "%d used %s\n",
+		        "%d used %s, "
+		        "%d unused %s\n",
 		        i, gdp->bg_block_bitmap,
 		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
 		        gdp->bg_free_blocks_count,
@@ -330,7 +331,9 @@ void do_show_super_stats(int argc, char 
 		        gdp->bg_free_inodes_count != 1 ? "inodes" : "inode",
 		        gdp->bg_used_dirs_count,
 		        gdp->bg_used_dirs_count != 1 ? "directories"
-				: "directory");
+				: "directory",
+		        gdp->bg_itable_unused,
+		        gdp->bg_itable_unused != 1 ? "inodes" : "inode");
 		first = 1;
 		print_bg_opts(gdp, EXT2_BG_INODE_UNINIT, "Inode not init",
 			      &first, out);
Index: e2fsprogs/e2fsck/journal.c
===================================================================
--- e2fsprogs.orig/e2fsck/journal.c	2006-05-18 02:45:07.000000000 -0600
+++ e2fsprogs/e2fsck/journal.c	2006-09-16 23:37:04.000000000 -0600
@@ -950,6 +950,8 @@ void e2fsck_move_ext3_journal(e2fsck_t c
 	ext2fs_unmark_inode_bitmap(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
 	fs->group_desc[group].bg_free_inodes_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[group],group);
 	fs->super->s_free_inodes_count++;
 	return;
 
Index: e2fsprogs/e2fsck/pass5.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass5.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/e2fsck/pass5.c	2006-09-16 23:55:49.000000000 -0600
@@ -167,7 +167,9 @@ redo_counts:
 	save_problem = 0;
 	pctx.blk = pctx.blk2 = NO_BLK;
 	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_BLOCK_UNINIT))
+			EXT2_BG_BLOCK_UNINIT) &&
+	    ext2fs_group_desc_csum_verify(fs->super, &fs->group_desc[group],
+					  group))
 		skip_group++;
 	super = fs->super->s_first_data_block;
 	for (i = fs->super->s_first_data_block;
@@ -245,7 +247,10 @@ redo_counts:
 			if (lazy_bg &&
 			    (i != fs->super->s_blocks_count-1) &&
 			    (fs->group_desc[group].bg_flags &
-			     EXT2_BG_BLOCK_UNINIT))
+			     EXT2_BG_BLOCK_UNINIT) &&
+			    ext2fs_group_desc_csum_verify(fs->super,
+							 &fs->group_desc[group],
+							 group))
 				skip_group++;
 		}
 	}
@@ -287,6 +292,9 @@ redo_counts:
 					&pctx)) {
 				fs->group_desc[i].bg_free_blocks_count =
 					free_array[i];
+				fs->group_desc[i].bg_checksum =
+					ext2fs_group_desc_csum(fs->super,
+							&fs->group_desc[i], i);
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -323,6 +331,8 @@ static void check_inode_bitmaps(e2fsck_t
 	int		problem, save_problem, fixit, had_problem;
 	int		lazy_bg = 0;
 	int		skip_group = 0;
+	int		first_unused_inode = 0;
+	int		unused_inode_count = 0; 
 	
 	clear_problem_context(&pctx);
 	free_array = (int *) e2fsck_allocate_memory(ctx,
@@ -367,13 +377,17 @@ redo_counts:
 	save_problem = 0;
 	pctx.ino = pctx.ino2 = 0;
 	if (lazy_bg && (fs->group_desc[group].bg_flags &
-			EXT2_BG_INODE_UNINIT))
+			EXT2_BG_INODE_UNINIT) &&
+	    ext2fs_group_desc_csum_verify(fs->super, &fs->group_desc[group],
+					  group))
 		skip_group++;
-
+	first_unused_inode = (fs->super->s_inodes_per_group -
+			      fs->group_desc[group].bg_itable_unused) +
+			     (group * fs->super->s_inodes_per_group + 1);
 	/* Protect loop from wrap-around if inodes_count is maxed */
 	for (i = 1; i <= fs->super->s_inodes_count && i > 0; i++) {
 		actual = ext2fs_fast_test_inode_bitmap(ctx->inode_used_map, i);
-		if (skip_group) 
+		if (skip_group || (i >= first_unused_inode))
 			bitmap = 0;
 		else
 			bitmap = ext2fs_fast_test_inode_bitmap(fs->inode_map, i);
@@ -425,6 +439,7 @@ do_counts:
 			skip_group = 0;
 			group_free = 0;
 			dirs_count = 0;
+			first_unused_inode = 0;
 			if (ctx->progress)
 				if ((ctx->progress)(ctx, 5,
 					    group + fs->group_desc_count,
@@ -433,8 +448,16 @@ do_counts:
 			if (lazy_bg &&
 			    (i != fs->super->s_inodes_count) &&
 			    (fs->group_desc[group].bg_flags &
-			     EXT2_BG_INODE_UNINIT))
+			     EXT2_BG_INODE_UNINIT) &&
+			    ext2fs_group_desc_csum_verify(fs->super,
+							 &fs->group_desc[group],
+							 group))
 				skip_group++;
+			first_unused_inode =
+				(fs->super->s_inodes_per_group - 
+				 fs->group_desc[group].bg_itable_unused) +
+				(group * fs->super->s_inodes_per_group + 1);
+
 		}
 	}
 	if (pctx.ino)
@@ -469,14 +492,20 @@ do_counts:
 		ext2fs_unmark_valid(fs);
 	
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (free_array[i] != fs->group_desc[i].bg_free_inodes_count) {
+		unused_inode_count += 	fs->group_desc[i].bg_itable_unused;
+		if (free_array[i] != fs->group_desc[i].bg_free_inodes_count +
+				     fs->group_desc[i].bg_itable_unused) {
 			pctx.group = i;
-			pctx.ino = fs->group_desc[i].bg_free_inodes_count;
+			pctx.ino = fs->group_desc[i].bg_free_inodes_count +
+					fs->group_desc[i].bg_itable_unused;
 			pctx.ino2 = free_array[i];
 			if (fix_problem(ctx, PR_5_FREE_INODE_COUNT_GROUP,
 					&pctx)) {
 				fs->group_desc[i].bg_free_inodes_count =
 					free_array[i];
+				fs->group_desc[i].bg_checksum =
+					ext2fs_group_desc_csum(fs->super,
+							&fs->group_desc[i], i);
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -490,12 +519,16 @@ do_counts:
 					&pctx)) {
 				fs->group_desc[i].bg_used_dirs_count =
 					dir_array[i];
+				fs->group_desc[i].bg_checksum =
+					ext2fs_group_desc_csum(fs->super,
+						       &fs->group_desc[i], i);
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
 		}
 	}
-	if (free_inodes != fs->super->s_free_inodes_count) {
+	if (free_inodes != (fs->super->s_free_inodes_count +
+			    unused_inode_count)) {
 		pctx.group = -1;
 		pctx.ino = fs->super->s_free_inodes_count;
 		pctx.ino2 = free_inodes;
Index: e2fsprogs/e2fsck/super.c
===================================================================
--- e2fsprogs.orig/e2fsck/super.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/e2fsck/super.c	2006-09-16 23:39:48.000000000 -0600
@@ -576,8 +576,11 @@ void check_super_block(e2fsck_t ctx)
 		if ((gd->bg_block_bitmap < first_block) ||
 		    (gd->bg_block_bitmap > last_block)) {
 			pctx.blk = gd->bg_block_bitmap;
-			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
+			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx)) {
 				gd->bg_block_bitmap = 0;
+				gd->bg_checksum =
+					ext2fs_group_desc_csum(fs->super, gd,i);
+			}
 		}
 		if (gd->bg_block_bitmap == 0) {
 			ctx->invalid_block_bitmap_flag[i]++;
@@ -586,8 +589,11 @@ void check_super_block(e2fsck_t ctx)
 		if ((gd->bg_inode_bitmap < first_block) ||
 		    (gd->bg_inode_bitmap > last_block)) {
 			pctx.blk = gd->bg_inode_bitmap;
-			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
+			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx)) {
 				gd->bg_inode_bitmap = 0;
+				gd->bg_checksum =
+					ext2fs_group_desc_csum(fs->super, gd,i);
+			}
 		}
 		if (gd->bg_inode_bitmap == 0) {
 			ctx->invalid_inode_bitmap_flag[i]++;
@@ -597,8 +603,11 @@ void check_super_block(e2fsck_t ctx)
 		    ((gd->bg_inode_table +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
 			pctx.blk = gd->bg_inode_table;
-			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
+			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx)) {
 				gd->bg_inode_table = 0;
+				gd->bg_checksum =
+					ext2fs_group_desc_csum(fs->super, gd,i);
+			}
 		}
 		if (gd->bg_inode_table == 0) {
 			ctx->invalid_inode_table_flag[i]++;
@@ -612,6 +621,12 @@ void check_super_block(e2fsck_t ctx)
 		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
+		if (ext2fs_group_desc_csum_verify(sb, gd, i) &&
+		    fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
+			gd->bg_checksum =
+				ext2fs_group_desc_csum(fs->super, gd, i);
+		else
+			ext2fs_unmark_valid(fs);
 	}
 
 	/*
Index: e2fsprogs/lib/e2p/feature.c
===================================================================
--- e2fsprogs.orig/lib/e2p/feature.c	2006-05-18 02:45:07.000000000 -0600
+++ e2fsprogs/lib/e2p/feature.c	2006-09-16 17:31:15.000000000 -0600
@@ -41,6 +41,8 @@ static struct feature feature_list[] = {
 			"sparse_super" },
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_LARGE_FILE,
 			"large_file" },
+	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_GDT_CSUM,
+			"gdt_csum" },
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
 			"compression" },
 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_FILETYPE,
Index: e2fsprogs/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs.orig/lib/ext2fs/Makefile.in	2006-09-16 17:31:09.000000000 -0600
+++ e2fsprogs/lib/ext2fs/Makefile.in	2006-09-17 01:33:13.000000000 -0600
@@ -66,7 +66,9 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	unix_io.o \
 	unlink.o \
 	valid_blk.o \
-	version.o
+	version.o \
+	crc16.o \
+	csum.o
 
 SRCS= ext2_err.c \
 	$(srcdir)/alloc.c \
@@ -135,7 +137,10 @@ SRCS= ext2_err.c \
 	$(srcdir)/tst_byteswap.c \
 	$(srcdir)/tst_getsize.c \
 	$(srcdir)/tst_types.c \
-	$(srcdir)/tst_iscan.c
+	$(srcdir)/tst_iscan.c \
+	$(srcdir)/tst_csum.c \
+	$(srcdir)/crc16.c \
+	$(srcdir)/csum.c
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h block.h \
 	ext4_extents.h
@@ -228,16 +233,21 @@ tst_types: tst_types.o ext2_types.h 
 	@echo "	LD $@"
 	@$(CC) -o tst_types tst_types.o 
 
+tst_csum: tst_csum.o csum.o crc16.o
+	@echo "	LD $@"
+	@$(CC) -o tst_csum csum.o tst_csum.o crc16.o
+
 mkjournal: mkjournal.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
-check:: tst_bitops tst_badblocks tst_iscan @SWAPFS_CMT@ tst_byteswap tst_types
+check:: tst_bitops tst_badblocks tst_iscan tst_types @SWAPFS_CMT@ tst_byteswap
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
 @SWAPFS_CMT@	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_byteswap
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_types
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_csum
 
 installdirs::
 	@echo "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
@@ -344,6 +354,8 @@ cmp_bitmaps.o: $(srcdir)/cmp_bitmaps.c $
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h $(srcdir)/ext2_io.h \
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+csum.o: $(srcdir)/csum.c $(srcdir)/ext2_fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h
 dblist.o: $(srcdir)/dblist.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fsP.h \
  $(srcdir)/ext2fs.h $(srcdir)/ext2_fs.h $(top_srcdir)/lib/et/com_err.h \
Index: e2fsprogs/lib/ext2fs/alloc.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/alloc.c	2006-02-09 14:08:13.000000000 -0700
+++ e2fsprogs/lib/ext2fs/alloc.c	2006-09-16 17:31:15.000000000 -0600
@@ -77,6 +77,7 @@ errcode_t ext2fs_new_block(ext2_filsys f
 			   ext2fs_block_bitmap map, blk_t *ret)
 {
 	blk_t	i;
+	int     group;	
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -87,14 +88,30 @@ errcode_t ext2fs_new_block(ext2_filsys f
 	if (!goal || (goal >= fs->super->s_blocks_count))
 		goal = fs->super->s_first_data_block;
 	i = goal;
+	group = ext2fs_group_of_blk(fs, goal);
 	do {
+		if (fs->group_desc[group].bg_flags & EXT2_BG_BLOCK_UNINIT) {
+			group++;
+
+			/*
+			 * Move to start of next group
+			 */
+			i = group * fs->super->s_blocks_per_group +
+				fs->super->s_first_data_block;
+			continue;
+		}
 		if (!ext2fs_fast_test_block_bitmap(map, i)) {
 			*ret = i;
 			return 0;
 		}
 		i++;
-		if (i >= fs->super->s_blocks_count)
+		if (i >= ((group + 1) * fs->super->s_blocks_per_group +
+			  fs->super->s_first_data_block))
+			group++;
+		if (i >= fs->super->s_blocks_count) {
 			i = fs->super->s_first_data_block;
+			group = 0;
+		}
 	} while (i != goal);
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
Index: e2fsprogs/lib/ext2fs/alloc_stats.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/alloc_stats.c	2006-02-09 14:08:13.000000000 -0700
+++ e2fsprogs/lib/ext2fs/alloc_stats.c	2006-09-16 23:33:59.000000000 -0600
@@ -27,6 +27,8 @@ void ext2fs_inode_alloc_stats2(ext2_fils
 	fs->group_desc[group].bg_free_inodes_count -= inuse;
 	if (isdir)
 		fs->group_desc[group].bg_used_dirs_count += inuse;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[group],group);
 	fs->super->s_free_inodes_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -46,6 +48,8 @@ void ext2fs_block_alloc_stats(ext2_filsy
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[group],group);
 	fs->super->s_free_blocks_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
Index: e2fsprogs/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/alloc_tables.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/lib/ext2fs/alloc_tables.c	2006-09-16 23:36:25.000000000 -0600
@@ -95,13 +95,12 @@ errcode_t ext2fs_allocate_group_table(ex
 			ext2fs_mark_block_bitmap(bmap, blk);
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[group],group);
 
-	
 	return 0;
 }
 
-	
-
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
 	errcode_t	retval;
Index: e2fsprogs/lib/ext2fs/crc16.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/crc16.c	2006-09-06 05:35:19.060515568 -0600
+++ e2fsprogs/lib/ext2fs/crc16.c	2006-09-16 17:31:15.000000000 -0600
@@ -0,0 +1,60 @@
+/*
+ *      crc16.c
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/types.h>
+#include "crc16.h"
+
+/** CRC table for the CRC-16. The poly is 0x8005 (x^16 + x^15 + x^2 + 1) */
+uint16_t const crc16_table[256] = {
+	0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
+	0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
+	0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
+	0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
+	0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
+	0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
+	0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
+	0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
+	0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
+	0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
+	0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
+	0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
+	0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
+	0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
+	0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
+	0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
+	0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
+	0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
+	0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
+	0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
+	0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
+	0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
+	0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
+	0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
+	0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
+	0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
+	0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
+	0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
+	0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
+	0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
+	0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
+	0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
+};
+
+/**
+ * Compute the CRC-16 for the data buffer
+ *
+ * @param crc     previous CRC value
+ * @param buffer  data pointer
+ * @param len     number of bytes in the buffer
+ * @return        the updated CRC value
+ */
+uint16_t crc16(uint16_t crc, unsigned char const *buffer, size_t len)
+{
+	while (len--)
+		crc = crc16_byte(crc, *buffer++);
+	return crc;
+}
Index: e2fsprogs/lib/ext2fs/crc16.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/crc16.h	2006-09-06 05:35:19.060515568 -0600
+++ e2fsprogs/lib/ext2fs/crc16.h	2006-09-16 17:31:15.000000000 -0600
@@ -0,0 +1,29 @@
+/*
+ *	crc16.h - CRC-16 routine
+ *
+ * Implements the standard CRC-16:
+ *   Width 16
+ *   Poly  0x8005 (x^16 + x^15 + x^2 + 1)
+ *   Init  0
+ *
+ * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#ifndef __CRC16_H
+#define __CRC16_H
+
+#include <linux/types.h>
+
+extern uint16_t const crc16_table[256];
+
+extern uint16_t crc16(uint16_t crc, const unsigned char *buffer, size_t len);
+
+static inline uint16_t crc16_byte(uint16_t crc, const unsigned char data)
+{
+	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
+}
+
+#endif /* __CRC16_H */
Index: e2fsprogs/lib/ext2fs/csum.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/csum.c	2006-09-06 05:35:19.060515568 -0600
+++ e2fsprogs/lib/ext2fs/csum.c	2006-09-17 01:46:35.000000000 -0600
@@ -0,0 +1,51 @@
+/*
+ * csum.c --- checksumming of ext3 structures
+ *
+ * Copyright (C) 2006 Cluster File Systems, Inc.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include <assert.h>
+
+#ifndef offsetof
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+__u16 ext2fs_group_desc_csum(struct ext2_super_block *sb,
+			     struct ext2_group_desc *desc, __u32 group)
+{
+	__u16 crc = 0;
+
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		int offset = offsetof(struct ext2_group_desc, bg_checksum);
+
+		crc = crc16(~0, sb->s_uuid, sizeof(sb->s_uuid));
+		crc = crc16(crc16, &group, sizeof(group));
+		crc = crc16(crc, desc, offset);
+		offset += sizeof(desc->bg_checksum); /* skip checksum */
+		assert(offset == sizeof(*desc)); /* XXX handle s_desc_size */
+		/*
+		if (offset < sb->s_desc_size) {
+			crc = crc16(crc, (char *)desc + offset,
+				    sb->s_desc_size - offset);
+		 */
+	}
+
+	return crc;
+}
+
+int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb,
+				  struct ext2_group_desc *desc, __u32 group)
+{
+	if (desc->bg_checksum != ext2fs_group_desc_csum(sb, desc, group))
+		return 0;
+
+	return 1;
+}
+
Index: e2fsprogs/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h	2006-09-16 17:31:12.000000000 -0600
+++ e2fsprogs/lib/ext2fs/ext2_fs.h	2006-09-16 17:31:15.000000000 -0600
@@ -144,7 +144,10 @@ struct ext2_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u32	bg_reserved[3];
+	__u32	bg_reserved[2];
+	__u16   bg_itable_unused;       /*Unused inode count*/
+	__u16   bg_checksum;
+
 };
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
@@ -576,6 +579,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 /* #define EXT2_FEATURE_RO_COMPAT_BTREE_DIR	0x0004 not used */
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010 /* Descriptor checksum */
 
 #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
 #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
Index: e2fsprogs/lib/ext2fs/ext2_fs.h.orig
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2_fs.h.orig	2006-09-13 13:03:18.000000000 -0600
+++ e2fsprogs/lib/ext2fs/ext2_fs.h.orig	2006-09-16 17:31:15.000000000 -0600
@@ -144,7 +144,10 @@ struct ext2_group_desc
 	__u16	bg_free_inodes_count;	/* Free inodes count */
 	__u16	bg_used_dirs_count;	/* Directories count */
 	__u16	bg_flags;
-	__u32	bg_reserved[3];
+	__u32	bg_reserved[2];
+	__u16   bg_itable_unused;       /*Unused inode count*/
+	__u16   bg_checksum;
+
 };
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
Index: e2fsprogs/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs.orig/lib/ext2fs/ext2fs.h	2006-09-16 17:31:13.000000000 -0600
+++ e2fsprogs/lib/ext2fs/ext2fs.h	2006-09-17 01:25:52.000000000 -0600
@@ -463,7 +463,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_EXTENTS)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE |\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 /*
  * function prototypes
  */
@@ -625,6 +626,12 @@ extern errcode_t ext2fs_compare_block_bi
 extern errcode_t ext2fs_compare_inode_bitmap(ext2fs_inode_bitmap bm1,
 					     ext2fs_inode_bitmap bm2);
 
+/* csum.c */
+extern __u16 ext2fs_group_desc_csum(struct ext2_super_block *sb,
+				    struct ext2_group_desc *desc, __u32 group);
+extern int ext2fs_group_desc_csum_verify(struct ext2_super_block *sb,
+				    struct ext2_group_desc *desc, __u32 group);
+
 /* dblist.c */
 
 extern errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs);
Index: e2fsprogs/lib/ext2fs/inode.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/inode.c	2006-05-18 02:45:07.000000000 -0600
+++ e2fsprogs/lib/ext2fs/inode.c	2006-09-16 23:04:49.000000000 -0600
@@ -229,6 +229,10 @@ static errcode_t get_next_blockgroup(ext
 
 	scan->bytes_left = 0;
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
+	if (scan->fs->super->s_feature_ro_compat &
+	    EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+		scan->inodes_left -=
+		     scan->fs->group_desc[scan->current_group].bg_itable_unused;
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
 	return 0;
 }
Index: e2fsprogs/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/openfs.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/lib/ext2fs/openfs.c	2006-09-16 23:00:17.000000000 -0600
@@ -279,8 +279,8 @@ errcode_t ext2fs_open2(const char *name,
 #ifdef EXT2FS_ENABLE_SWAPFS
 		if (fs->flags & EXT2_FLAG_SWAP_BYTES) {
 			gdp = (struct ext2_group_desc *) dest;
-			for (j=0; j < groups_per_block; j++)
-				ext2fs_swap_group_desc(gdp++);
+			for (j = 0; j < groups_per_block; j++)
+				ext2fs_swap_group_desc(gdp);
 		}
 #endif
 		dest += fs->blocksize;
Index: e2fsprogs/misc/mke2fs.c
===================================================================
--- e2fsprogs.orig/misc/mke2fs.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/misc/mke2fs.c	2006-09-16 23:50:15.000000000 -0600
@@ -262,6 +262,10 @@ _("Warning: the backup superblock/group 
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
 				fs->group_desc[group].bg_free_blocks_count++;
+				fs->group_desc[group].bg_checksum =
+					ext2fs_group_desc_csum(fs->super,
+							&fs->group_desc[group],
+							group);
 				fs->super->s_free_blocks_count++;
 			}
 		}
@@ -450,8 +454,7 @@ static void setup_lazy_bg(ext2_filsys fs
 	struct ext2_super_block *sb = fs->super;
 	struct ext2_group_desc *bg = fs->group_desc;
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG)) {
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super, EXT2_FEATURE_COMPAT_LAZY_BG)) {
 		for (i = 0; i < fs->group_desc_count; i++, bg++) {
 			if ((i == 0) ||
 			    (i == fs->group_desc_count-1))
@@ -469,6 +472,8 @@ static void setup_lazy_bg(ext2_filsys fs
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
 				sb->s_free_blocks_count -= blks;
 			}
+			bg->bg_checksum =
+				ext2fs_group_desc_csum(fs->super, bg, i);
 		}
 	}
 }
@@ -544,6 +549,8 @@ static void create_bad_block_inode(ext2_
 	
 	ext2fs_mark_inode_bitmap(fs->inode_map, EXT2_BAD_INO);
 	fs->group_desc[0].bg_free_inodes_count--;
+	fs->group_desc[0].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[0], 0);
 	fs->super->s_free_inodes_count--;
 	retval = ext2fs_update_bb_inode(fs, bb_list);
 	if (retval) {
@@ -563,6 +570,9 @@ static void reserve_inodes(ext2_filsys f
 		ext2fs_mark_inode_bitmap(fs->inode_map, i);
 		group = ext2fs_group_of_ino(fs, i);
 		fs->group_desc[group].bg_free_inodes_count--;
+		fs->group_desc[group].bg_checksum =
+			ext2fs_group_desc_csum(fs->super,
+					       &fs->group_desc[group], group);
 		fs->super->s_free_inodes_count--;
 	}
 	ext2fs_mark_ib_dirty(fs);
@@ -859,7 +869,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG,
-	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
+	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|	/* R/O compat */
+		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
 
 
Index: e2fsprogs/misc/tune2fs.c
===================================================================
--- e2fsprogs.orig/misc/tune2fs.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/misc/tune2fs.c	2006-09-16 23:41:10.000000000 -0600
@@ -213,6 +213,8 @@ static int release_blocks_proc(ext2_fils
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[group],group);
 	fs->super->s_free_blocks_count++;
 	return 0;
 }
Index: e2fsprogs/resize/resize2fs.c
===================================================================
--- e2fsprogs.orig/resize/resize2fs.c	2006-09-13 12:59:34.000000000 -0600
+++ e2fsprogs/resize/resize2fs.c	2006-09-17 01:42:14.000000000 -0600
@@ -338,7 +338,9 @@ retry:
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
 	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
-		
+	fs->group_desc[i].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, &fs->group_desc[i], i);
+
 	/*
 	 * If the number of block groups is staying the same, we're
 	 * done and can exit now.  (If the number block groups is
@@ -414,7 +416,8 @@ retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
-
+		fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, &fs->group_desc[i],i);
 		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval) goto errout;
 
@@ -1222,9 +1225,14 @@ static errcode_t inode_scan_and_fix(ext2
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
+		if (LINUX_S_ISDIR(inode.i_mode)) {
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
-		
+			rfs->new_fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(rfs->new_fs->super,
+						&rfs->new_fs->group_desc[group],
+						group);
+		}
+
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
 			printf("Inode moved %u->%u\n", ino, new_inode);
@@ -1475,6 +1483,9 @@ static errcode_t move_itables(ext2_resiz
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
 		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		rfs->old_fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(rfs->old_fs->super,
+					       &rfs->old_fs->group_desc[i], i);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
@@ -1572,8 +1583,13 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == fs->super->s_blocks_count-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
+			fs->group_desc[group].bg_free_blocks_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super,
+						       &fs->group_desc[group],
+						       group);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
@@ -1597,8 +1613,13 @@ static errcode_t ext2fs_calculate_summar
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
+			fs->group_desc[group].bg_free_inodes_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super,
+						       &fs->group_desc[group],
+						       group);
+			group++;
 			count = 0;
 			group_free = 0;
 		}

--p4qYPpj5QlsIQJ0K--
