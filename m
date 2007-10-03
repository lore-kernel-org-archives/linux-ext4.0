From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [PATCH, RFC 2/3] ext4_grpnum_t: fix negative groups
Date: Tue, 02 Oct 2007 17:33:12 -0700
Message-ID: <4702E348.6050501@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:54300 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbXJCAcL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 20:32:11 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l930WA7E024345
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 20:32:10 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l930WAr5352470
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:10 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l930WAUx024516
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:10 -0600
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l930W9EZ024487
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:09 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4: fixes to block group descriptor being set to a negative value
from: mathur@us.ibm.com

This patch fixes various places where the block group is set to -1.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/ialloc.c |   96 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 51 insertions(+), 45 deletions(-)

Index: linux-2.6.23-rc8-new/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/ialloc.c	2007-09-28 15:49:40.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/ialloc.c	2007-09-28 15:49:50.000000000 -0700
@@ -260,13 +260,15 @@
  * For other inodes, search forward from the parent directory\'s block
  * group to find a free inode.
  */
-static ext4_grpnum_t find_group_dir(struct super_block *sb, struct inode *parent)
+static int find_group_dir(struct super_block *sb, struct inode *parent,
+			  ext4_grpnum_t *best_group)
 {
 	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
 	unsigned int freei, avefreei;
 	struct ext4_group_desc *desc, *best_desc = NULL;
 	struct buffer_head *bh;
-	ext4_grpnum_t group, best_group = -1;
+	ext4_grpnum_t group;
+	int ret = -1;
 
 	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -280,11 +282,12 @@
 		if (!best_desc ||
 		    (le16_to_cpu(desc->bg_free_blocks_count) >
 		     le16_to_cpu(best_desc->bg_free_blocks_count))) {
-			best_group = group;
+			*best_group = group;
 			best_desc = desc;
+			ret = 0;
 		}
 	}
-	return best_group;
+	return ret;
 }
 
 /*
@@ -315,7 +318,8 @@
 #define INODE_COST 64
 #define BLOCK_COST 256
 
-static ext4_grpnum_t find_group_orlov(struct super_block *sb, struct inode *parent)
+static int find_group_orlov(struct super_block *sb, struct inode *parent,
+			ext4_grpnum_t *group)
 {
 	ext4_grpnum_t parent_group = EXT4_I(parent)->i_block_group;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -328,7 +332,7 @@
 	unsigned int ndirs;
 	int max_debt, max_dirs, min_inodes;
 	ext4_grpblk_t min_blocks;
-	ext4_grpnum_t group = -1, i;
+	ext4_grpnum_t i;
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
 
@@ -342,13 +346,14 @@
 	if ((parent == sb->s_root->d_inode) ||
 	    (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL)) {
 		int best_ndir = inodes_per_group;
-		ext4_grpnum_t best_group = -1;
+		ext4_grpnum_t grp;
+		int ret = -1;
 
-		get_random_bytes(&group, sizeof(group));
-		parent_group = (unsigned)group % ngroups;
+		get_random_bytes(&grp, sizeof(grp));
+		parent_group = (unsigned)grp % ngroups;
 		for (i = 0; i < ngroups; i++) {
-			group = (parent_group + i) % ngroups;
-			desc = ext4_get_group_desc (sb, group, &bh);
+			grp = (parent_group + i) % ngroups;
+			desc = ext4_get_group_desc(sb, grp, &bh);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
 			if (le16_to_cpu(desc->bg_used_dirs_count) >= best_ndir)
@@ -357,11 +362,12 @@
 				continue;
 			if (le16_to_cpu(desc->bg_free_blocks_count) < avefreeb)
 				continue;
-			best_group = group;
+			*group = grp;
+			ret = 0;
 			best_ndir = le16_to_cpu(desc->bg_used_dirs_count);
 		}
-		if (best_group >= 0)
-			return best_group;
+		if (ret == 0)
+			return ret;
 		goto fallback;
 	}
 
@@ -382,8 +388,8 @@
 		max_debt = 1;
 
 	for (i = 0; i < ngroups; i++) {
-		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		*group = (parent_group + i) % ngroups;
+		desc = ext4_get_group_desc(sb, *group, &bh);
 		if (!desc || !desc->bg_free_inodes_count)
 			continue;
 		if (le16_to_cpu(desc->bg_used_dirs_count) >= max_dirs)
@@ -392,17 +398,16 @@
 			continue;
 		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
 			continue;
-		return group;
+		return 0;
 	}
 
 fallback:
 	for (i = 0; i < ngroups; i++) {
-		group = (parent_group + i) % ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
-		if (!desc || !desc->bg_free_inodes_count)
-			continue;
-		if (le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
-			return group;
+		*group = (parent_group + i) % ngroups;
+		desc = ext4_get_group_desc(sb, *group, &bh);
+		if (desc && desc->bg_free_inodes_count &&
+		    le16_to_cpu(desc->bg_free_inodes_count) >= avefreei)
+			return 0;
 	}
 
 	if (avefreei) {
@@ -417,22 +422,23 @@
 	return -1;
 }
 
-static ext4_grpnum_t find_group_other(struct super_block *sb, struct inode *parent)
+static int find_group_other(struct super_block *sb, struct inode *parent,
+			ext4_grpnum_t *group)
 {
 	ext4_grpnum_t parent_group = EXT4_I(parent)->i_block_group;
 	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
-	ext4_grpnum_t group, i;
+	ext4_grpnum_t i;
 
 	/*
 	 * Try to place the inode in its parent directory
 	 */
