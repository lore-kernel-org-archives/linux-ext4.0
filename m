From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: update uninitialized-block-groups.patch and mballoc-core.patch
Date: Wed, 03 Oct 2007 15:30:18 +0530
Message-ID: <47036832.7030107@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:57376 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXJCKAz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Oct 2007 06:00:55 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l93A0qdd013433
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:00:52 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l93A4R1D243170
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:04:27 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l93A0aCV001343
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 20:00:36 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This contain fixes for making mballoc work with uninitialized block group. 

The patches can be downloaded from 

http://www.radian.org/~kvaneesh/ext4/oct-3-2007/

The diff is attached below to find out what changed.

Mingming,

Can you replace the patch in the patch queue with the above two patches ?
-aneesh

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 321ad1e..47f70a8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -90,8 +90,19 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 			bit_max += 1;
 	}
 
-	/* Last and first groups are always initialized */
-	free_blocks = EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
+	if (block_group == sbi->s_gdb_count - 1) {
+		/*
+		 * Even though mke2fs always initialize first and last group
+		 * if some other tool enabled the EXT4_BG_BLOCK_UNINIT we need
+		 * to make sure we calculate the right free blocks
+		 */
+		free_blocks = ext4_blocks_count(sbi->s_es) -
+				le32_to_cpu(sbi->s_es->s_first_data_block) -
+				(EXT4_BLOCKS_PER_GROUP(sb) * sbi->s_groups_count) -
+				bit_max;
+	} else {
+		free_blocks = EXT4_BLOCKS_PER_GROUP(sb) - bit_max;
+	}
 
 	if (bh) {
 		for (bit = 0; bit < bit_max; bit++)
@@ -106,11 +117,20 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		for (bit = (ext4_inode_table(sb, gdp) - start),
 		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
+
+		/*
+		 * Also if the number of blocks within the group is less than the
+		 * blocksize * 8 ( which is the size of bitmap ), set rest of the
+		 * block bitmap to 1
+		 */
+		mark_bitmap_end(EXT4_BLOCKS_PER_GROUP(sb),
+					sb->s_blocksize * 8, bh->b_data);
 	}
 
 	return free_blocks - sbi->s_itb_per_group - 2;
 }
 
+
 /*
  * The free blocks are managed by bitmaps.  A file system contains several
  * blocks groups.  Each group contains 1 bitmap block for blocks, 1 bitmap
diff --git a/fs/ext4/group.h b/fs/ext4/group.h
index 9310979..1577910 100644
--- a/fs/ext4/group.h
+++ b/fs/ext4/group.h
@@ -8,9 +8,6 @@
 
 #ifndef _LINUX_EXT4_GROUP_H
 #define _LINUX_EXT4_GROUP_H
-#if defined(CONFIG_CRC16)
-#include <linux/crc16.h>
-#endif
 
 extern __le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 group,
 				   struct ext4_group_desc *gdp);
@@ -26,4 +23,5 @@ extern unsigned ext4_init_block_bitmap(struct super_block *sb,
 extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       struct buffer_head *bh, int group,
 				       struct ext4_group_desc *desc);
+extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
 #endif /* _LINUX_EXT4_GROUP_H */
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 1fa418c..e4c421e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -49,7 +49,7 @@
  * need to use it within a single byte (to ensure we get endianness right).
  * We can use memset for the rest of the bitmap as there are no other users.
  */
-static void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
+void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 {
 	int i;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5ffc80b..4409c0c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/version.h>
+#include "group.h"
 
 /*
  * MUSTDO:
@@ -893,6 +894,13 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			continue;
 		}
 
+		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+			ext4_init_block_bitmap(sb, bh[i],
+						first_group + i, desc);
+			set_buffer_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
@@ -1702,11 +1710,10 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
 static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 				int group, int cr)
 {
+	unsigned free, fragments;
+	unsigned i, bits;
+	struct ext4_group_desc *desc;
 	struct ext4_group_info *grp = EXT4_GROUP_INFO(ac->ac_sb, group);
-	unsigned free;
-	unsigned fragments;
-	unsigned i;
-	unsigned bits;
 
 	BUG_ON(cr < 0 || cr >= 4);
 	BUG_ON(EXT4_MB_GRP_NEED_INIT(grp));
@@ -1721,6 +1728,11 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	switch (cr) {
 	case 0:
 		BUG_ON(ac->ac_2order == 0);
+		/* If this group is uninitialized, skip it initially */
+		desc = ext4_get_group_desc(ac->ac_sb, group, NULL);
+		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
+			return 0;
+
 		bits = ac->ac_sb->s_blocksize_bits + 1;
 		for (i = ac->ac_2order; i <= bits; i++)
 			if (grp->bb_counters[i] > 0)
@@ -1805,6 +1817,7 @@ repeat:
 		ac->ac_criteria = cr;
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
+			struct ext4_group_desc *desc;
 
 			if (group == EXT4_SB(sb)->s_groups_count)
 				group = 0;
@@ -1844,12 +1857,16 @@ repeat:
 			}
 
 			ac->ac_groups_scanned++;
