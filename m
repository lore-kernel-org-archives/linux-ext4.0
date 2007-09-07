From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: [PATCH] uninitialized block groups
Date: Fri, 07 Sep 2007 16:06:33 -0700
Message-ID: <46E1D979.3040306@linux.vnet.ibm.com>
References: <46CD1DFE.1030907@linux.vnet.ibm.com> <20070828201840.GX5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050508030904080901080101"
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46428 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbXIGXFk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Sep 2007 19:05:40 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l87N74Ck018706
	for <linux-ext4@vger.kernel.org>; Fri, 7 Sep 2007 19:07:04 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l87N5dFK397454
	for <linux-ext4@vger.kernel.org>; Fri, 7 Sep 2007 19:05:39 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l87N5d4n019574
	for <linux-ext4@vger.kernel.org>; Fri, 7 Sep 2007 19:05:39 -0400
In-Reply-To: <20070828201840.GX5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------050508030904080901080101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andreas Dilger wrote:
> One last note - if this is being applied on top of mballoc it needs one
> last patch for that file (against the 2.6.18-rhel5 tree, should work
> with s/ext3/ext4/ I think):
>   
Here is the patch for uninitialized block group support in mballoc 
ported to ext4; in the patch queue after mballoc-mkdir-oops-fix.patch. 

Thanks
Avantika

----



--------------050508030904080901080101
Content-Type: text/plain;
 name="mballoc-uninit-fix"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mballoc-uninit-fix"

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: linux-2.6.23-rc4/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.23-rc4.orig/fs/ext4/mballoc.c	2007-09-05 13:57:53.000000000 -0700
+++ linux-2.6.23-rc4/fs/ext4/mballoc.c	2007-09-05 13:59:51.000000000 -0700
@@ -36,6 +36,8 @@
 #include <linux/seq_file.h>
 #include <linux/version.h>
 
+#include "group.h"
+
 /*
  * MUSTDO:
  *   - test ext4_ext_search_left() and ext4_ext_search_right()
@@ -321,6 +323,7 @@
 	unsigned long	bb_state;
 	unsigned long 	bb_tid;
 	struct ext4_free_metadata *bb_md_cur;
+	struct ext4_group_desc *bb_gdp;
 	unsigned short	bb_first_free;
 	unsigned short	bb_free;
 	unsigned short	bb_fragments;
@@ -921,10 +924,7 @@
 		if (first_group + i >= EXT4_SB(sb)->s_groups_count)
 			break;
 
-		err = -EIO;
-		desc = ext4_get_group_desc(sb, first_group + i, NULL);
-		if (desc == NULL)
-			goto out;
+		desc = EXT4_GROUP_INFO(sb, first_group + i)->bb_gdp;
 
 		err = -ENOMEM;
 		bh[i] = sb_getblk(sb, le32_to_cpu(desc->bg_block_bitmap));
@@ -939,7 +939,12 @@
 			unlock_buffer(bh[i]);
 			continue;
 		}
-
+		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+			ext4_init_block_bitmap(sb, bh[i], first_group + i,desc);
+			set_buffer_uptodate(bh[i]);
+			unlock_buffer(bh[i]);
+			continue;
+		}
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);
@@ -1722,6 +1727,10 @@
 	switch (cr) {
 		case 0:
 			BUG_ON(ac->ac_2order == 0);
+			/* If this group is uninitialized, skip it initially */
+			if (grp->bb_gdp->bg_flags &
+			    cpu_to_le16(EXT4_BG_BLOCK_UNINIT))
+				return 0;
 			bits = ac->ac_sb->s_blocksize_bits + 1;
 			for (i = ac->ac_2order; i <= bits; i++)
 				if (grp->bb_counters[i] > 0)
@@ -1825,7 +1834,9 @@
 			}
 
 			ac->ac_groups_scanned++;
-			if (cr == 0)
+			if (cr == 0 || (e3b.bd_info->bb_gdp->bg_flags &
+					cpu_to_le16(EXT4_BG_BLOCK_UNINIT) &&
+					ac->ac_2order != 0))
 				ext4_mb_simple_scan_group(ac, &e3b);
 			else if (cr == 1 && ac->ac_g_ex.fe_len == sbi->s_stripe)
 				ext4_mb_scan_aligned(ac, &e3b);
@@ -2304,12 +2315,13 @@
 			i--;
 			goto err_freebuddy;
 		}
+		memset(meta_group_info[j], 0, len);
 		desc = ext4_get_group_desc(sb, i, NULL);
+		meta_group_info[j]->bb_gdp = desc;
 		if (desc == NULL) {
 			printk(KERN_ERR"EXT4-fs: can't read descriptor %u\n",i);
 			goto err_freebuddy;
 		}
-		memset(meta_group_info[j], 0, len);
 		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
 			&meta_group_info[j]->bb_state);
 
@@ -2874,9 +2886,17 @@
 	mb_set_bits(bitmap_bh->b_data, ac->ac_b_ex.fe_start, ac->ac_b_ex.fe_len);
 
 	spin_lock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		gdp->bg_flags &= cpu_to_le16(~EXT4_BG_BLOCK_UNINIT);
+		gdp->bg_free_blocks_count =
+			cpu_to_le16(ext4_free_blocks_after_init(sb,
+							    ac->ac_b_ex.fe_group,
+							    gdp));
+	}
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)
 				- ac->ac_b_ex.fe_len);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, - ac->ac_b_ex.fe_len);
 
@@ -4256,6 +4276,7 @@
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	gdp->bg_free_blocks_count =
 		cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) + count);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
 	percpu_counter_mod(&sbi->s_freeblocks_counter, count);
 


--------------050508030904080901080101--
