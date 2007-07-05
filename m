From: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [PATCH] ext4 statfs speed up
Date: Thu, 05 Jul 2007 11:11:38 -0700
Message-ID: <1183659098.19473.9.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:60270 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759745AbXGESKG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jul 2007 14:10:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l65IA5qV019766
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 14:10:05 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l65IA1l1255536
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 12:10:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l65IA05d013058
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jul 2007 12:10:01 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a patch that speeds up statfs.  It is very simple - 
the "overhead" calculation, which takes a huge amount of time 
for large filesystems, never changes unless the size of the 
filesystem itself changes.  That means we can store it in memory 
and only recalculate if the filesystem has been resized (almost 
never).

It also fixes a minor problem that we never update the on-disk 
superblock free blocks/inodes counts until the filesystem is 
unmounted.  While not fatal, we may as well update that on disk 
when we have the information, and it makes things like debugfs 
and dumpe2fs report a bit more accurate info.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

 fs/ext4/super.c            |   25 +++++++++++++++----------
 include/linux/ext4_fs_sb.h |    2 ++
 2 files changed, 17 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc7/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.22-rc7.orig/include/linux/ext4_fs_sb.h	2007-07-01 12:54:24.000000000 -0700
+++ linux-2.6.22-rc7/include/linux/ext4_fs_sb.h	2007-07-04 22:09:59.000000000 -0700
@@ -39,6 +39,8 @@ struct ext4_sb_info {
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
 	unsigned long s_desc_per_block;	/* Number of group descriptors per block */
 	unsigned long s_groups_count;	/* Number of groups in the fs */
+	unsigned long s_overhead_last;  /* Last calculated overhead */
+	unsigned long s_blocks_last;    /* Last seen block count */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
Index: linux-2.6.22-rc7/fs/ext4/super.c
===================================================================
--- linux-2.6.22-rc7.orig/fs/ext4/super.c	2007-07-01 12:54:24.000000000 -0700
+++ linux-2.6.22-rc7/fs/ext4/super.c	2007-07-04 22:12:27.000000000 -0700
@@ -2481,19 +2481,19 @@ static int ext4_statfs (struct dentry * 
 	struct super_block *sb = dentry->d_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	ext4_fsblk_t overhead;
-	int i;
 	u64 fsid;
 
-	if (test_opt (sb, MINIX_DF))
-		overhead = 0;
-	else {
-		unsigned long ngroups;
-		ngroups = EXT4_SB(sb)->s_groups_count;
+	if (test_opt(sb, MINIX_DF)) {
+		sbi->s_overhead_last = 0;
+	} else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
+		unsigned long ngroups = sbi->s_groups_count, i;
+		ext4_fsblk_t overhead = 0;
 		smp_rmb();
 
 		/*
-		 * Compute the overhead (FS structures)
+		 * Compute the overhead (FS structures).  This is constant
+		 * for a given filesystem unless the number of block groups
+		 * changes so we cache the previous value until it does.
 		 */
 
 		/*
@@ -2517,18 +2517,23 @@ static int ext4_statfs (struct dentry * 
 		 * Every block group has an inode bitmap, a block
 		 * bitmap, and an inode table.
 		 */
-		overhead += (ngroups * (2 + EXT4_SB(sb)->s_itb_per_group));
+		overhead += ngroups * (2 + sbi->s_itb_per_group);
+		sbi->s_overhead_last = overhead;
+		smp_wmb();
+		sbi->s_blocks_last = le32_to_cpu(es->s_blocks_count);
 	}
 
 	buf->f_type = EXT4_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
-	buf->f_blocks = ext4_blocks_count(es) - overhead;
+	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
+	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
 	buf->f_files = le32_to_cpu(es->s_inodes_count);
 	buf->f_ffree = percpu_counter_sum(&sbi->s_freeinodes_counter);
+	es->s_free_inodes_count = cpu_to_le32(buf->f_ffree);
 	buf->f_namelen = EXT4_NAME_LEN;
 	fsid = le64_to_cpup((void *)es->s_uuid) ^
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
