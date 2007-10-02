From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Tue, 02 Oct 2007 23:40:45 +0530
Message-ID: <470289A5.40706@linux.vnet.ibm.com>
References: <47017053.9060005@linux.vnet.ibm.com> <47020E59.1070609@bull.net> <20071002141238.GK5702@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Valerie Clement <valerie.clement@bull.net>,
	Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41685 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbXJBSKt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 14:10:49 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id l92IAwEi008062
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 04:10:58 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l92IELaM169468
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 04:14:21 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l92IAlHH031115
	for <linux-ext4@vger.kernel.org>; Wed, 3 Oct 2007 04:10:47 +1000
In-Reply-To: <20071002141238.GK5702@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Andreas Dilger wrote:
> On Oct 02, 2007  11:24 +0200, Valerie Clement wrote:
>> Currently, the mballoc feature is not compatible with the uninit_groups 
>> feature. I have just tried a simple test which failed. Isn't this a problem?
> 
> I thought Avantika posted the incremental patch to ext4 mballoc to work
> with the uninit groups patch?  This is what we have in our ext3 patch:
> 
> 
>

This is what i have right now. The  balloc.c and group.h changes should actually
go in uninitialized block group patch. This patch is slightly different from the
one posted by Andreas. Here instead of adding ext4_block_group descriptor again
to ext4_group_info i am explicitly calling ext4_get_group_desc. 

-aneesh


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 321ad1e..a8aebf2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -106,6 +106,16 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		for (bit = (ext4_inode_table(sb, gdp) - start),
 		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
+
+		/*
+		 * Also if the number of blocks within the group is less than the
+		 * blocksize * 8 ( which is the size of bitmap ), set rest of the
+		 * block bitmap to 1
+		 */
+		for (bit = EXT4_BLOCKS_PER_GROUP(sb);
+					bit < sb->s_blocksize * 8; bit++) {
+			ext4_set_bit(bit, bh->b_data);
+		}
 	}
 
 	return free_blocks - sbi->s_itb_per_group - 2;
diff --git a/fs/ext4/group.h b/fs/ext4/group.h
index 9310979..5165311 100644
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5ffc80b..28ad4fc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/version.h>
+#include "group.h"
 
 /*
  * MUSTDO:
@@ -893,6 +894,14 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			continue;
 		}
 
+		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+
+			ext4_init_block_bitmap(sb, bh[i],
+						first_group + i, desc);
+			set_buffer_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
@@ -1702,11 +1711,10 @@ static void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
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
@@ -1721,6 +1729,11 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
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
@@ -1805,6 +1818,7 @@ repeat:
 		ac->ac_criteria = cr;
 		for (i = 0; i < EXT4_SB(sb)->s_groups_count; group++, i++) {
 			struct ext4_group_info *grp;
+			struct ext4_group_desc *desc;
 
 			if (group == EXT4_SB(sb)->s_groups_count)
 				group = 0;
@@ -1844,12 +1858,16 @@ repeat:
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
@@ -2267,11 +2285,8 @@ static void ext4_mb_store_history(struct ext4_allocation_context *ac)
 
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
@@ -2321,7 +2336,7 @@ static int ext4_mb_init_backend(struct super_block *sb)
 			sbi->s_group_info[i >> EXT4_DESC_PER_BLOCK_BITS(sb)];
 		j = i & (EXT4_DESC_PER_BLOCK(sb) - 1);
 
-		meta_group_info[j] = kmalloc(len, GFP_KERNEL);
+		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
 		if (meta_group_info[j] == NULL) {
 			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
 			i--;
@@ -2333,7 +2348,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 				"EXT4-fs: can't read descriptor %u\n", i);
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
@@ -2919,9 +2933,17 @@ static int ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
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
 
@@ -4066,7 +4088,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 #if 0
 		static int ext4_mballoc_warning = 0;
 		if (ext4_mballoc_warning++ == 0)
-			printk(KERN_ERR "EXT3-fs: multiblock request with "
+			printk(KERN_ERR "EXT4-fs: multiblock request with "
 					"mballoc disabled!\n");
 		ar->len = 1;
 #endif
@@ -4353,6 +4375,7 @@ do_more:
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) + count);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
