From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Improve error handling in mballoc
Date: Wed, 23 Jul 2008 22:40:45 +0530
Message-ID: <1216833047-4959-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1216833047-4959-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47827 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753293AbYGWRLI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 13:11:08 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6NHB2e9026111
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:02 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6NHB2X51851562
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:02 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6NHB1bt027823
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 22:41:01 +0530
In-Reply-To: <1216833047-4959-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't call BUG_ON on file system failures. Instead
use ext4_error and also handle the continue case
properly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index d062d08..9db0f4d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3737,20 +3737,23 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 
 	bitmap_bh = ext4_read_block_bitmap(sb, group);
 	if (bitmap_bh == NULL) {
-		/* error handling here */
-		ext4_mb_release_desc(&e4b);
-		BUG_ON(bitmap_bh == NULL);
+		ext4_error(sb, __func__, "Error in reading block "
+				"bitmap for %lu\n", group);
+		return 0;
 	}
 
 	err = ext4_mb_load_buddy(sb, group, &e4b);
-	BUG_ON(err != 0); /* error handling here */
+	if (err) {
+		ext4_error(sb, __func__, "Error in loading buddy "
+				"information for %lu\n", group);
+		put_bh(bitmap_bh);
+		return 0;
+	}
 
 	if (needed == 0)
 		needed = EXT4_BLOCKS_PER_GROUP(sb) + 1;
 
-	grp = ext4_get_group_info(sb, group);
 	INIT_LIST_HEAD(&list);
-
 	ac = kmem_cache_alloc(ext4_ac_cachep, GFP_NOFS);
 repeat:
 	ext4_lock_group(sb, group);
@@ -3907,13 +3910,18 @@ void ext4_mb_discard_inode_preallocations(struct inode *inode)
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
-		BUG_ON(err != 0); /* error handling here */
+		if (err) {
+			ext4_error(sb, __func__, "Error in loading buddy "
+					"information for %lu\n", group);
+			continue;
+		}
 
 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (bitmap_bh == NULL) {
-			/* error handling here */
+			ext4_error(sb, __func__, "Error in reading block "
+					"bitmap for %lu\n", group);
 			ext4_mb_release_desc(&e4b);
-			BUG_ON(bitmap_bh == NULL);
+			continue;
 		}
 
 		ext4_lock_group(sb, group);
@@ -4425,11 +4433,15 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 		count -= overflow;
 	}
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
-	if (!bitmap_bh)
+	if (!bitmap_bh) {
+		err = -EIO;
 		goto error_return;
+	}
 	gdp = ext4_get_group_desc(sb, block_group, &gd_bh);
-	if (!gdp)
+	if (!gdp) {
+		err = -EIO;
 		goto error_return;
+	}
 
 	if (in_range(ext4_block_bitmap(sb, gdp), block, count) ||
 	    in_range(ext4_inode_bitmap(sb, gdp), block, count) ||
-- 
1.5.6.3.439.g1e10.dirty

