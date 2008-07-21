From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Improve error handling in mballoc
Date: Mon, 21 Jul 2008 15:10:34 +0530
Message-ID: <1216633234-24194-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1216633234-24194-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:42535 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbYGUJtb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 05:49:31 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id m6L9q7Te088072
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:52:07 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6L9egRd010850
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:40:42 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6L9efxo014857
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 19:40:41 +1000
In-Reply-To: <1216633234-24194-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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

