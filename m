From: Andreas Dilger <adilger@clusterfs.com>
Subject: [PATCH] speed up statfs
Date: Wed, 4 Jul 2007 16:23:44 -0600
Message-ID: <20070704222344.GA5135@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:50125 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757990AbXGDWXr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jul 2007 18:23:47 -0400
Received: from localhost.adilger.int (S0106000bdb95b39c.cg.shawcable.net [70.72.213.136])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.clusterfs.com (Postfix) with ESMTP id 1BAB14E46C0
	for <linux-ext4@vger.kernel.org>; Wed,  4 Jul 2007 16:23:46 -0600 (MDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,
this is a patch we are currently using that speeds up statfs.
It is very simple - the "overhead" calculation, which takes a
huge amount of time for large filesystems, never changes unless
the size of the filesystem itself changes.  That means we can
store it in memory and only recalculate if the filesystem has
been resized (almost never).

It is based on ext3 but is trivally updated to ext4.  It also
fixes a minor problem that we never update the on-disk superblock
free blocks/inodes counts until the filesystem is unmounted.
While not fatal, we may as well update that on disk when we have
the information, and it makes things like debugfs and dumpe2fs
report a bit more accurate info.

I'd be happy if someone could update this to the latest kernel and
for ext2 and ext4 also.


======================= ext3-statfs-2.6.20.diff ==========================
Index: linux-stage/include/linux/ext3_fs_sb.h
===================================================================
--- linux-stage.orig/include/linux/ext3_fs_sb.h	2007-03-22 17:29:30.000000000 -0600
+++ linux-stage/fs/include/ext3_fs_sb.h 2007-03-23 01:48:41.000000000 -0600
@@ -38,6 +38,8 @@ struct ext3_sb_info {
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
 	unsigned long s_desc_per_block;	/* Number of group descriptors per block */
 	unsigned long s_groups_count;	/* Number of groups in the fs */
+	unsigned long s_overhead_last;  /* Last calculated overhead */
+	unsigned long s_blocks_last;    /* Last seen block count */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext3_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
Index: linux-stage/fs/ext3/super.c
===================================================================
--- linux-stage.orig/fs/ext3/super.c	2007-03-22 17:29:30.000000000 -0600
+++ linux-stage/fs/ext3/super.c	2007-03-23 01:48:41.000000000 -0600
@@ -2389,19 +2389,19 @@ restore_opts:
 	struct super_block *sb = dentry->d_sb;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
-	ext3_fsblk_t overhead;
-	int i;
 	u64 fsid;
 
-	if (test_opt (sb, MINIX_DF))
-		overhead = 0;
-	else {
-		unsigned long ngroups;
-		ngroups = EXT3_SB(sb)->s_groups_count;
+	if (test_opt(sb, MINIX_DF)) {
+		sbi->s_overhead_last = 0;
+	} else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
+		unsigned long ngroups = sbi->s_groups_count, i;
+		ext3_fsblk_t overhead = 0;
 		smp_rmb();
 
 		/*
-		 * Compute the overhead (FS structures)
+		 * Compute the overhead (FS structures).  This is constant
+		 * for a given filesystem unless the number of block groups
+		 * changes so we cache the previous value until it does.
 		 */
 
 		/*
@@ -2419,18 +2422,23 @@ static int ext3_statfs (struct super_blo
 		 * Every block group has an inode bitmap, a block
 		 * bitmap, and an inode table.
 		 */
-		overhead += (ngroups * (2 + EXT3_SB(sb)->s_itb_per_group));
+		overhead += ngroups * (2 + sbi->s_itb_per_group);
+		sbi->s_overhead_last = overhead;
+		smp_wmb();
+		sbi->s_blocks_last = le32_to_cpu(es->s_blocks_count);
 	}
 
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - overhead;
+	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT3_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
===========================================================================

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
