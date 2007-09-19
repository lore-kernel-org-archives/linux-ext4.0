From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [PATCH] Ext4: Uninitialized Block Groups
Date: Tue, 18 Sep 2007 17:25:31 -0700
Message-ID: <46F06C7B.20308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070303030607010604040607"
Cc: Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53863 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbXISAYj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2007 20:24:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------070303030607010604040607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

from: Andreas Dilger <adilger@clusterfs.com>

In pass1 of e2fsck, every inode table in the fileystem is scanned and checked, 
regardless of whether it is in use.  This is this the most time consuming part 
of the filesystem check.  The unintialized block group feature can greatly 
reduce e2fsck time by eliminating checking of uninitialized inodes.  

With this feature, there is a a high water mark of used inodes for each block 
group.  Block and inode bitmaps can be uninitialized on disk via a flag in the
group descriptor to avoid reading or scanning them at e2fsck time.  A checksum
of each group descriptor is used to ensure that corruption in the group
descriptor's bit flags does not cause incorrect operation.

The feature is enabled through a mkfs option

	mke2fs /dev/ -O uninit_groups

A patch adding support for uninitialized block groups to e2fsprogs tools has 
been posted to the linux-ext4 mailing list.

The patches have been stress tested with fsstress and fsx.  In performance 
tests testing e2fsck time, we have seen that e2fsck time on ext3 grows 
linearly with the total number of inodes in the filesytem.  In ext4 with the 
uninitialized block groups feature, the e2fsck time is constant, based 
solely on the number of used inodes rather than the total inode count.  
Since typical ext4 filesystems only use 1-10% of their inodes, this feature can
greatly reduce e2fsck time for users.  With performance improvement of 2-20 
times, depending on how full the filesystem is.

The attached graph shows the major improvements in e2fsck times in filesystems
with a large total inode count, but few inodes in use.  

In each group descriptor if we have

EXT4_BG_INODE_UNINIT set in bg_flags:
        Inode table is not initialized/used in this group. So we can skip
        the consistency check during fsck.
EXT4_BG_BLOCK_UNINIT set in bg_flags:
        No block in the group is used. So we can skip the block bitmap
        verification for this group.

We also add two new fields to group descriptor as a part of
uninitialized group patch.

        __le16  bg_itable_unused;       /* Unused inodes count */
        __le16  bg_checksum;            /* crc16(sb_uuid+group+desc) */


bg_itable_unused:

If we have EXT4_BG_INODE_UNINIT not set in bg_flags
then bg_itable_unused will give the offset within
the inode table till the inodes are used. This can be
used by fsck to skip list of inodes that are marked unused.


bg_checksum:
Now that we depend on bg_flags and bg_itable_unused to determine
the block and inode usage, we need to make sure group descriptor
is not corrupt. We add checksum to group descriptor to
detect corruption. If the descriptor is found to be corrupt, we
mark all the blocks and inodes in the group used.


Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/balloc.c        |   94 +++++++++++++++++++++++++++++++++-
 fs/ext4/group.h         |   29 ++++++++++
 fs/ext4/ialloc.c        |  132 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/resize.c        |    2 
 fs/ext4/super.c         |   96 ++++++++++++++++++++++++++++++++++
 include/linux/ext4_fs.h |   14 ++++-
 6 files changed, 352 insertions(+), 15 deletions(-)

Index: linux-2.6.23-rc6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/balloc.c	2007-09-10 19:50:29.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/balloc.c	2007-09-18 11:38:24.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 
+#include "group.h"
 /*
  * balloc.c contains the blocks allocation and deallocation routines
  */
@@ -42,6 +43,74 @@
 
 }
 
+/* Initializes an uninitialized block bitmap if given, and returns the
+ * number of blocks free in the group. */
+unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
+				int block_group, struct ext4_group_desc *gdp)
+{
+	unsigned long start;
+	int bit, bit_max;
+	unsigned free_blocks;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	if (bh) {
+		J_ASSERT_BH(bh, buffer_locked(bh));
+
+		/* If checksum is bad mark all blocks used to prevent allocation
+		 * essentially implementing a per-group read-only flag. */
+		if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
+			ext4_error(sb, __FUNCTION__,
+				   "Checksum bad for group %u\n", block_group);
+			gdp->bg_free_blocks_count = 0;
+			gdp->bg_free_inodes_count = 0;
+			gdp->bg_itable_unused = 0;
+			memset(bh->b_data, 0xff, sb->s_blocksize);
+			return 0;
+		}
+		memset(bh->b_data, 0, sb->s_blocksize);
+	}
+
+	/* Check for superblock and gdt backups in this group */
+	bit_max = ext4_bg_has_super(sb, block_group);
+
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
+	    block_group < le32_to_cpu(sbi->s_es->s_first_meta_bg) *
+			  sbi->s_desc_per_block) {
+		if (bit_max) {
+			bit_max += ext4_bg_num_gdb(sb, block_group);
+			bit_max +=
+				le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks);
+		}
+	} else { /* For META_BG_BLOCK_GROUPS */
+		int group_rel = (block_group -
+				 le32_to_cpu(sbi->s_es->s_first_meta_bg)) %
+				EXT4_DESC_PER_BLOCK(sb);
+		if (group_rel == 0 || group_rel == 1 ||
+		    (group_rel == EXT4_DESC_PER_BLOCK(sb) - 1))
+			bit_max += 1;
+	}
+
+	/* Last and first groups are always initialized */
+	free_blocks = EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
+
+	if (bh) {
+		for (bit = 0; bit < bit_max; bit++)
+			ext4_set_bit(bit, bh->b_data);
+
+		start = block_group * EXT4_BLOCKS_PER_GROUP(sb) +
+			le32_to_cpu(sbi->s_es->s_first_data_block);
+
+		/* Set bits for block and inode bitmaps, and inode table */
+		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
+		ext4_set_bit(ext4_inode_bitmap(sb, gdp) - start, bh->b_data);
+		for (bit = le32_to_cpu(gdp->bg_inode_table) - start,
+		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
+			ext4_set_bit(bit, bh->b_data);
+	}
+
+	return free_blocks - sbi->s_itb_per_group - 2;
+}
+
 /*
  * The free blocks are managed by bitmaps.  A file system contains several
  * blocks groups.  Each group contains 1 bitmap block for blocks, 1 bitmap
@@ -110,16 +179,29 @@
  *
  * Return buffer_head on success or NULL in case of failure.
  */
-static struct buffer_head *
+struct buffer_head *
 read_block_bitmap(struct super_block *sb, unsigned int block_group)
 {
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
 
-	desc = ext4_get_group_desc (sb, block_group, NULL);
+	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-	bh = sb_bread(sb, ext4_block_bitmap(sb, desc));
+	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		bh = sb_getblk(sb, ext4_block_bitmap(sb, desc));
+		if (!buffer_uptodate(bh)) {
+			lock_buffer(bh);
+			if (!buffer_uptodate(bh)) {
+				ext4_init_block_bitmap(sb, bh, block_group,
+						       desc);
+				set_buffer_uptodate(bh);
+			}
+			unlock_buffer(bh);
+		}
+	} else {
+		bh = sb_bread(sb, ext4_block_bitmap(sb,desc));
+	}
 	if (!bh)
 		ext4_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
@@ -586,6 +668,7 @@
 	desc->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(desc->bg_free_blocks_count) +
 			group_freed);
+	desc->bg_checksum = ext4_group_desc_csum(sbi, block_group, desc);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
@@ -1644,8 +1727,11 @@
 			ret_block, goal_hits, goal_attempts);
 
 	spin_lock(sb_bgl_lock(sbi, group_no));
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
+		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, -num);
 
Index: linux-2.6.23-rc6/fs/ext4/group.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.23-rc6/fs/ext4/group.h	2007-09-18 11:38:24.000000000 -0700
@@ -0,0 +1,29 @@
+/*
+ *  linux/fs/ext4/group.h
+ *
+ * Copyright (C) 2007 Cluster File Systems, Inc
+ *
+ * Author: Andreas Dilger <adilger@clusterfs.com>
+ */
+
+#ifndef _LINUX_EXT4_GROUP_H
+#define _LINUX_EXT4_GROUP_H
+#if defined(CONFIG_CRC16)
+#include <linux/crc16.h>
+#endif
+
+extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
+				   struct ext4_group_desc *gdp);
+extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
+				       struct ext4_group_desc *gdp);
+struct buffer_head *read_block_bitmap(struct super_block *sb,
+				      unsigned int block_group);
+extern unsigned ext4_init_block_bitmap(struct super_block *sb,
+				       struct buffer_head *bh, int group,
+				       struct ext4_group_desc *desc);
+#define ext4_free_blocks_after_init(sb, group, desc)			\
+		ext4_init_block_bitmap(sb, NULL, group, desc)
+extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
+				       struct buffer_head *bh, int group,
+				       struct ext4_group_desc *desc);
+#endif /* _LINUX_EXT4_GROUP_H */
Index: linux-2.6.23-rc6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/ialloc.c	2007-09-10 19:50:29.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/ialloc.c	2007-09-18 11:38:24.000000000 -0700
@@ -28,6 +28,7 @@
 
 #include "xattr.h"
 #include "acl.h"
+#include "group.h"
 
 /*
  * ialloc.c contains the inodes allocation and deallocation routines
@@ -43,6 +44,52 @@
  * the free blocks count in the block.
  */
 
+/*
+ * To avoid calling the atomic setbit hundreds or thousands of times, we only
+ * need to use it within a single byte (to ensure we get endianness right).
+ * We can use memset for the rest of the bitmap as there are no other users.
+ */
+static void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
+{
+	int i;
+
+	if (start_bit >= end_bit)
+		return;
+
+	ext4_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
+	for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
+		ext4_set_bit(i, bitmap);
+	if (i < end_bit)
+		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
+}
+
+/* Initializes an uninitialized inode bitmap */
+unsigned ext4_init_inode_bitmap(struct super_block *sb,
+				struct buffer_head *bh, int block_group,
+				struct ext4_group_desc *gdp)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+
+	J_ASSERT_BH(bh, buffer_locked(bh));
+
+	/* If checksum is bad mark all blocks and inodes use to prevent
+	 * allocation, essentially implementing a per-group read-only flag. */
+	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
+		ext4_error(sb, __FUNCTION__, "Checksum bad for group %u\n",
+			   block_group);
+		gdp->bg_free_blocks_count = 0;
+		gdp->bg_free_inodes_count = 0;
+		gdp->bg_itable_unused = 0;
+		memset(bh->b_data, 0xff, sb->s_blocksize);
+		return 0;
+	}
+
+	memset(bh->b_data, 0, (EXT4_INODES_PER_GROUP(sb) + 7) / 8);
+	mark_bitmap_end(EXT4_INODES_PER_GROUP(sb), EXT4_BLOCKS_PER_GROUP(sb),
+			bh->b_data);
+
+	return EXT4_INODES_PER_GROUP(sb);
+}
 
 /*
  * Read the inode allocation bitmap for a given block_group, reading
@@ -59,8 +106,20 @@
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		goto error_out;
-
-	bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
+	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+		bh = sb_getblk(sb, ext4_inode_bitmap(sb, desc));
+		if (!buffer_uptodate(bh)) {
+			lock_buffer(bh);
+			if (!buffer_uptodate(bh)) {
+				ext4_init_inode_bitmap(sb, bh, block_group,
+						       desc);
+				set_buffer_uptodate(bh);
+			}
+			unlock_buffer(bh);
+		}
+	} else {
+		bh = sb_bread(sb, ext4_inode_bitmap(sb, desc));
+	}
 	if (!bh)
 		ext4_error(sb, "read_inode_bitmap",
 			    "Cannot read inode bitmap - "
@@ -169,6 +228,8 @@
 			if (is_directory)
 				gdp->bg_used_dirs_count = cpu_to_le16(
 				  le16_to_cpu(gdp->bg_used_dirs_count) - 1);
+			gdp->bg_checksum = ext4_group_desc_csum(sbi,
+							block_group, gdp);
 			spin_unlock(sb_bgl_lock(sbi, block_group));
 			percpu_counter_inc(&sbi->s_freeinodes_counter);
 			if (is_directory)
@@ -438,7 +499,7 @@
 	struct ext4_sb_info *sbi;
 	int err = 0;
 	struct inode *ret;
-	int i;
+	int i, free = 0;
 
 	/* Cannot create files in a deleted directory */
 	if (!dir || !dir->i_nlink)