-	group = parent_group;
-	desc = ext4_get_group_desc (sb, group, &bh);
+	*group = parent_group;
+	desc = ext4_get_group_desc(sb, *group, &bh);
 	if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 			le16_to_cpu(desc->bg_free_blocks_count))
-		return group;
+		return 0;
 
 	/*
 	 * We're going to place this inode in a different blockgroup from its
@@ -443,33 +449,33 @@
 	 *
 	 * So add our directory's i_ino into the starting point for the hash.
 	 */
-	group = (group + parent->i_ino) % ngroups;
+	*group = (*group + parent->i_ino) % ngroups;
 
 	/*
 	 * Use a quadratic hash to find a group with a free inode and some free
 	 * blocks.
 	 */
 	for (i = 1; i < ngroups; i <<= 1) {
-		group += i;
-		if (group >= ngroups)
-			group -= ngroups;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		*group += i;
+		if (*group >= ngroups)
+			*group -= ngroups;
+		desc = ext4_get_group_desc(sb, *group, &bh);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count) &&
 				le16_to_cpu(desc->bg_free_blocks_count))
-			return group;
+			return 0;
 	}
 
 	/*
 	 * That failed: try linear search for a free inode, even if that group
 	 * has no free blocks.
 	 */
-	group = parent_group;
+	*group = parent_group;
 	for (i = 0; i < ngroups; i++) {
-		if (++group >= ngroups)
-			group = 0;
-		desc = ext4_get_group_desc (sb, group, &bh);
+		if (++*group >= ngroups)
+			*group = 0;
+		desc = ext4_get_group_desc(sb, *group, &bh);
 		if (desc && le16_to_cpu(desc->bg_free_inodes_count))
-			return group;
+			return 0;
 	}
 
 	return -1;
@@ -490,14 +496,14 @@
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *bh2;
-	ext4_grpnum_t group;
+	ext4_grpnum_t group = 0;
 	unsigned long ino = 0;
 	struct inode * inode;
 	struct ext4_group_desc * gdp = NULL;
 	struct ext4_super_block * es;
 	struct ext4_inode_info *ei;
 	struct ext4_sb_info *sbi;
-	int err = 0;
+	int ret2, err = 0;
 	struct inode *ret;
 	int i, free = 0;
 
@@ -515,14 +521,14 @@
 	es = sbi->s_es;
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
-			group = find_group_dir(sb, dir);
+			ret2 = find_group_dir(sb, dir, &group);
 		else
-			group = find_group_orlov(sb, dir);
+			ret2 = find_group_orlov(sb, dir, &group);
 	} else
-		group = find_group_other(sb, dir);
+		ret2 = find_group_other(sb, dir, &group);
 
 	err = -ENOSPC;
-	if (group == -1)
+	if (ret2 == -1)
 		goto out;
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