-			if (cr == 0)
+			desc = ext4_get_group_desc(sb, group, NULL);
+			if (cr == 0 || (desc->bg_flags &
+					cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
+					ac->ac_2order != 0)) {
 				ext4_mb_simple_scan_group(ac, &e4b);
-			else if (cr == 1 && ac->ac_g_ex.fe_len == sbi->s_stripe)
+			} else if (cr == 1 && ac->ac_g_ex.fe_len == sbi->s_stripe) {
 				ext4_mb_scan_aligned(ac, &e4b);
-			else
+			} else {
 				ext4_mb_complex_scan_group(ac, &e4b);
+			}
 
 			ext4_unlock_group(sb, group);
 			ext4_mb_release_desc(&e4b);
@@ -2267,11 +2284,8 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 
 static int ext4_mb_init_backend(struct super_block *sb)
 {
+	int i, j, len, metalen;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int i;
-	int j;
-	int len;
-	int metalen;
 	int num_meta_group_infos =
 		(sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) >>
 			EXT4_DESC_PER_BLOCK_BITS(sb);
@@ -2321,7 +2335,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 			sbi->s_group_info[i >> EXT4_DESC_PER_BLOCK_BITS(sb)];
 		j = i & (EXT4_DESC_PER_BLOCK(sb) - 1);
 
-		meta_group_info[j] = kmalloc(len, GFP_KERNEL);
+		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
 			i--;
@@ -2333,14 +2347,20 @@ static int ext4_mb_init_backend(struct super_block *sb)
 				"EXT4-fs: can't read descriptor %u\n", i);
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
-		/* initialize bb_free to be able to skip
-		 * empty groups without initialization */
-		meta_group_info[j]->bb_free =
-			le16_to_cpu(desc->bg_free_blocks_count);
+		/*
+		 * initialize bb_free to be able to skip
+		 * empty groups without initialization
+		 */
+		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+			meta_group_info[j]->bb_free =
+				ext4_free_blocks_after_init(sb, i, desc);
+		} else {
+			meta_group_info[j]->bb_free =
+				le16_to_cpu(desc->bg_free_blocks_count);
+		}
 
 		INIT_LIST_HEAD(&meta_group_info[j]->bb_prealloc_list);
 
@@ -2919,9 +2939,17 @@ static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 		    ac->ac_b_ex.fe_len);
 
 	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
+		gdp->bg_free_blocks_count =
+			cpu_to_le16(ext4_free_blocks_after_init(sb,
+						ac->ac_b_ex.fe_group,
+						gdp));
+	}
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)
 				- ac->ac_b_ex.fe_len);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
 
@@ -4066,7 +4094,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 #if 0
 		static int ext4_mballoc_warning = 0;
 		if (ext4_mballoc_warning++ == 0)
-			printk(KERN_ERR "EXT3-fs: multiblock request with "
+			printk(KERN_ERR "EXT4-fs: multiblock request with "
 					"mballoc disabled!\n");
 		ar->len = 1;
 #endif
@@ -4353,6 +4381,7 @@ do_more:
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) + count);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3359450..19ff743 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -141,25 +141,6 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 }
 
 /*
- * To avoid calling the atomic setbit hundreds or thousands of times, we only
- * need to use it within a single byte (to ensure we get endianness right).
- * We can use memset for the rest of the bitmap as there are no other users.
- */
-static void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
-{
-	int i;
-
-	if (start_bit >= end_bit)
-		return;
-
-	ext4_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
-	for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
-		ext4_set_bit(i, bitmap);
-	if (i < end_bit)
-		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
-}
-
-/*
  * Set up the block and inode bitmaps, and the inode table for the new group.
  * This doesn't need to be part of the main transaction, since we are only
  * changing blocks outside the actual filesystem.  We still do journaling to
