From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (October 1, 2007)
Date: Tue, 2 Oct 2007 08:12:38 -0600
Message-ID: <20071002141238.GK5702@schatzie.adilger.int>
References: <47017053.9060005@linux.vnet.ibm.com> <47020E59.1070609@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:50014 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbXJBOMk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 10:12:40 -0400
Content-Disposition: inline
In-Reply-To: <47020E59.1070609@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 02, 2007  11:24 +0200, Valerie Clement wrote:
> Currently, the mballoc feature is not compatible with the uninit_groups 
> feature. I have just tried a simple test which failed. Isn't this a problem?

I thought Avantika posted the incremental patch to ext4 mballoc to work
with the uninit groups patch?  This is what we have in our ext3 patch:


Index: linux-rhel5/fs/ext3/mballoc.c
===================================================================
--- linux-rhel5.orig/fs/ext3/mballoc.c	2007-07-18 17:32:04.000000000 +0200
+++ linux-rhel5/fs/ext3/mballoc.c	2007-07-18 17:32:15.000000000 +0200
@@ -36,6 +36,8 @@
 #include <linux/seq_file.h>
 #include <linux/version.h>
 
+#include "group.h"
+
 /*
  * MUSTDO:
  *   - test ext3_ext_search_left() and ext3_ext_search_right()
@@ -323,6 +325,7 @@ struct ext3_group_info {
 	unsigned long	bb_state;
 	unsigned long 	bb_tid;
 	struct ext3_free_metadata *bb_md_cur;
+	struct ext3_group_desc *bb_gdp;
 	unsigned short	bb_first_free;
 	unsigned short	bb_free;
 	unsigned short	bb_fragments;
@@ -943,10 +946,7 @@ static int ext3_mb_init_cache(struct pag
 		if (first_group + i >= EXT3_SB(sb)->s_groups_count)
 			break;
 
-		err = -EIO;
-		desc = ext3_get_group_desc(sb, first_group + i, NULL);
-		if (desc == NULL)
-			goto out;
+		desc = EXT3_GROUP_INFO(sb, first_group + i)->bb_gdp;
 
 		err = -ENOMEM;
 		bh[i] = sb_getblk(sb, le32_to_cpu(desc->bg_block_bitmap));
@@ -961,7 +961,12 @@ static int ext3_mb_init_cache(struct pag
 			unlock_buffer(bh[i]);
 			continue;
 		}
-
+		if (desc->bg_flags & cpu_to_le16(EXT3_BG_BLOCK_UNINIT)) {
+			ext3_init_block_bitmap(sb, bh[i], first_group + i,desc);
+			set_buffer_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
@@ -1732,6 +1737,10 @@ static int ext3_mb_good_group(struct ext
 	switch (cr) {
 		case 0:
 			BUG_ON(ac->ac_2order == 0);
+			/* If this group is uninitialized, skip it initially */
+			if (grp->bb_gdp->bg_flags &
+			    cpu_to_le16(EXT3_BG_BLOCK_UNINIT))
+				return 0;
 			bits = ac->ac_sb->s_blocksize_bits + 1;
 			for (i = ac->ac_2order; i <= bits; i++)
 				if (grp->bb_counters[i] > 0)
@@ -1825,7 +1834,9 @@ repeat:
 			}
 
 			ac->ac_groups_scanned++;
-			if (cr == 0)
+			if (cr == 0 || (e3b.bd_info->bb_gdp->bg_flags &
+					cpu_to_le16(EXT3_BG_BLOCK_UNINIT) &&
+					ac->ac_2order != 0))
 				ext3_mb_simple_scan_group(ac, &e3b);
 			else if (cr == 1 && ac->ac_g_ex.fe_len == sbi->s_stripe)
 				ext3_mb_scan_aligned(ac, &e3b);
@@ -2304,12 +2315,13 @@ int ext3_mb_init_backend(struct super_bl
 			i--;
 			goto err_freebuddy;
 		}
+		memset(meta_group_info[j], 0, len);
 		desc = ext3_get_group_desc(sb, i, NULL);
+		meta_group_info[j]->bb_gdp = desc;
 		if (desc == NULL) {
 			printk(KERN_ERR"EXT3-fs: can't read descriptor %u\n",i);
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT3_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
@@ -2958,9 +2970,17 @@ int ext3_mb_mark_diskspace_used(struct e
 	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
 
 	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
+	if (gdp->bg_flags & cpu_to_le16(EXT3_BG_BLOCK_UNINIT)) {
+		gdp->bg_flags &= cpu_to_le16(~EXT3_BG_BLOCK_UNINIT);
+		gdp->bg_free_blocks_count =
+			cpu_to_le16(ext3_free_blocks_after_init(sb,
+							    ac->ac_b_ex.fe_group,
+							    gdp));
+	}
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)
 				- ac->ac_b_ex.fe_len);
+	gdp->bg_checksum = ext3_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
 
@@ -4346,6 +4366,7 @@ do_more:
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) + count);
+	gdp->bg_checksum = ext3_group_desc_csum(sbi, block_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 
 
Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