@@ -520,11 +581,13 @@
 	goto out;
 
 got:
-	ino += group * EXT4_INODES_PER_GROUP(sb) + 1;
-	if (ino < EXT4_FIRST_INO(sb) || ino > le32_to_cpu(es->s_inodes_count)) {
-		ext4_error (sb, "ext4_new_inode",
-			    "reserved inode or inode > inodes count - "
-			    "block_group = %d, inode=%lu", group, ino);
+	ino++;
+	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
+	    ino > EXT4_INODES_PER_GROUP(sb)) {
+		ext4_error(sb, __FUNCTION__,
+			   "reserved inode or inode > inodes count - "
+			   "block_group = %d, inode=%lu", group,
+			   ino + group * EXT4_INODES_PER_GROUP(sb));
 		err = -EIO;
 		goto fail;
 	}
@@ -532,13 +595,64 @@
 	BUFFER_TRACE(bh2, "get_write_access");
 	err = ext4_journal_get_write_access(handle, bh2);
 	if (err) goto fail;
+
+	/* We may have to initialize the block bitmap if it isn't already */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	    gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		struct buffer_head *block_bh = read_block_bitmap(sb, group);
+
+		BUFFER_TRACE(block_bh, "get block bitmap access");
+		err = ext4_journal_get_write_access(handle, block_bh);
+		if (err) {
+			brelse(block_bh);
+			goto fail;
+		}
+
+		free = 0;
+		spin_lock(sb_bgl_lock(sbi, group));
+		/* recheck and clear flag under lock if we still need to */
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
+			free = ext4_free_blocks_after_init(sb, group, gdp);
+			gdp->bg_free_blocks_count = cpu_to_le16(free);
+		}
+		spin_unlock(sb_bgl_lock(sbi, group));
+
+		/* Don't need to dirty bitmap block if we didn't change it */
+		if (free) {
+			BUFFER_TRACE(block_bh, "dirty block bitmap");
+			err = ext4_journal_dirty_metadata(handle, block_bh);
+		}
+
+		brelse(block_bh);
+		if (err)
+			goto fail;
+	}
+
 	spin_lock(sb_bgl_lock(sbi, group));
+	/* If we didn't allocate from within the initialized part of the inode
+	 * table then we need to initialize up to this inode. */
+	if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
+			gdp->bg_flags &= cpu_to_le16(~EXT4_BG_INODE_UNINIT);
+			free = EXT4_INODES_PER_GROUP(sb);
+		} else {
+			free = EXT4_INODES_PER_GROUP(sb) -
+				le16_to_cpu(gdp->bg_itable_unused);
+		}
+
+		if (ino > free)
+			gdp->bg_itable_unused =
+				cpu_to_le16(EXT4_INODES_PER_GROUP(sb) - ino);
+	}
+
 	gdp->bg_free_inodes_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_inodes_count) - 1);
 	if (S_ISDIR(mode)) {
 		gdp->bg_used_dirs_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_used_dirs_count) + 1);
 	}
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group));
 	BUFFER_TRACE(bh2, "call ext4_journal_dirty_metadata");
 	err = ext4_journal_dirty_metadata(handle, bh2);
@@ -560,7 +674,7 @@
 		inode->i_gid = current->fsgid;
 	inode->i_mode = mode;
 
-	inode->i_ino = ino;
+	inode->i_ino = ino + group * EXT4_INODES_PER_GROUP(sb);
 	/* This is the optimal IO size (for stat), not the fs block size */
 	inode->i_blocks = 0;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ei->i_crtime =
Index: linux-2.6.23-rc6/fs/ext4/resize.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/resize.c	2007-09-10 19:50:29.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/resize.c	2007-09-18 11:38:24.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 
+#include "group.h"
 
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
@@ -842,6 +843,7 @@
 	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
 	gdp->bg_free_blocks_count = cpu_to_le16(input->free_blocks_count);
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
Index: linux-2.6.23-rc6/fs/ext4/super.c
===================================================================
--- linux-2.6.23-rc6.orig/fs/ext4/super.c	2007-09-18 11:37:28.000000000 -0700
+++ linux-2.6.23-rc6/fs/ext4/super.c	2007-09-18 11:38:24.000000000 -0700
@@ -43,6 +43,7 @@
 #include "xattr.h"
 #include "acl.h"
 #include "namei.h"
+#include "group.h"
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -1247,6 +1248,93 @@
 	return res;
 }
 
+#if !defined(CONFIG_CRC16)
+/** CRC table for the CRC-16. The poly is 0x8005 (x16 + x15 + x2 + 1) */
+__u16 const crc16_table[256] = {
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
+static inline __u16 crc16_byte(__u16 crc, const __u8 data)
+{
+	return (crc >> 8) ^ crc16_table[(crc ^ data) & 0xff];
+}
+
+__u16 crc16(__u16 crc, __u8 const *buffer, size_t len)
+{
+	while (len--)
+		crc = crc16_byte(crc, *buffer++);
+	return crc;
+}
+#endif
+
+__le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
+			    struct ext4_group_desc *gdp)
+{
+	__u16 crc = 0;
+
+	if (sbi->s_es->s_feature_ro_compat &
+	    cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		int offset = offsetof(struct ext4_group_desc, bg_checksum);
+		__le32 le_group = cpu_to_le32(block_group);
+
+		crc = crc16(~0, sbi->s_es->s_uuid, sizeof(sbi->s_es->s_uuid));
+		crc = crc16(crc, (__u8 *)&le_group, sizeof(le_group));
+		crc = crc16(crc, (__u8 *)gdp, offset);
+		offset += sizeof(gdp->bg_checksum); /* skip checksum */
+		/* for checksum of struct ext4_group_desc do the rest...*/
+		if ((sbi->s_es->s_feature_incompat &
+		     cpu_to_le32(EXT4_FEATURE_INCOMPAT_64BIT)) &&
+		    offset < le16_to_cpu(sbi->s_es->s_desc_size))
+			crc = crc16(crc, (__u8 *)gdp + offset,
+				    le16_to_cpu(sbi->s_es->s_desc_size) -
+					offset);
+	}
+
+	return cpu_to_le16(crc);
+}
+
+int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 block_group,
+				struct ext4_group_desc *gdp)
+{
+	if ((sbi->s_es->s_feature_ro_compat &
+	     cpu_to_le32(EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) &&
+	    (gdp->bg_checksum != ext4_group_desc_csum(sbi, block_group, gdp)))
+		return 0;
+
+	return 1;
+}
+
 /* Called at mount-time, super-block is locked */
 static int ext4_check_descriptors (struct super_block * sb)
 {
@@ -1301,6 +1389,14 @@
 				    i, inode_table);
 			return 0;
 		}
+		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
+			ext4_error(sb, __FUNCTION__,
+				   "Checksum for group %d failed (%u!=%u)\n", i,
+				   le16_to_cpu(ext4_group_desc_csum(sbi, i,
+								    gdp)),
+				   le16_to_cpu(gdp->bg_checksum));
+			return 0;
+		}
 		first_block += EXT4_BLOCKS_PER_GROUP(sb);
 		gdp = (struct ext4_group_desc *)
 			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
Index: linux-2.6.23-rc6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.23-rc6.orig/include/linux/ext4_fs.h	2007-09-18 11:37:28.000000000 -0700
+++ linux-2.6.23-rc6/include/linux/ext4_fs.h	2007-09-18 11:38:24.000000000 -0700
@@ -123,19 +123,25 @@
  */
 struct ext4_group_desc
 {
-	__le32	bg_block_bitmap;		/* Blocks bitmap block */
-	__le32	bg_inode_bitmap;		/* Inodes bitmap block */
+	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-	__u16	bg_flags;
-	__u32	bg_reserved[3];
+	__u16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
+	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
+	__le16  bg_itable_unused;	/* Unused inodes count */
+	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
 	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
 };
 
+#define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
+#define EXT4_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not in use */
+#define EXT4_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+
 #ifdef __KERNEL__
 #include <linux/ext4_fs_i.h>
 #include <linux/ext4_fs_sb.h>
@@ -693,6 +699,7 @@
 #define EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
 #define EXT4_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
 #define EXT4_FEATURE_RO_COMPAT_BTREE_DIR	0x0004
+#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010
 #define EXT4_FEATURE_RO_COMPAT_DIR_NLINK	0x0020
 #define EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE	0x0040
 
@@ -712,6 +719,7 @@
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK | \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE | \
 					 EXT4_FEATURE_RO_COMPAT_BTREE_DIR)



--------------070303030607010604040607
Content-Type: application/pdf;
 name="e2fsck-uninit.pdf"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="e2fsck-uninit.pdf"

