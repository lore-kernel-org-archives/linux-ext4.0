From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/2] lock block groups when initializing
Date: Fri, 18 Jul 2008 14:58:11 -0500
Message-ID: <4880F5D3.8080805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005AbYGRT6N (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jul 2008 15:58:13 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m6IJwCg4026457
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:58:12 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IJwCBR001529
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:58:12 -0400
Received: from Liberator.local (sebastian-int.corp.redhat.com [172.16.52.221])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IJwBiM008000
	for <linux-ext4@vger.kernel.org>; Fri, 18 Jul 2008 15:58:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I noticed when filling a 1T filesystem with 4 threads using the 
fs_mark benchmark:

fs_mark -d /mnt/test -D 256 -n 100000 -t 4 -s 20480 -F -S 0

that I occasionally got checksum mismatch errors:

EXT4-fs error (device sdb): ext4_init_inode_bitmap: Checksum bad for group 6935

etc.  I'd reliably get 4-5 of them during the run.

It appears that the problem is likely a race to init the bg's
when the uninit_bg feature is enabled.

With the patch below, which adds sb_bgl_locking around initialization,
I was able to complete several runs with no errors or warnings.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c	2008-07-18 12:37:19.826353478 -0500
+++ linux-2.6/fs/ext4/balloc.c	2008-07-18 12:37:40.731354157 -0500
@@ -321,12 +321,15 @@ ext4_read_block_bitmap(struct super_bloc
 	if (bh_uptodate_or_lock(bh))
 		return bh;
 
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 		ext4_init_block_bitmap(sb, bh, block_group, desc);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
 	}
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
Index: linux-2.6/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/ialloc.c	2008-07-18 12:37:19.828353479 -0500
+++ linux-2.6/fs/ext4/ialloc.c	2008-07-18 12:37:40.732353959 -0500
@@ -118,12 +118,15 @@ ext4_read_inode_bitmap(struct super_bloc
 	if (bh_uptodate_or_lock(bh))
 		return bh;
 
+	spin_lock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 		return bh;
 	}
+	spin_unlock(sb_bgl_lock(EXT4_SB(sb), block_group));
 	if (bh_submit_read(bh) < 0) {
 		put_bh(bh);
 		ext4_error(sb, __func__,
@@ -735,7 +738,7 @@ got:
 
 			/* When marking the block group with
 			 * ~EXT4_BG_INODE_UNINIT we don't want to depend
-			 * on the value of bg_itable_unsed even though
+			 * on the value of bg_itable_unused even though
 			 * mke2fs could have initialized the same for us.
 			 * Instead we calculated the value below
 			 */
Index: linux-2.6/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.orig/fs/ext4/mballoc.c	2008-07-18 14:46:10.873291452 -0500
+++ linux-2.6/fs/ext4/mballoc.c	2008-07-18 14:56:11.329291114 -0500
@@ -787,13 +787,16 @@ static int ext4_mb_init_cache(struct pag
 		if (bh_uptodate_or_lock(bh[i]))
 			continue;
 
+		spin_lock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
 			ext4_init_block_bitmap(sb, bh[i],
 						first_group + i, desc);
 			set_buffer_uptodate(bh[i]);
 			unlock_buffer(bh[i]);
+			spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 			continue;
 		}
+		spin_unlock(sb_bgl_lock(EXT4_SB(sb), first_group + i));
 		get_bh(bh[i]);
 		bh[i]->b_end_io = end_buffer_read_sync;
 		submit_bh(READ, bh[i]);Index: linux-2.6/fs/ext4/super.c
===================================================================
--- linux-2.6.orig/fs/ext4/super.c	2008-07-18 12:35:13.110291141 -0500
+++ linux-2.6/fs/ext4/super.c	2008-07-18 12:37:40.784353748 -0500
@@ -1621,6 +1621,7 @@ static int ext4_check_descriptors(struct
 			       "(block %llu)!", i, inode_table);
 			return 0;
 		}
+		spin_lock(sb_bgl_lock(sbi, i));
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
 			printk(KERN_ERR "EXT4-fs: ext4_check_descriptors: "
 			       "Checksum for group %lu failed (%u!=%u)\n",
@@ -1628,6 +1629,7 @@ static int ext4_check_descriptors(struct
 			       gdp)), le16_to_cpu(gdp->bg_checksum));
 			return 0;
 		}
+		spin_unlock(sb_bgl_lock(sbi, i));
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 	}

