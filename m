From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: potential NULL dereference on error
Date: Sun, 13 May 2012 17:41:04 +0300
Message-ID: <20120513144104.GA21998@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:51017 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab2EMOlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 May 2012 10:41:16 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_get_group_desc() function returns NULL on error, and
ext4_free_inodes_count() function dereferences it without checking.
There is a check on the next line, but it's too late.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker fix.

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index a044a9b..1526f33 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -389,7 +389,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t real_ngroups = ext4_get_groups_count(sb);
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
-	unsigned int freei, avefreei, grp_free;
+	unsigned int freei, avefreei;
 	ext4_fsblk_t freeb, avefreec;
 	unsigned int ndirs;
 	int max_dirs, min_inodes;
@@ -399,6 +399,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent,
 	struct orlov_stats stats;
 	int flex_size = ext4_flex_bg_size(sbi);
 	struct dx_hash_info hinfo;
+	unsigned int grp_free = 0;
 
 	ngroups = real_ngroups;
 	if (flex_size > 1) {
@@ -508,7 +509,8 @@ fallback_retry:
 	for (i = 0; i < ngroups; i++) {
 		grp = (parent_group + i) % ngroups;
 		desc = ext4_get_group_desc(sb, grp, NULL);
-		grp_free = ext4_free_inodes_count(sb, desc);
+		if (desc)
+			grp_free = ext4_free_inodes_count(sb, desc);
 		if (desc && grp_free && grp_free >= avefreei) {
 			*group = grp;
 			return 0;