JVBERi0xLjQKNCAwIG9iaiA8PAovTGVuZ3RoIDM4ICAgICAgICAKL0ZpbHRlciAvRmxhdGVE
ZWNvZGUKPj4Kc3RyZWFtCnjaK+QyVDAAQkMFXUtLBV0TYwuF5Fwufc9cQwWXfK5ALgBncgaR
ZW5kc3RyZWFtCmVuZG9iagozIDAgb2JqIDw8Ci9UeXBlIC9QYWdlCi9Db250ZW50cyA0IDAg
UgovUmVzb3VyY2VzIDIgMCBSCi9NZWRpYUJveCBbMCAwIDM4MCAyNzNdCi9QYXJlbnQgNSAw
IFIKPj4gZW5kb2JqCjEgMCBvYmogPDwKL1R5cGUgL1hPYmplY3QKL1N1YnR5cGUgL0Zvcm0K
L0Zvcm1UeXBlIDEKL1BURVguRmlsZU5hbWUgKC4vZnNjay10eHQucGRmKQovUFRFWC5QYWdl
TnVtYmVyIDEKL1BURVguSW5mb0RpY3QgNiAwIFIgCi9NYXRyaXggWzEgMCAwIDEgMCAwXQov
QkJveCBbMCAwIDYxMiA3OTJdCi9SZXNvdXJjZXMgPDwKL0ZvbnQgPDwgL0YxIDcgMCBSPj4K
L1Byb2NTZXQgWyAvUERGIF0KPj4KL0xlbmd0aCA4IDAgUgo+PgpzdHJlYW0KMCB3DQpxIDAg
LTAuMSA2MTIuMSA3OTIuMSByZSBXKiBuDQpRIHEgOTAgNDMwLjcgMzg4LjYgMjg5LjMgcmUg
Vyogbg0KMSAxIDEgcmcNCjkwIDcyMCBtDQo0NzguNSA3MjAgbCA0NzguNSA0MzAuOCBsIDkw
IDQzMC44IGwgOTAgNzIwIGwgaA0KZioNCjE0OS4xIDY4MS42IG0NCjM3MiA2ODEuNiBsIDM3
MiA0NzUuMSBsIDE0OS4xIDQ3NS4xIGwgMTQ5LjEgNjgxLjYgbA0KaA0KZioNCjAgMCAwIFJH
DQoxNDkuMSA0NzUuMSBtDQozNzIgNDc1LjEgbCBTDQoxNDkuMSA0OTguMSBtDQozNzIgNDk4
LjEgbCBTDQoxNDkuMSA1MjEgbQ0KMzcyIDUyMSBsIFMNCjE0OS4xIDU0NCBtDQozNzIgNTQ0
IGwgUw0KMTQ5LjEgNTY2LjkgbQ0KMzcyIDU2Ni45IGwgUw0KMTQ5LjEgNTg5LjggbQ0KMzcy
IDU4OS44IGwgUw0KMTQ5LjEgNjEyLjggbQ0KMzcyIDYxMi44IGwgUw0KMTQ5LjEgNjM1Ljcg
bQ0KMzcyIDYzNS43IGwgUw0KMTQ5LjEgNjU4LjYgbQ0KMzcyIDY1OC42IGwgUw0KMTQ5LjEg
NjgxLjYgbQ0KMzcyIDY4MS42IGwgUw0KMTQ5LjEgNDc1LjEgbQ0KMzcyIDQ3NS4xIGwgUw0K
MTQ5LjEgNDc1LjEgbQ0KMzcyIDQ3NS4xIGwgUw0KMTQ5LjEgNDcwLjkgbQ0KMTQ5LjEgNDc1
LjEgbCBTDQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAgMSAxNDYuMyA0NTguOSBUbQ0K
L0YxIDEwLjEgVGYgPDAxPiBUag0KRVQNClENCjAgMCAwIFJHDQoxODEgNDcwLjkgbQ0KMTgx
IDQ3NS4xIGwgUw0KcSAwIDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgMTc0IDQ1OC45IFRt
DQovRjEgMTAuMSBUZiA8MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDE3OS42IDQ1OC45IFRtDQo8
MDI+IFRqDQoxLjAwMDE3IDAgMCAxIDE4Mi40IDQ1OC45IFRtDQo8MDM+IFRqDQpFVA0KUQ0K
MCAwIDAgUkcNCjIxMi44IDQ3MC45IG0NCjIxMi44IDQ3NS4xIGwgUw0KcSAwIDAgMCByZw0K
QlQNCjEuMDAwMTcgMCAwIDEgMjA3LjIgNDU4LjkgVG0NCi9GMSAxMC4xIFRmIDwwND4gVGoN
CjEuMDAwMTcgMCAwIDEgMjEyLjggNDU4LjkgVG0NCjwwMT4gVGoNCkVUDQpRDQowIDAgMCBS
Rw0KMjQ0LjYgNDcwLjkgbQ0KMjQ0LjYgNDc1LjEgbCBTDQpxIDAgMCAwIHJnDQpCVA0KMS4w
MDAxNyAwIDAgMSAyMzkgNDU4LjkgVG0NCi9GMSAxMC4xIFRmIDwwND4gVGoNCjEuMDAwMTcg
MCAwIDEgMjQ0LjcgNDU4LjkgVG0NCjwwMz4gVGoNCkVUDQpRDQowIDAgMCBSRw0KMjc2LjUg
NDcwLjkgbQ0KMjc2LjUgNDc1LjEgbCBTDQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAg
MSAyNzAuOCA0NTguOSBUbQ0KL0YxIDEwLjEgVGYgPDA1PiBUag0KMS4wMDAxNyAwIDAgMSAy
NzYuNSA0NTguOSBUbQ0KPDAxPiBUag0KRVQNClENCjAgMCAwIFJHDQozMDguMyA0NzAuOSBt
DQozMDguMyA0NzUuMSBsIFMNCnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAgMCAxIDMwMi43
IDQ1OC45IFRtDQovRjEgMTAuMSBUZiA8MDU+IFRqDQoxLjAwMDE3IDAgMCAxIDMwOC4zIDQ1
OC45IFRtDQo8MDM+IFRqDQpFVA0KUQ0KMCAwIDAgUkcNCjM0MC4xIDQ3MC45IG0NCjM0MC4x
IDQ3NS4xIGwgUw0KcSAwIDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgMzM0LjUgNDU4Ljkg
VG0NCi9GMSAxMC4xIFRmIDwwNj4gVGoNCjEuMDAwMTcgMCAwIDEgMzQwLjEgNDU4LjkgVG0N
CjwwMT4gVGoNCkVUDQpRDQowIDAgMCBSRw0KMzcyIDQ3MC45IG0NCjM3MiA0NzUuMSBsIFMN
CnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAgMCAxIDM2Ni40IDQ1OC45IFRtDQovRjEgMTAu
MSBUZiA8MDY+IFRqDQoxLjAwMDE3IDAgMCAxIDM3MiA0NTguOSBUbQ0KPDAzPiBUag0KRVQN
ClENCjAgMCAwIFJHDQoxNDkuMSA0NzUuMSBtDQoxNDkuMSA2ODEuNiBsIFMNCjE0OS4xIDQ3
NS4xIG0NCjE0OS4xIDY4MS42IGwgUw0KMTQ0LjkgNDc1LjEgbQ0KMTQ5LjEgNDc1LjEgbCBT
DQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAgMSAxMzYuNCA0NzEuNiBUbQ0KL0YxIDEw
LjEgVGYgPDAxPiBUag0KRVQNClENCjAgMCAwIFJHDQoxNDQuOSA0OTguMSBtDQoxNDkuMSA0
OTguMSBsIFMNCnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAgMCAxIDEyNS4xIDQ5NC42IFRt
DQovRjEgMTAuMSBUZiA8MDM+IFRqDQoxLjAwMDE3IDAgMCAxIDEzMC43IDQ5NC42IFRtDQo8
MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDEzNi40IDQ5NC42IFRtDQo8MDE+IFRqDQpFVA0KUQ0K
MCAwIDAgUkcNCjE0NC45IDUyMSBtDQoxNDkuMSA1MjEgbCBTDQpxIDAgMCAwIHJnDQpCVA0K
MS4wMDAxNyAwIDAgMSAxMTkuNSA1MTcuNSBUbQ0KL0YxIDEwLjEgVGYgPDA0PiBUag0KMS4w
MDAxNyAwIDAgMSAxMjUuMSA1MTcuNSBUbQ0KPDAxPiBUag0KMS4wMDAxNyAwIDAgMSAxMzAu
NyA1MTcuNSBUbQ0KPDAxPiBUag0KMS4wMDAxNyAwIDAgMSAxMzYuNCA1MTcuNSBUbQ0KPDAx
PiBUag0KRVQNClENCjAgMCAwIFJHDQoxNDQuOSA1NDQgbQ0KMTQ5LjEgNTQ0IGwgUw0KcSAw
IDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgMTE5LjUgNTQwLjQgVG0NCi9GMSAxMC4xIFRm
IDwwND4gVGoNCjEuMDAwMTcgMCAwIDEgMTI1LjEgNTQwLjQgVG0NCjwwMz4gVGoNCjEuMDAw
MTcgMCAwIDEgMTMwLjcgNTQwLjQgVG0NCjwwMT4gVGoNCjEuMDAwMTcgMCAwIDEgMTM2LjQg
NTQwLjQgVG0NCjwwMT4gVGoNCkVUDQpRDQowIDAgMCBSRw0KMTQ0LjkgNTY2LjkgbQ0KMTQ5
LjEgNTY2LjkgbCBTDQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAgMSAxMTkuNSA1NjMu
NCBUbQ0KL0YxIDEwLjEgVGYgPDA1PiBUag0KMS4wMDAxNyAwIDAgMSAxMjUuMSA1NjMuNCBU
bQ0KPDAxPiBUag0KMS4wMDAxNyAwIDAgMSAxMzAuNyA1NjMuNCBUbQ0KPDAxPiBUag0KMS4w
MDAxNyAwIDAgMSAxMzYuNCA1NjMuNCBUbQ0KPDAxPiBUag0KRVQNClENCjAgMCAwIFJHDQox
NDQuOSA1ODkuOCBtDQoxNDkuMSA1ODkuOCBsIFMNCnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3
IDAgMCAxIDExOS41IDU4Ni4zIFRtDQovRjEgMTAuMSBUZiA8MDU+IFRqDQoxLjAwMDE3IDAg
MCAxIDEyNS4xIDU4Ni4zIFRtDQo8MDM+IFRqDQoxLjAwMDE3IDAgMCAxIDEzMC43IDU4Ni4z
IFRtDQo8MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDEzNi40IDU4Ni4zIFRtDQo8MDE+IFRqDQpF
VA0KUQ0KMCAwIDAgUkcNCjE0NC45IDYxMi44IG0NCjE0OS4xIDYxMi44IGwgUw0KcSAwIDAg
MCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgMTE5LjUgNjA5LjMgVG0NCi9GMSAxMC4xIFRmIDww
Nj4gVGoNCjEuMDAwMTcgMCAwIDEgMTI1LjEgNjA5LjMgVG0NCjwwMT4gVGoNCjEuMDAwMTcg
MCAwIDEgMTMwLjcgNjA5LjMgVG0NCjwwMT4gVGoNCjEuMDAwMTcgMCAwIDEgMTM2LjQgNjA5
LjMgVG0NCjwwMT4gVGoNCkVUDQpRDQowIDAgMCBSRw0KMTQ0LjkgNjM1LjcgbQ0KMTQ5LjEg
NjM1LjcgbCBTDQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAgMSAxMTkuNiA2MzIuMiBU
bQ0KL0YxIDEwLjEgVGYgPDA2PiBUag0KMS4wMDAxNyAwIDAgMSAxMjUuMSA2MzIuMiBUbQ0K
PDAzPiBUag0KMS4wMDAxNyAwIDAgMSAxMzAuNyA2MzIuMiBUbQ0KPDAxPiBUag0KMS4wMDAx
NyAwIDAgMSAxMzYuNCA2MzIuMiBUbQ0KPDAxPiBUag0KRVQNClENCjAgMCAwIFJHDQoxNDQu
OSA2NTguNiBtDQoxNDkuMSA2NTguNiBsIFMNCnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAg
MCAxIDExOS41IDY1NS4xIFRtDQovRjEgMTAuMSBUZiA8MDc+IFRqDQoxLjAwMDE3IDAgMCAx
IDEyNS4xIDY1NS4xIFRtDQo8MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDEzMC43IDY1NS4xIFRt
DQo8MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDEzNi40IDY1NS4xIFRtDQo8MDE+IFRqDQpFVA0K
UQ0KMCAwIDAgUkcNCjE0NC45IDY4MS42IG0NCjE0OS4xIDY4MS42IGwgUw0KcSAwIDAgMCBy
Zw0KQlQNCjEuMDAwMTcgMCAwIDEgMTE5LjUgNjc4LjEgVG0NCi9GMSAxMC4xIFRmIDwwNz4g
VGoNCjEuMDAwMTcgMCAwIDEgMTI1LjEgNjc4LjEgVG0NCjwwMz4gVGoNCjEuMDAwMTcgMCAw
IDEgMTMwLjcgNjc4LjEgVG0NCjwwMT4gVGoNCjEuMDAwMTcgMCAwIDEgMTM2LjQgNjc4LjEg
VG0NCjwwMT4gVGoNCkVUDQpRDQowLjU5OTk5IDAuNTk5OTkgMSBSRw0KMTQ5LjEgNDc5Ljcg
bQ0KMTgxIDUzOS40IGwgMjEyLjggNTc4LjQgbCAyNDQuNiA1ODkuOCBsIDI3Ni41IDYxMi44
IGwNCjMwOC4zIDYzNS43IGwgMzQwLjEgNjU4LjYgbCAzNzIgNjgxLjYgbCBTDQowLjU5OTk5
IDAuNTk5OTkgMSByZw0KMTQ2LjkgNDgxLjkgbQ0KMTQ2LjkgNDc3LjUgbCAxNTEuNCA0Nzcu
NSBsIDE1MS40IDQ4MS45IGwgMTQ2LjkgNDgxLjkgbA0KaA0KZioNCjAgMCAwIFJHDQoxNDYu
OSA0ODEuOSBtDQoxNDYuOSA0NzcuNSBsIDE1MS40IDQ3Ny41IGwgMTUxLjQgNDgxLjkgbCAx
NDYuOSA0ODEuOSBsDQpoDQpTDQowLjU5OTk5IDAuNTk5OTkgMSByZw0KMTc4LjcgNTQxLjYg
bQ0KMTc4LjcgNTM3LjEgbCAxODMuMiA1MzcuMSBsIDE4My4yIDU0MS42IGwgMTc4LjcgNTQx
LjYgbA0KaA0KZioNCjAgMCAwIFJHDQoxNzguNyA1NDEuNiBtDQoxNzguNyA1MzcuMSBsIDE4
My4yIDUzNy4xIGwgMTgzLjIgNTQxLjYgbCAxNzguNyA1NDEuNiBsDQpoDQpTDQowLjU5OTk5
IDAuNTk5OTkgMSByZw0KMjEwLjYgNTgwLjYgbQ0KMjEwLjYgNTc2LjEgbCAyMTUgNTc2LjEg
bCAyMTUgNTgwLjYgbCAyMTAuNiA1ODAuNiBsDQpoDQpmKg0KMCAwIDAgUkcNCjIxMC42IDU4
MC42IG0NCjIxMC42IDU3Ni4xIGwgMjE1IDU3Ni4xIGwgMjE1IDU4MC42IGwgMjEwLjYgNTgw
LjYgbA0KaA0KUw0KMC41OTk5OSAwLjU5OTk5IDEgcmcNCjI0Mi40IDU5Mi4xIG0NCjI0Mi40
IDU4Ny42IGwgMjQ2LjkgNTg3LjYgbCAyNDYuOSA1OTIuMSBsIDI0Mi40IDU5Mi4xIGwNCmgN
CmYqDQowIDAgMCBSRw0KMjQyLjQgNTkyLjEgbQ0KMjQyLjQgNTg3LjYgbCAyNDYuOSA1ODcu
NiBsIDI0Ni45IDU5Mi4xIGwgMjQyLjQgNTkyLjEgbA0KaA0KUw0KMC41OTk5OSAwLjU5OTk5
IDEgcmcNCjI3NC4yIDYxNSBtDQoyNzQuMiA2MTAuNSBsIDI3OC43IDYxMC41IGwgMjc4Ljcg
NjE1IGwgMjc0LjIgNjE1IGwgaA0KZioNCjAgMCAwIFJHDQoyNzQuMiA2MTUgbQ0KMjc0LjIg
NjEwLjUgbCAyNzguNyA2MTAuNSBsIDI3OC43IDYxNSBsIDI3NC4yIDYxNSBsIGgNClMNCjAu
NTk5OTkgMC41OTk5OSAxIHJnDQozMDYuMSA2MzcuOSBtDQozMDYuMSA2MzMuNSBsIDMxMC41
IDYzMy41IGwgMzEwLjUgNjM3LjkgbCAzMDYuMSA2MzcuOSBsDQpoDQpmKg0KMCAwIDAgUkcN
CjMwNi4xIDYzNy45IG0NCjMwNi4xIDYzMy41IGwgMzEwLjUgNjMzLjUgbCAzMTAuNSA2Mzcu
OSBsIDMwNi4xIDYzNy45IGwNCmgNClMNCjAuNTk5OTkgMC41OTk5OSAxIHJnDQozMzcuOSA2
NjAuOSBtDQozMzcuOSA2NTYuNCBsIDM0Mi40IDY1Ni40IGwgMzQyLjQgNjYwLjkgbCAzMzcu
OSA2NjAuOSBsDQpoDQpmKg0KMCAwIDAgUkcNCjMzNy45IDY2MC45IG0NCjMzNy45IDY1Ni40
IGwgMzQyLjQgNjU2LjQgbCAzNDIuNCA2NjAuOSBsIDMzNy45IDY2MC45IGwNCmgNClMNCjAu
NTk5OTkgMC41OTk5OSAxIHJnDQozNjkuNyA2ODMuOCBtDQozNjkuNyA2NzkuMyBsIDM3NC4y
IDY3OS4zIGwgMzc0LjIgNjgzLjggbCAzNjkuNyA2ODMuOCBsDQpoDQpmKg0KMCAwIDAgUkcN
CjM2OS43IDY4My44IG0NCjM2OS43IDY3OS4zIGwgMzc0LjIgNjc5LjMgbCAzNzQuMiA2ODMu
OCBsIDM2OS43IDY4My44IGwNCmgNClMNCjEgMSAwLjU5OTk5IHJnDQoxNDguNSA0ODAgbQ0K
MTgwLjMgNTQyIGwgMTgwLjMgNTQyIGwgMTgwLjQgNTQyLjEgbCAxODEgNTQxLjcgbCAxODEu
NiA1NDEuMyBsDQoxNDkuOCA0NzkuNCBsIDE0OC41IDQ4MCBsIGgNCmYqDQoxODAuNCA1NDIu
MSBtDQoyMTIuMiA1ODEuMSBsIDIxMi4yIDU4MS4xIGwgMjEyLjMgNTgxLjIgbCAyMTIuNCA1
ODEuMyBsDQoyMTIuNiA1ODEuMyBsIDIxMi44IDU4MC42IGwgMjEzLjMgNTgwLjIgbCAxODEu
NSA1NDEuMiBsIDE4MSA1NDEuNyBsDQoxODAuNCA1NDIuMSBsIGgNCmYqDQoyMTIuNiA1ODEu
MyBtDQoyNDQuNCA1OTAuNSBsIDI0NC42IDU4OS44IGwgMjQ1IDU4OS4yIGwgMjQ1IDU4OS4y
IGwNCjI0NC44IDU4OS4xIGwgMjEzIDU3OS45IGwgMjEyLjggNTgwLjYgbCAyMTIuNiA1ODEu
MyBsIGgNCmYqDQoyNDQuNiA1ODkuOCBtDQoyNDQuMiA1OTAuNCBsIDI3NiA2MTMuNCBsIDI3
Ni41IDYxMi44IGwgMjc2LjkgNjEyLjIgbA0KMjQ1IDU4OS4yIGwgMjQ0LjYgNTg5LjggbCBo
DQpmKg0KMjc2LjUgNjEyLjggbQ0KMjc2IDYxMy40IGwgMzA3LjkgNjM2LjMgbCAzMDguMyA2
MzUuNyBsIDMwOC43IDYzNS4xIGwNCjI3Ni45IDYxMi4yIGwgMjc2LjUgNjEyLjggbCBoDQpm
Kg0KMzA4LjMgNjM1LjcgbQ0KMzA3LjkgNjM2LjMgbCAzMzkuNyA2NTkuMiBsIDM0MC4xIDY1
OC42IGwgMzQwLjUgNjU4LjEgbA0KMzA4LjcgNjM1LjEgbCAzMDguMyA2MzUuNyBsIGgNCmYq
DQozNDAuMSA2NTguNiBtDQozMzkuNyA2NTkuMiBsIDM3MS41IDY4Mi4yIGwgMzcyLjQgNjgx
IGwgMzQwLjUgNjU4LjEgbA0KMzQwLjEgNjU4LjYgbCBoDQpmKg0KMTQ5LjEgNDgxLjkgbQ0K
MTUxLjQgNDc5LjcgbCAxNDkuMSA0NzcuNSBsIDE0Ni45IDQ3OS43IGwgMTQ5LjEgNDgxLjkg
bA0KaA0KZioNCjAgMCAwIFJHDQoxNDkuMSA0ODEuOSBtDQoxNTEuNCA0NzkuNyBsIDE0OS4x
IDQ3Ny41IGwgMTQ2LjkgNDc5LjcgbCAxNDkuMSA0ODEuOSBsDQpoDQpTDQoxIDEgMC41OTk5
OSByZw0KMTgxIDU0My45IG0NCjE4My4yIDU0MS43IGwgMTgxIDUzOS40IGwgMTc4LjcgNTQx
LjcgbCAxODEgNTQzLjkgbCBoDQpmKg0KMCAwIDAgUkcNCjE4MSA1NDMuOSBtDQoxODMuMiA1
NDEuNyBsIDE4MSA1MzkuNCBsIDE3OC43IDU0MS43IGwgMTgxIDU0My45IGwgaA0KUw0KMSAx
IDAuNTk5OTkgcmcNCjIxMi44IDU4Mi45IG0NCjIxNSA1ODAuNiBsIDIxMi44IDU3OC40IGwg
MjEwLjYgNTgwLjYgbCAyMTIuOCA1ODIuOSBsDQpoDQpmKg0KMCAwIDAgUkcNCjIxMi44IDU4
Mi45IG0NCjIxNSA1ODAuNiBsIDIxMi44IDU3OC40IGwgMjEwLjYgNTgwLjYgbCAyMTIuOCA1
ODIuOSBsDQpoDQpTDQoxIDEgMC41OTk5OSByZw0KMjQ0LjYgNTkyLjEgbQ0KMjQ2LjkgNTg5
LjggbCAyNDQuNiA1ODcuNiBsIDI0Mi40IDU4OS44IGwgMjQ0LjYgNTkyLjEgbA0KaA0KZioN
CjAgMCAwIFJHDQoyNDQuNiA1OTIuMSBtDQoyNDYuOSA1ODkuOCBsIDI0NC42IDU4Ny42IGwg
MjQyLjQgNTg5LjggbCAyNDQuNiA1OTIuMSBsDQpoDQpTDQoxIDEgMC41OTk5OSByZw0KMjc2
LjUgNjE1IG0NCjI3OC43IDYxMi44IGwgMjc2LjUgNjEwLjUgbCAyNzQuMiA2MTIuOCBsIDI3
Ni41IDYxNSBsDQpoDQpmKg0KMCAwIDAgUkcNCjI3Ni41IDYxNSBtDQoyNzguNyA2MTIuOCBs
IDI3Ni41IDYxMC41IGwgMjc0LjIgNjEyLjggbCAyNzYuNSA2MTUgbA0KaA0KUw0KMSAxIDAu
NTk5OTkgcmcNCjMwOC4zIDYzNy45IG0NCjMxMC41IDYzNS43IGwgMzA4LjMgNjMzLjUgbCAz
MDYuMSA2MzUuNyBsIDMwOC4zIDYzNy45IGwNCmgNCmYqDQowIDAgMCBSRw0KMzA4LjMgNjM3
LjkgbQ0KMzEwLjUgNjM1LjcgbCAzMDguMyA2MzMuNSBsIDMwNi4xIDYzNS43IGwgMzA4LjMg
NjM3LjkgbA0KaA0KUw0KMSAxIDAuNTk5OTkgcmcNCjM0MC4xIDY2MC45IG0NCjM0Mi40IDY1
OC42IGwgMzQwLjEgNjU2LjQgbCAzMzcuOSA2NTguNiBsIDM0MC4xIDY2MC45IGwNCmgNCmYq
DQowIDAgMCBSRw0KMzQwLjEgNjYwLjkgbQ0KMzQyLjQgNjU4LjYgbCAzNDAuMSA2NTYuNCBs
IDMzNy45IDY1OC42IGwgMzQwLjEgNjYwLjkgbA0KaA0KUw0KMSAxIDAuNTk5OTkgcmcNCjM3
MiA2ODMuOCBtDQozNzQuMiA2ODEuNiBsIDM3MiA2NzkuMyBsIDM2OS43IDY4MS42IGwgMzcy
IDY4My44IGwgaA0KZioNCjAgMCAwIFJHDQozNzIgNjgzLjggbQ0KMzc0LjIgNjgxLjYgbCAz
NzIgNjc5LjMgbCAzNjkuNyA2ODEuNiBsIDM3MiA2ODMuOCBsIGgNClMNCjAgMC41MDE5NiAw
IHJnDQoxNDguNSA0ODAgbQ0KMTgwLjMgNTQyIGwgMTgwLjMgNTQyIGwgMTgwLjQgNTQyLjEg
bCAxODEgNTQxLjcgbCAxODEuNiA1NDEuMyBsDQoxNDkuOCA0NzkuNCBsIDE0OC41IDQ4MCBs
IGgNCmYqDQoxODAuNCA1NDIuMSBtDQoyMTIuMiA1NzguOCBsIDIxMi4yIDU3OC44IGwgMjEy
LjMgNTc4LjkgbCAyMTIuNSA1NzkgbA0KMjEyLjggNTc4LjQgbCAyMTMuMyA1NzcuOSBsIDE4
MS41IDU0MS4yIGwgMTgxIDU0MS43IGwgMTgwLjQgNTQyLjEgbA0KaA0KZioNCjIxMi41IDU3
OSBtDQoyNDQuNCA1OTAuNSBsIDI0NC42IDU4OS44IGwgMjQ1IDU4OS4yIGwgMjQ1IDU4OS4y
IGwgMjQ0LjkgNTg5LjIgbA0KMjEzIDU3Ny43IGwgMjEyLjggNTc4LjQgbCAyMTIuNSA1Nzkg
bCBoDQpmKg0KMjQ0LjYgNTg5LjggbQ0KMjQ0LjIgNTkwLjQgbCAyNzYgNjEzLjQgbCAyNzYu
NSA2MTIuOCBsIDI3Ni45IDYxMi4yIGwNCjI0NSA1ODkuMiBsIDI0NC42IDU4OS44IGwgaA0K
ZioNCjI3Ni41IDYxMi44IG0NCjI3NiA2MTMuNCBsIDMwNy45IDYzNi4zIGwgMzA4LjMgNjM1
LjcgbCAzMDguNyA2MzUuMSBsDQoyNzYuOSA2MTIuMiBsIDI3Ni41IDYxMi44IGwgaA0KZioN
CjMwOC4zIDYzNS43IG0NCjMwNy45IDYzNi4zIGwgMzM5LjcgNjU5LjIgbCAzNDAuMSA2NTgu
NiBsIDM0MC41IDY1OC4xIGwNCjMwOC43IDYzNS4xIGwgMzA4LjMgNjM1LjcgbCBoDQpmKg0K
MzQwLjEgNjU4LjYgbQ0KMzM5LjcgNjU5LjIgbCAzNzEuNSA2ODIuMiBsIDM3Mi40IDY4MSBs
IDM0MC41IDY1OC4xIGwNCjM0MC4xIDY1OC42IGwgaA0KZioNCjE0Ni45IDQ4MS45IG0NCjE1
MS40IDQ4MS45IGwgMTQ5LjEgNDc3LjUgbCAxNDYuOSA0ODEuOSBsIGgNCmYqDQowIDAgMCBS
Rw0KMTQ2LjkgNDgxLjkgbQ0KMTUxLjQgNDgxLjkgbCAxNDkuMSA0NzcuNSBsIDE0Ni45IDQ4
MS45IGwgaA0KUw0KMCAwLjUwMTk2IDAgcmcNCjE3OC43IDU0My45IG0NCjE4My4yIDU0My45
IGwgMTgxIDUzOS40IGwgMTc4LjcgNTQzLjkgbCBoDQpmKg0KMCAwIDAgUkcNCjE3OC43IDU0
My45IG0NCjE4My4yIDU0My45IGwgMTgxIDUzOS40IGwgMTc4LjcgNTQzLjkgbCBoDQpTDQow
IDAuNTAxOTYgMCByZw0KMjEwLjYgNTgwLjYgbQ0KMjE1IDU4MC42IGwgMjEyLjggNTc2LjEg
bCAyMTAuNiA1ODAuNiBsIGgNCmYqDQowIDAgMCBSRw0KMjEwLjYgNTgwLjYgbQ0KMjE1IDU4
MC42IGwgMjEyLjggNTc2LjEgbCAyMTAuNiA1ODAuNiBsIGgNClMNCjAgMC41MDE5NiAwIHJn
DQoyNDIuNCA1OTIuMSBtDQoyNDYuOSA1OTIuMSBsIDI0NC42IDU4Ny42IGwgMjQyLjQgNTky
LjEgbCBoDQpmKg0KMCAwIDAgUkcNCjI0Mi40IDU5Mi4xIG0NCjI0Ni45IDU5Mi4xIGwgMjQ0
LjYgNTg3LjYgbCAyNDIuNCA1OTIuMSBsIGgNClMNCjAgMC41MDE5NiAwIHJnDQoyNzQuMiA2
MTUgbQ0KMjc4LjcgNjE1IGwgMjc2LjUgNjEwLjUgbCAyNzQuMiA2MTUgbCBoDQpmKg0KMCAw
IDAgUkcNCjI3NC4yIDYxNSBtDQoyNzguNyA2MTUgbCAyNzYuNSA2MTAuNSBsIDI3NC4yIDYx
NSBsIGgNClMNCjAgMC41MDE5NiAwIHJnDQozMDYuMSA2MzcuOSBtDQozMTAuNSA2MzcuOSBs
IDMwOC4zIDYzMy41IGwgMzA2LjEgNjM3LjkgbCBoDQpmKg0KMCAwIDAgUkcNCjMwNi4xIDYz
Ny45IG0NCjMxMC41IDYzNy45IGwgMzA4LjMgNjMzLjUgbCAzMDYuMSA2MzcuOSBsIGgNClMN
CjAgMC41MDE5NiAwIHJnDQozMzcuOSA2NjAuOSBtDQozNDIuNCA2NjAuOSBsIDM0MC4xIDY1
Ni40IGwgMzM3LjkgNjYwLjkgbCBoDQpmKg0KMCAwIDAgUkcNCjMzNy45IDY2MC45IG0NCjM0
Mi40IDY2MC45IGwgMzQwLjEgNjU2LjQgbCAzMzcuOSA2NjAuOSBsIGgNClMNCjAgMC41MDE5
NiAwIHJnDQozNjkuNyA2ODMuOCBtDQozNzQuMiA2ODMuOCBsIDM3MiA2NzkuMyBsIDM2OS43
IDY4My44IGwgaA0KZioNCjAgMCAwIFJHDQozNjkuNyA2ODMuOCBtDQozNzQuMiA2ODMuOCBs
IDM3MiA2NzkuMyBsIDM2OS43IDY4My44IGwgaA0KUw0KMC44IDAgMCByZw0KMTQ5LjEgNDc3
LjcgbQ0KMTgwLjkgNDc3LjUgbCAxODEgNDc2LjcgbCAxODEgNDc2IGwgMTQ5LjEgNDc2LjIg
bCAxNDkuMSA0NzcuNyBsDQpoDQpmKg0KMTgxIDQ3Ni43IG0NCjE4MC45IDQ3Ny41IGwgMjEy
LjggNDc3LjYgbCAyMTIuOCA0NzYuOCBsIDIxMi44IDQ3Ni4xIGwNCjE4MSA0NzYgbCAxODEg
NDc2LjcgbCBoDQpmKg0KMjEyLjggNDc2LjggbQ0KMjEyLjggNDc3LjYgbCAyNDQuNiA0Nzcu
NyBsIDI0NC42IDQ3NyBsIDI0NC42IDQ3Ni4yIGwNCjIxMi44IDQ3Ni4xIGwgMjEyLjggNDc2
LjggbCBoDQpmKg0KMjQ0LjYgNDc3IG0NCjI0NC42IDQ3Ny43IGwgMjc2LjUgNDc3LjcgbCAy
NzYuNSA0NzcgbCAyNzYuNSA0NzYuMiBsDQoyNDQuNiA0NzYuMiBsIDI0NC42IDQ3NyBsIGgN
CmYqDQoyNzYuNSA0NzcgbQ0KMjc2LjUgNDc3LjcgbCAzMDguMyA0NzcuNyBsIDMwOC4zIDQ3
NyBsIDMwOC4zIDQ3Ni4yIGwNCjI3Ni41IDQ3Ni4yIGwgMjc2LjUgNDc3IGwgaA0KZioNCjMw
OC4zIDQ3NyBtDQozMDguMyA0NzcuNyBsIDM0MC4xIDQ3Ny43IGwgMzQwLjEgNDc3IGwgMzQw
LjEgNDc2LjIgbA0KMzA4LjMgNDc2LjIgbCAzMDguMyA0NzcgbCBoDQpmKg0KMzQwLjEgNDc3
IG0NCjM0MC4xIDQ3Ny43IGwgMzcyIDQ3Ny4yIGwgMzcxLjkgNDc1LjggbCAzNDAuMSA0NzYu
MiBsDQozNDAuMSA0NzcgbCBoDQpmKg0KMTQ2LjkgNDc0LjcgbQ0KMTUxLjQgNDc0LjcgbCAx
NDkuMSA0NzkuMiBsIDE0Ni45IDQ3NC43IGwgaA0KZioNCjAgMCAwIFJHDQoxNDYuOSA0NzQu
NyBtDQoxNTEuNCA0NzQuNyBsIDE0OS4xIDQ3OS4yIGwgMTQ2LjkgNDc0LjcgbCBoDQpTDQow
LjggMCAwIHJnDQoxNzguNyA0NzQuNSBtDQoxODMuMiA0NzQuNSBsIDE4MSA0NzkgbCAxNzgu
NyA0NzQuNSBsIGgNCmYqDQowIDAgMCBSRw0KMTc4LjcgNDc0LjUgbQ0KMTgzLjIgNDc0LjUg
bCAxODEgNDc5IGwgMTc4LjcgNDc0LjUgbCBoDQpTDQowLjggMCAwIHJnDQoyMTAuNiA0NzQu
NiBtDQoyMTUgNDc0LjYgbCAyMTIuOCA0NzkuMSBsIDIxMC42IDQ3NC42IGwgaA0KZioNCjAg
MCAwIFJHDQoyMTAuNiA0NzQuNiBtDQoyMTUgNDc0LjYgbCAyMTIuOCA0NzkuMSBsIDIxMC42
IDQ3NC42IGwgaA0KUw0KMC44IDAgMCByZw0KMjQyLjQgNDc0LjcgbQ0KMjQ2LjkgNDc0Ljcg
bCAyNDQuNiA0NzkuMiBsIDI0Mi40IDQ3NC43IGwgaA0KZioNCjAgMCAwIFJHDQoyNDIuNCA0
NzQuNyBtDQoyNDYuOSA0NzQuNyBsIDI0NC42IDQ3OS4yIGwgMjQyLjQgNDc0LjcgbCBoDQpT
DQowLjggMCAwIHJnDQoyNzQuMiA0NzQuNyBtDQoyNzguNyA0NzQuNyBsIDI3Ni41IDQ3OS4y
IGwgMjc0LjIgNDc0LjcgbCBoDQpmKg0KMCAwIDAgUkcNCjI3NC4yIDQ3NC43IG0NCjI3OC43
IDQ3NC43IGwgMjc2LjUgNDc5LjIgbCAyNzQuMiA0NzQuNyBsIGgNClMNCjAuOCAwIDAgcmcN
CjMwNi4xIDQ3NC43IG0NCjMxMC41IDQ3NC43IGwgMzA4LjMgNDc5LjIgbCAzMDYuMSA0NzQu
NyBsIGgNCmYqDQowIDAgMCBSRw0KMzA2LjEgNDc0LjcgbQ0KMzEwLjUgNDc0LjcgbCAzMDgu
MyA0NzkuMiBsIDMwNi4xIDQ3NC43IGwgaA0KUw0KMC44IDAgMCByZw0KMzM3LjkgNDc0Ljcg
bQ0KMzQyLjQgNDc0LjcgbCAzNDAuMSA0NzkuMiBsIDMzNy45IDQ3NC43IGwgaA0KZioNCjAg
MCAwIFJHDQozMzcuOSA0NzQuNyBtDQozNDIuNCA0NzQuNyBsIDM0MC4xIDQ3OS4yIGwgMzM3
LjkgNDc0LjcgbCBoDQpTDQowLjggMCAwIHJnDQozNjkuNyA0NzQuMyBtDQozNzQuMiA0NzQu
MyBsIDM3MiA0NzguNyBsIDM2OS43IDQ3NC4zIGwgaA0KZioNCjAgMCAwIFJHDQozNjkuNyA0
NzQuMyBtDQozNzQuMiA0NzQuMyBsIDM3MiA0NzguNyBsIDM2OS43IDQ3NC4zIGwgaA0KUw0K
MC40IDAgMC40IHJnDQoxNDguNiA0ODAuMyBtDQoxODAuNSA1MDcuOCBsIDE4MC41IDUwNy44
IGwgMTgwLjYgNTA3LjkgbCAxODAuNyA1MDcuOSBsDQoxODAuOCA1MDggbCAxODAuOSA1MDgg
bCAxODEuMiA1MDggbCAxODEgNTA3LjMgbCAxODEuNCA1MDYuNyBsIDE0OS42IDQ3OS4yIGwN
CjE0OC42IDQ4MC4zIGwgaA0KZioNCjE4MS4yIDUwOCBtDQoyMTMgNDk4LjggbCAyMTIuOCA0
OTguMSBsIDIxMi43IDQ5Ny40IGwgMjEyLjcgNDk3LjQgbA0KMjEyLjYgNDk3LjQgbCAxODAu
NyA1MDYuNiBsIDE4MSA1MDcuMyBsIDE4MS4yIDUwOCBsIGgNCmYqDQoyMTIuOCA0OTguMSBt
DQoyMTIuOCA0OTguOCBsIDI0NC43IDQ5NyBsIDI0NC42IDQ5Ni4yIGwgMjQ0LjYgNDk1LjUg
bA0KMjEyLjcgNDk3LjQgbCAyMTIuOCA0OTguMSBsIGgNCmYqDQoyNDQuNiA0OTYuMiBtDQoy
NDQuNyA0OTcgbCAyNzYuNSA0OTUuMSBsIDI3Ni41IDQ5NC40IGwgMjc2LjQgNDkzLjcgbA0K
MjQ0LjYgNDk1LjUgbCAyNDQuNiA0OTYuMiBsIGgNCmYqDQoyNzYuNSA0OTQuNCBtDQoyNzYu
NSA0OTUuMSBsIDMwOC4zIDQ5My4zIGwgMzA4LjMgNDkyLjYgbCAzMDguMiA0OTEuOSBsDQoy
NzYuNCA0OTMuNyBsIDI3Ni41IDQ5NC40IGwgaA0KZioNCjMwOC4zIDQ5Mi42IG0NCjMwOC4z
IDQ5My4zIGwgMzQwLjIgNDkxLjUgbCAzNDAuMSA0OTAuNyBsIDM0MC4xIDQ5MCBsDQozMDgu
MiA0OTEuOSBsIDMwOC4zIDQ5Mi42IGwgaA0KZioNCjM0MC4xIDQ5MC43IG0NCjM0MC4yIDQ5
MS41IGwgMzcyIDQ4OS42IGwgMzcxLjkgNDg4LjIgbCAzNDAuMSA0OTAgbA0KMzQwLjEgNDkw
LjcgbCBoDQpmKg0KMTQ2LjkgNDgxLjkgbQ0KMTUxLjQgNDc5LjcgbCAxNDYuOSA0NzcuNSBs
IDE0Ni45IDQ4MS45IGwgaA0KZioNCjAgMCAwIFJHDQoxNDYuOSA0ODEuOSBtDQoxNTEuNCA0
NzkuNyBsIDE0Ni45IDQ3Ny41IGwgMTQ2LjkgNDgxLjkgbCBoDQpTDQowLjQgMCAwLjQgcmcN
CjE3OC43IDUwOS41IG0NCjE4My4yIDUwNy4zIGwgMTc4LjcgNTA1IGwgMTc4LjcgNTA5LjUg
bCBoDQpmKg0KMCAwIDAgUkcNCjE3OC43IDUwOS41IG0NCjE4My4yIDUwNy4zIGwgMTc4Ljcg
NTA1IGwgMTc4LjcgNTA5LjUgbCBoDQpTDQowLjQgMCAwLjQgcmcNCjIxMC42IDUwMC4zIG0N
CjIxNSA0OTguMSBsIDIxMC42IDQ5NS44IGwgMjEwLjYgNTAwLjMgbCBoDQpmKg0KMCAwIDAg
UkcNCjIxMC42IDUwMC4zIG0NCjIxNSA0OTguMSBsIDIxMC42IDQ5NS44IGwgMjEwLjYgNTAw
LjMgbCBoDQpTDQowLjQgMCAwLjQgcmcNCjI0Mi40IDQ5OC41IG0NCjI0Ni45IDQ5Ni4yIGwg
MjQyLjQgNDk0IGwgMjQyLjQgNDk4LjUgbCBoDQpmKg0KMCAwIDAgUkcNCjI0Mi40IDQ5OC41
IG0NCjI0Ni45IDQ5Ni4yIGwgMjQyLjQgNDk0IGwgMjQyLjQgNDk4LjUgbCBoDQpTDQowLjQg
MCAwLjQgcmcNCjI3NC4yIDQ5Ni42IG0NCjI3OC43IDQ5NC40IGwgMjc0LjIgNDkyLjEgbCAy
NzQuMiA0OTYuNiBsIGgNCmYqDQowIDAgMCBSRw0KMjc0LjIgNDk2LjYgbQ0KMjc4LjcgNDk0
LjQgbCAyNzQuMiA0OTIuMSBsIDI3NC4yIDQ5Ni42IGwgaA0KUw0KMC40IDAgMC40IHJnDQoz
MDYuMSA0OTQuOCBtDQozMTAuNSA0OTIuNiBsIDMwNi4xIDQ5MC4zIGwgMzA2LjEgNDk0Ljgg
bCBoDQpmKg0KMCAwIDAgUkcNCjMwNi4xIDQ5NC44IG0NCjMxMC41IDQ5Mi42IGwgMzA2LjEg
NDkwLjMgbCAzMDYuMSA0OTQuOCBsIGgNClMNCjAuNCAwIDAuNCByZw0KMzM3LjkgNDkzIG0N
CjM0Mi40IDQ5MC43IGwgMzM3LjkgNDg4LjUgbCAzMzcuOSA0OTMgbCBoDQpmKg0KMCAwIDAg
UkcNCjMzNy45IDQ5MyBtDQozNDIuNCA0OTAuNyBsIDMzNy45IDQ4OC41IGwgMzM3LjkgNDkz
IGwgaA0KUw0KMC40IDAgMC40IHJnDQozNjkuNyA0OTEuMSBtDQozNzQuMiA0ODguOSBsIDM2
OS43IDQ4Ni42IGwgMzY5LjcgNDkxLjEgbCBoDQpmKg0KMCAwIDAgUkcNCjM2OS43IDQ5MS4x
IG0NCjM3NC4yIDQ4OC45IGwgMzY5LjcgNDg2LjYgbCAzNjkuNyA0OTEuMSBsIGgNClMNCnEg
MCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAgMCAxIDE4MC41IDY5Ny4xIFRtDQovRjEgMTguOSBU
ZiA8MDg+IFRqDQoxLjAwMDE3IDAgMCAxIDE4NS42IDY5Ny4xIFRtDQo8MDk+IFRqDQoxLjAw
MDE3IDAgMCAxIDE5NC45IDY5Ny4xIFRtDQo8MEE+IFRqDQoxLjAwMDE3IDAgMCAxIDIwNC4x
IDY5Ny4xIFRtDQo8MEI+IFRqDQoxLjAwMDE3IDAgMCAxIDIxMy4zIDY5Ny4xIFRtDQo8MEM+
IFRqDQoxLjAwMDE3IDAgMCAxIDIxOC41IDY5Ny4xIFRtDQo8MEQ+IFRqDQoxLjAwMDE3IDAg
MCAxIDIyMy42IDY5Ny4xIFRtDQo8MEU+IFRqDQoxLjAwMDE3IDAgMCAxIDIyNy43IDY5Ny4x
IFRtDQo8MEYxMD4gVGoNCjEuMDAwMTcgMCAwIDEgMjUzLjQgNjk3LjEgVG0NCjwwQz4gVGoN
CjEuMDAwMTcgMCAwIDEgMjU4LjYgNjk3LjEgVG0NCjwxMT4gVGoNCjEuMDAwMTcgMCAwIDEg
MjY3LjggNjk3LjEgVG0NCjwwOT4gVGoNCjEuMDAwMTcgMCAwIDEgMjc3LjEgNjk3LjEgVG0N
CjwwMjBDPiBUag0KMS4wMDAxNyAwIDAgMSAyODcuNCA2OTcuMSBUbQ0KPDEyPiBUag0KMS4w
MDAxNyAwIDAgMSAyOTIuNSA2OTcuMSBUbQ0KPDEzPiBUag0KMS4wMDAxNyAwIDAgMSAzMDIu
OSA2OTcuMSBUbQ0KPDE0PiBUag0KMS4wMDAxNyAwIDAgMSAzMTMuMSA2OTcuMSBUbQ0KPDE1
PiBUag0KMS4wMDAxNyAwIDAgMSAzMjMuNCA2OTcuMSBUbQ0KPDEwPiBUag0KMS4wMDAxNyAw
IDAgMSAzMzMuNiA2OTcuMSBUbQ0KPDBDMTY+IFRqDQoxLjAwMDE3IDAgMCAxIDM1Mi4xIDY5
Ny4xIFRtDQo8MTQ+IFRqDQoxLjAwMDE3IDAgMCAxIDM2Mi40IDY5Ny4xIFRtDQo8MTc+IFRq
DQoxLjAwMDE3IDAgMCAxIDM3Mi42IDY5Ny4xIFRtDQo8MTM+IFRqDQoxLjAwMDE3IDAgMCAx
IDM4MyA2OTcuMSBUbQ0KPDBEPiBUag0KRVQNClENCjAuODUwOTggMC44NTA5OCAwLjg1MDk4
IHJnDQozOTYuNSA2MDguNCBtDQo0NzguNSA2MDguNCBsIDQ3OC41IDUzMi43IGwgMzk2LjUg
NTMyLjcgbCAzOTYuNSA2MDguNCBsDQpoDQpmKg0KMCAwIDAgUkcNCjQzNy41IDUzMi43IG0N
CjM5Ni41IDUzMi43IGwgMzk2LjUgNjA4LjQgbCA0NzguNSA2MDguNCBsIDQ3OC41IDUzMi43
IGwNCjQzNy41IDUzMi43IGwgaA0KUw0KMC41OTk5OSAwLjU5OTk5IDEgcmcNCjM5OS44IDYw
MS41IG0NCjM5OS44IDU5Ni41IGwgNDA0LjggNTk2LjUgbCA0MDQuOCA2MDEuNSBsIDM5OS44
IDYwMS41IGwNCmgNCmYqDQowIDAgMCBSRw0KMzk5LjggNjAxLjUgbQ0KMzk5LjggNTk2LjUg
bCA0MDQuOCA1OTYuNSBsIDQwNC44IDYwMS41IGwgMzk5LjggNjAxLjUgbA0KaA0KUw0KcSAw
IDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgNDEwLjYgNTk2IFRtDQovRjEgMTAgVGYgPDEw
PiBUag0KMS4wMDAxNyAwIDAgMSA0MTYuMiA1OTYgVG0NCjwxOD4gVGoNCjEuMDAwMTcgMCAw
IDEgNDIxLjIgNTk2IFRtDQo8MEQ+IFRqDQoxLjAwMDE3IDAgMCAxIDQyNCA1OTYgVG0NCjww
Nj4gVGoNCjEuMDAwMTcgMCAwIDEgNDI5LjYgNTk2IFRtDQo8MTk+IFRqDQoxLjAwMDE3IDAg
MCAxIDQzMi4zIDU5NiBUbQ0KPDBDMDE+IFRqDQoxLjAwMDE3IDAgMCAxIDQ0MC42IDU5NiBU
bQ0KPDBDPiBUag0KMS4wMDAxNyAwIDAgMSA0NDMuNCA1OTYgVG0NCjwwOD4gVGoNCjEuMDAw
MTcgMCAwIDEgNDQ2LjIgNTk2IFRtDQo8MEU+IFRqDQoxLjAwMDE3IDAgMCAxIDQ0OC41IDU5
NiBUbQ0KPDFBPiBUag0KMS4wMDAxNyAwIDAgMSA0NTAuNyA1OTYgVG0NCjwxMD4gVGoNCjEu
MDAwMTcgMCAwIDEgNDU2LjMgNTk2IFRtDQo8MDk+IFRqDQpFVA0KUQ0KMSAxIDAuNTk5OTkg
cmcNCjQwMi4zIDU4NyBtDQo0MDQuOCA1ODQuNSBsIDQwMi4zIDU4MiBsIDM5OS44IDU4NC41
IGwgNDAyLjMgNTg3IGwgaA0KZioNCjAgMCAwIFJHDQo0MDIuMyA1ODcgbQ0KNDA0LjggNTg0
LjUgbCA0MDIuMyA1ODIgbCAzOTkuOCA1ODQuNSBsIDQwMi4zIDU4NyBsIGgNClMNCnEgMCAw
IDAgcmcNCkJUDQoxLjAwMDE3IDAgMCAxIDQxMC42IDU4MS41IFRtDQovRjEgMTAgVGYgPDEw
PiBUag0KMS4wMDAxNyAwIDAgMSA0MTYuMiA1ODEuNSBUbQ0KPDE4PiBUag0KMS4wMDAxNyAw
IDAgMSA0MjEuMiA1ODEuNSBUbQ0KPDBEPiBUag0KMS4wMDAxNyAwIDAgMSA0MjQgNTgxLjUg
VG0NCjwwNj4gVGoNCjEuMDAwMTcgMCAwIDEgNDI5LjYgNTgxLjUgVG0NCjwwQz4gVGoNCjEu
MDAwMTcgMCAwIDEgNDMyLjMgNTgxLjUgVG0NCjwwND4gVGoNCjEuMDAwMTcgMCAwIDEgNDM3
LjkgNTgxLjUgVG0NCjwwMT4gVGoNCjEuMDAwMTcgMCAwIDEgNDQzLjUgNTgxLjUgVG0NCjww
MT4gVGoNCjEuMDAwMTcgMCAwIDEgNDQ5LjEgNTgxLjUgVG0NCjwwQj4gVGoNCjEuMDAwMTcg
MCAwIDEgNDU0IDU4MS41IFRtDQo8MEM+IFRqDQoxLjAwMDE3IDAgMCAxIDQ1Ni44IDU4MS41
IFRtDQo8MDg+IFRqDQoxLjAwMDE3IDAgMCAxIDQ1OS42IDU4MS41IFRtDQo8MEU+IFRqDQox
LjAwMDE3IDAgMCAxIDQ2MS44IDU4MS41IFRtDQo8MUE+IFRqDQoxLjAwMDE3IDAgMCAxIDQ2
NC4xIDU4MS41IFRtDQo8MTA+IFRqDQoxLjAwMDE3IDAgMCAxIDQ2OS42IDU4MS41IFRtDQo8
MDk+IFRqDQpFVA0KUQ0KMCAwLjUwMTk2IDAgcmcNCjM5OS44IDU3Mi41IG0NCjQwNC44IDU3
Mi41IGwgNDAyLjMgNTY3LjUgbCAzOTkuOCA1NzIuNSBsIGgNCmYqDQowIDAgMCBSRw0KMzk5
LjggNTcyLjUgbQ0KNDA0LjggNTcyLjUgbCA0MDIuMyA1NjcuNSBsIDM5OS44IDU3Mi41IGwg
aA0KUw0KcSAwIDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgNDEwLjYgNTY3IFRtDQovRjEg
MTAgVGYgPDEwPiBUag0KMS4wMDAxNyAwIDAgMSA0MTYuMiA1NjcgVG0NCjwxOD4gVGoNCjEu
MDAwMTcgMCAwIDEgNDIxLjIgNTY3IFRtDQo8MEQ+IFRqDQoxLjAwMDE3IDAgMCAxIDQyNCA1
NjcgVG0NCjwwNj4gVGoNCjEuMDAwMTcgMCAwIDEgNDI5LjYgNTY3IFRtDQo8MEM+IFRqDQox
LjAwMDE3IDAgMCAxIDQzMi4zIDU2NyBUbQ0KPDA1PiBUag0KMS4wMDAxNyAwIDAgMSA0Mzcu
OSA1NjcgVG0NCjwwMj4gVGoNCjEuMDAwMTcgMCAwIDEgNDQwLjYgNTY3IFRtDQo8MDQ+IFRq
DQoxLjAwMDE3IDAgMCAxIDQ0Ni4yIDU2NyBUbQ0KPDFCPiBUag0KMS4wMDAxNyAwIDAgMSA0
NTQuNSA1NjcgVG0NCjwwQz4gVGoNCjEuMDAwMTcgMCAwIDEgNDU3LjMgNTY3IFRtDQo8MDg+
IFRqDQoxLjAwMDE3IDAgMCAxIDQ2MC4xIDU2NyBUbQ0KPDBFPiBUag0KMS4wMDAxNyAwIDAg
MSA0NjIuMyA1NjcgVG0NCjwxQT4gVGoNCjEuMDAwMTcgMCAwIDEgNDY0LjUgNTY3IFRtDQo8
MTA+IFRqDQoxLjAwMDE3IDAgMCAxIDQ3MC4xIDU2NyBUbQ0KPDA5PiBUag0KRVQNClENCjAu
OCAwIDAgcmcNCjM5OS44IDU1MyBtDQo0MDQuOCA1NTMgbCA0MDIuMyA1NTggbCAzOTkuOCA1
NTMgbCBoDQpmKg0KMCAwIDAgUkcNCjM5OS44IDU1MyBtDQo0MDQuOCA1NTMgbCA0MDIuMyA1
NTggbCAzOTkuOCA1NTMgbCBoDQpTDQpxIDAgMCAwIHJnDQpCVA0KMS4wMDAxNyAwIDAgMSA0
MTAuNiA1NTIuNSBUbQ0KL0YxIDEwIFRmIDwxMD4gVGoNCjEuMDAwMTcgMCAwIDEgNDE2LjIg
NTUyLjUgVG0NCjwxOD4gVGoNCjEuMDAwMTcgMCAwIDEgNDIxLjIgNTUyLjUgVG0NCjwwRD4g
VGoNCjEuMDAwMTcgMCAwIDEgNDI0IDU1Mi41IFRtDQo8MDc+IFRqDQoxLjAwMDE3IDAgMCAx
IDQyOS42IDU1Mi41IFRtDQo8MEM+IFRqDQoxLjAwMDE3IDAgMCAxIDQzMi4zIDU1Mi41IFRt
DQo8MDQ+IFRqDQoxLjAwMDE3IDAgMCAxIDQzNy45IDU1Mi41IFRtDQo8MDE+IFRqDQoxLjAw
MDE3IDAgMCAxIDQ0My41IDU1Mi41IFRtDQo8MDE+IFRqDQoxLjAwMDE3IDAgMCAxIDQ0OS4x
IDU1Mi41IFRtDQo8MEI+IFRqDQoxLjAwMDE3IDAgMCAxIDQ1NCA1NTIuNSBUbQ0KPDA4PiBU
ag0KMS4wMDAxNyAwIDAgMSA0NTYuOSA1NTIuNSBUbQ0KPDBFMUE+IFRqDQoxLjAwMDE3IDAg
MCAxIDQ2MS4zIDU1Mi41IFRtDQo8MTA+IFRqDQoxLjAwMDE3IDAgMCAxIDQ2Ni45IDU1Mi41
IFRtDQo8MDk+IFRqDQpFVA0KUQ0KMC40IDAgMC40IHJnDQozOTkuOCA1NDMuNSBtDQo0MDQu
OCA1NDEgbCAzOTkuOCA1MzguNSBsIDM5OS44IDU0My41IGwgaA0KZioNCjAgMCAwIFJHDQoz
OTkuOCA1NDMuNSBtDQo0MDQuOCA1NDEgbCAzOTkuOCA1MzguNSBsIDM5OS44IDU0My41IGwg
aA0KUw0KcSAwIDAgMCByZw0KQlQNCjEuMDAwMTcgMCAwIDEgNDEwLjYgNTM4LjEgVG0NCi9G
MSAxMCBUZiA8MTA+IFRqDQoxLjAwMDE3IDAgMCAxIDQxNi4yIDUzOC4xIFRtDQo8MTg+IFRq
DQoxLjAwMDE3IDAgMCAxIDQyMS4yIDUzOC4xIFRtDQo8MEQ+IFRqDQoxLjAwMDE3IDAgMCAx
IDQyNCA1MzguMSBUbQ0KPDA3PiBUag0KMS4wMDAxNyAwIDAgMSA0MjkuNiA1MzguMSBUbQ0K
PDBDPiBUag0KMS4wMDAxNyAwIDAgMSA0MzIuMyA1MzguMSBUbQ0KPDA1PiBUag0KMS4wMDAx
NyAwIDAgMSA0MzcuOSA1MzguMSBUbQ0KPDAyPiBUag0KMS4wMDAxNyAwIDAgMSA0NDAuNiA1
MzguMSBUbQ0KPDA0PiBUag0KMS4wMDAxNyAwIDAgMSA0NDYuMiA1MzguMSBUbQ0KPDFCPiBU
ag0KMS4wMDAxNyAwIDAgMSA0NTQuNSA1MzguMSBUbQ0KPDBDPiBUag0KMS4wMDAxNyAwIDAg
MSA0NTcuMyA1MzguMSBUbQ0KPDA4PiBUag0KMS4wMDAxNyAwIDAgMSA0NjAuMSA1MzguMSBU
bQ0KPDBFPiBUag0KMS4wMDAxNyAwIDAgMSA0NjIuMyA1MzguMSBUbQ0KPDFBPiBUag0KMS4w
MDAxNyAwIDAgMSA0NjQuNSA1MzguMSBUbQ0KPDEwPiBUag0KMS4wMDAxNyAwIDAgMSA0NzAu
MSA1MzguMSBUbQ0KPDA5PiBUag0KRVQNClENCnEgMCAwIDAgcmcNCkJUDQoxLjAwMDE3IDAg
MCAxIDE4MCA0NDAuMyBUbQ0KL0YxIDEzIFRmIDwxQz4gVGoNCjEuMDAwMTcgMCAwIDEgMTg3
LjcgNDQwLjMgVG0NCjwxND4gVGoNCjEuMDAwMTcgMCAwIDEgMTk0LjkgNDQwLjMgVG0NCjww
RD4gVGoNCjEuMDAwMTcgMCAwIDEgMTk4LjQgNDQwLjMgVG0NCjwxRD4gVGoNCjEuMDAwMTcg
MCAwIDEgMjA1LjUgNDQwLjMgVG0NCjwxQT4gVGoNCjEuMDAwMTcgMCAwIDEgMjA4LjQgNDQw
LjMgVG0NCjwwQz4gVGoNCjEuMDAwMTcgMCAwIDEgMjExLjkgNDQwLjMgVG0NCjwxMj4gVGoN
CjEuMDAwMTcgMCAwIDEgMjE1LjUgNDQwLjMgVG0NCjwxMz4gVGoNCjEuMDAwMTcgMCAwIDEg
MjIyLjUgNDQwLjMgVG0NCjwxND4gVGoNCjEuMDAwMTcgMCAwIDEgMjI5LjcgNDQwLjMgVG0N
CjwxNT4gVGoNCjEuMDAwMTcgMCAwIDEgMjM2LjggNDQwLjMgVG0NCjwxMD4gVGoNCjEuMDAw
MTcgMCAwIDEgMjQzLjkgNDQwLjMgVG0NCjwwQz4gVGoNCjEuMDAwMTcgMCAwIDEgMjQ3LjUg
NDQwLjMgVG0NCjwxNj4gVGoNCjEuMDAwMTcgMCAwIDEgMjU2LjcgNDQwLjMgVG0NCjwxND4g
VGoNCjEuMDAwMTcgMCAwIDEgMjYzLjkgNDQwLjMgVG0NCjwxNz4gVGoNCjEuMDAwMTcgMCAw
IDEgMjcxIDQ0MC4zIFRtDQo8MTM+IFRqDQoxLjAwMDE3IDAgMCAxIDI3OC4xIDQ0MC4zIFRt
DQo8MEQ+IFRqDQoxLjAwMDE3IDAgMCAxIDI4MS43IDQ0MC4zIFRtDQo8MEM+IFRqDQoxLjAw
MDE3IDAgMCAxIDI4NS4yIDQ0MC4zIFRtDQo8MUU+IFRqDQoxLjAwMDE3IDAgMCAxIDI4OS40
IDQ0MC4zIFRtDQo8MEY+IFRqDQoxLjAwMDE3IDAgMCAxIDI5OS45IDQ0MC4zIFRtDQo8MEU+
IFRqDQoxLjAwMDE3IDAgMCAxIDMwMi44IDQ0MC4zIFRtDQo8MUE+IFRqDQoxLjAwMDE3IDAg
MCAxIDMwNS42IDQ0MC4zIFRtDQo8MUEwRT4gVGoNCjEuMDAwMTcgMCAwIDEgMzExLjMgNDQw
LjMgVG0NCjwxND4gVGoNCjEuMDAwMTcgMCAwIDEgMzE4LjUgNDQwLjMgVG0NCjwxMz4gVGoN
CjEuMDAwMTcgMCAwIDEgMzI1LjYgNDQwLjMgVG0NCjwwOT4gVGoNCjEuMDAwMTcgMCAwIDEg
MzMxLjkgNDQwLjMgVG0NCjwxRj4gVGoNCkVUDQpRDQpxIDAgMCAwIHJnDQpCVA0KMCAxLjAw
MDE3IC0xIDAgMTA5LjUgNTM2LjIgVG0NCi9GMSAxMyBUZiA8MDg+IFRqDQowIDEuMDAwMTcg
LTEgMCAxMDkuNSA1MzkuOCBUbQ0KPDA5PiBUag0KMCAxLjAwMDE3IC0xIDAgMTA5LjUgNTQ2
LjEgVG0NCjwwQT4gVGoNCjAgMS4wMDAxNyAtMSAwIDEwOS41IDU1Mi42IFRtDQo8MEI+IFRq
DQowIDEuMDAwMTcgLTEgMCAxMDkuNSA1NTguOSBUbQ0KPDBDPiBUag0KMCAxLjAwMDE3IC0x
IDAgMTA5LjUgNTYyLjUgVG0NCjwwRD4gVGoNCjAgMS4wMDAxNyAtMSAwIDEwOS41IDU2NiBU
bQ0KPDBFPiBUag0KMCAxLjAwMDE3IC0xIDAgMTA5LjUgNTY4LjggVG0NCjwwRj4gVGoNCjAg
MS4wMDAxNyAtMSAwIDEwOS41IDU3OS40IFRtDQo8MTA+IFRqDQowIDEuMDAwMTcgLTEgMCAx
MDkuNSA1ODYuNiBUbQ0KPDBDPiBUag0KMCAxLjAwMDE3IC0xIDAgMTA5LjUgNTkwLjEgVG0N
CjwxRT4gVGoNCjAgMS4wMDAxNyAtMSAwIDEwOS41IDU5NC4zIFRtDQo8MDk+IFRqDQowIDEu
MDAwMTcgLTEgMCAxMDkuNSA2MDAuNiBUbQ0KPDEwPiBUag0KMCAxLjAwMDE3IC0xIDAgMTA5
LjUgNjA3LjggVG0NCjwwQT4gVGoNCjAgMS4wMDAxNyAtMSAwIDEwOS41IDYxNC4yIFRtDQo8
MUY+IFRqDQpFVA0KUQ0KUSBlbmRzdHJlYW0KZW5kb2JqCjYgMCBvYmoKPDwKL0NyZWF0b3Ig
PGZlZmYwMDU3MDA3MjAwNjkwMDc0MDA2NTAwNzI+Ci9Qcm9kdWNlciA8ZmVmZjAwNGYwMDcw
MDA2NTAwNmUwMDRmMDA2NjAwNjYwMDY5MDA2MzAwNjUwMDJlMDA2ZjAwNzIwMDY3MDAyMDAw
MzEwMDJlMDAzMTAwMmUwMDMyPgovQ3JlYXRpb25EYXRlIChEOjIwMDcwNDE2MTQyOTU0LTA3
JzAwJykKPj4KZW5kb2JqCjcgMCBvYmoKPDwKL1R5cGUgL0ZvbnQKL1N1YnR5cGUgL1RydWVU
eXBlCi9CYXNlRm9udCAvQkFBQUFBIzJCQWxiYW55QU1UCi9GaXJzdENoYXIgMAovTGFzdENo
YXIgMzEKL1dpZHRocyBbIDc1MCA1NTYgMjc3IDU1NiA1NTYgNTU2IDU1NiA1NTYgMjc3IDUw
MCA1MDAgNTAwIDI3NyAyNzcgMjIyIDgzMyA1NTYgNTAwIDI3NyA1NTYgNTU2IDU1NiA3MjIg
NTU2IDUwMCAyNzcgMjIyIDgzMyA2MTAgNTU2IDMzMyAzMzNdCi9Gb250RGVzY3JpcHRvciA5
IDAgUgovVG9Vbmljb2RlIDEwIDAgUgo+PgplbmRvYmoKOCAwIG9iagoyMDE2OAplbmRvYmoK
OSAwIG9iago8PAovVHlwZSAvRm9udERlc2NyaXB0b3IKL0ZvbnROYW1lIC9CQUFBQUEjMkJB
bGJhbnlBTVQKL0ZsYWdzIDQKL0ZvbnRCQm94IFsgLTIyMiAtMzA2IDEwNzIgMTAzN10KL0l0
YWxpY0FuZ2xlIDAKL0FzY2VudCA5MDUKL0Rlc2NlbnQgLTIxMQovQ2FwSGVpZ2h0IDEwMzcK
L1N0ZW1WIDgwCi9Gb250RmlsZTIgMTEgMCBSCj4+CmVuZG9iagoxMCAwIG9iago8PAovTGVu
Z3RoIDM2OQovRmlsdGVyIC9GbGF0ZURlY29kZQo+PgpzdHJlYW0KeJxdkk1ugzAQRvdI3MHL
dBGBgUAiIaSEBIlFf1TaAxAzpEjFWIYscvvCfElVdYP17JnxPDxeXh5L3U3Ce7ODqmgSbacb
S+NwtYrEmS6ddh0ZiKZT0wN5UX1tXMeb86vbOFFf6nYQaeo6Qnjvc8A42ZtY7ZvhTE+8+Wob
sp2+iNVnXmGruhrzTT3pSfiuk2WioXap+Vybl7on4XH6umzmiG66refEPyEfN0MiwIZEb2po
aDS1IlvrC7lO6vuZSIsicx3Szf/T8J51btVXbZdoOUf7fuhnCwQMwYkhxMmGIQJIhg0gYIgB
IUMCiBi2DHHMsGNIELbHCeAAODDk6ADtHJGDaieE7RgKwHEB6QO4UQmfhC+V8Ik4R8InZjkJ
n7hggE/M90j4RNybhE+C0vBJtgzwCfcMd5+cAT4ReoPPBqXhE/NPlPAJUA0+wQ6v9nid5QF5
5n7HQ12tnSeDR5MnYpmFTtPv+JrBcN798wNnbbd+ZW5kc3RyZWFtCmVuZG9iagoxMSAwIG9i
ago8PAovTGVuZ3RoIDEyIDAgUgovRmlsdGVyIC9GbGF0ZURlY29kZQovTGVuZ3RoMSAyMTM4
MAo+PgpzdHJlYW0KeJztfAt4VEWWcJ26j+7bz9uvdJIGcpOGgDaSmIZAJJo7kCCYRSMGJlFD
EkhCwishCSgqEsWIEJngIyLijqzDur42NOowQXSJM4ivcWBHhx3XHWFER11lhn/WdXSAzn+q
7u0mCcGZf/bb/b5/v+mm7q17zqlTp06dc+pU3Q7travriYN0EIHoi1fUtnSt2tRBCPkpIeBd
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
tnJ9a3r7an9g1JKleGlowkt9oz+UUb++sbvxscbDjcca5dzG6saWxgON/Y3SgYZYU3+TUN/Y
uSo9rS3llplpmWuxUPqznwqRV/qFSH+nENEPWqwF3R/D7o8PfEy3/hhaPtz9If3VASGyb6Bf
+P1zNltBn/D5cz1CpE/4d34b6H8+ljq6gP2kMGU3VmK7aWR3Z2rG9h1yZEePFHnwPoYa7ZoU
vv8+KXLfA1LkgR45sq2HRpp71vd09wi7e4Dx/j8G79/qub8WI/q/+VIKDrxMI/+EZffL0L/n
yB66B7nu7oTI9zrlyBYsm7rkSBfemQgdkQgXYVJHhlbQsZ5G7ryDRu5YL0fWYVmPRPdg2Yjl
LiwbsJR1wtZO3vFn+jNWa0FoaiA1PxCYEvBODrijAUdeQLk0IOcGhJwAmRTIHu+aMN59ccQ1
MeLOCrvGht1jMlxahtutehzsPzRkf8wqiJKDAHUQwRrpJo8Ryn7C1Cw8JhwWpCJ3tXu9+zH3
Afcx9+/cA26r4naDNQSjnamWdGdADTq9ot85sfDiwgmF2YVjC7MKtcIxhaHC1MJAobfQXagU
yoVCISksi0LMW0pKy2fEfID362bEopHSPkGbF8uLlMYsZTdU7AH4XiVCY/SePiDlMfGePoo3
78zrb6jogzSG7gztIwAkVlrTuaVyDyUzYnBPLHxdBbvp11bEtHv6VFJesYfCjMrKytjU0rIK
RlUZGR2rY/8NRMfoylgeq2wdXUlKY5ddGwuFZ0RG+ixsW9jW1jYYsmdCdkns4pLa2MSSmuIh
tNDWfl77dqMtGY6CCLLlsJkVoUpWIpFYaiyMCsFGZiuzY35t26MwBZXNm1Eas87DUnZDLD2M
D6/jQz4+OMIz0C//L63qAEJlbmRzdHJlYW0KZW5kb2JqCjEyIDAgb2JqCjEwOTEzCmVuZG9i
agoyIDAgb2JqIDw8Ci9YT2JqZWN0IDw8IC9JbTEgMSAwIFIgPj4KL1Byb2NTZXQgWyAvUERG
IF0KPj4gZW5kb2JqCjUgMCBvYmogPDwKL1R5cGUgL1BhZ2VzCi9Db3VudCAxCi9LaWRzIFsz
IDAgUl0KPj4gZW5kb2JqCjEzIDAgb2JqIDw8Ci9UeXBlIC9DYXRhbG9nCi9QYWdlcyA1IDAg
UgovUFRFWC5GdWxsYmFubmVyIChUaGlzIGlzIHBkZlRlWCwgVmVyc2lvbiAzLjE0MTU5LTEu
MTBiKQo+PiBlbmRvYmoKMTQgMCBvYmogPDwKL1Byb2R1Y2VyIChwZGZUZVgtMS4xMGIpCi9D
cmVhdG9yIChUZVgpCi9DcmVhdGlvbkRhdGUgKEQ6MjAwNzA0MTYxNDMwMDApCj4+IGVuZG9i
agp4cmVmCjAgMTUKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMjI5IDAwMDAwIG4gCjAw
MDAwMzI4MzQgMDAwMDAgbiAKMDAwMDAwMDEyNSAwMDAwMCBuIAowMDAwMDAwMDA5IDAwMDAw
IG4gCjAwMDAwMzI4OTkgMDAwMDAgbiAKMDAwMDAyMDY2MiAwMDAwMCBuIAowMDAwMDIwODYw
IDAwMDAwIG4gCjAwMDAwMjExNDcgMDAwMDAgbiAKMDAwMDAyMTE2OCAwMDAwMCBuIAowMDAw
MDIxMzY4IDAwMDAwIG4gCjAwMDAwMjE4MDkgMDAwMDAgbiAKMDAwMDAzMjgxMiAwMDAwMCBu
IAowMDAwMDMyOTU2IDAwMDAwIG4gCjAwMDAwMzMwNjMgMDAwMDAgbiAKdHJhaWxlcgo8PAov
U2l6ZSAxNQovUm9vdCAxMyAwIFIKL0luZm8gMTQgMCBSCj4+CnN0YXJ0eHJlZgozMzE1OAol
JUVPRgo=
--------------070303030607010604040607--
