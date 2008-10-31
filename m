From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ext4: sparse annotate the group info semaphore
Date: Fri, 31 Oct 2008 22:20:57 +0530
Message-ID: <1225471859-19718-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225471859-19718-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	frederic.bohe@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:43024 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbYJaQvR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 12:51:17 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m9VGo8uv031997
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:50:08 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9VGpGtQ4345876
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:16 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9VGpFTG002616
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:51:15 +1100
In-Reply-To: <1225471859-19718-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

sparse annotate the group info allocation semaphore

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 390dc81..34a365e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -895,6 +895,7 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 static noinline_for_stack int
 ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
+__acquires(e4b->alloc_semp)
 {
 	int blocks_per_page;
 	int block;
@@ -926,6 +927,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	 * till we are done with allocation
 	 */
 	down_read(e4b->alloc_semp);
+	__acquire(e4b->alloc_semp);
 
 	/*
 	 * the buddy cache inode stores the block bitmap
@@ -1020,6 +1022,7 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 }
 
 static void ext4_mb_release_desc(struct ext4_buddy *e4b)
+__releases(e4b->alloc_semp)
 {
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
@@ -1027,6 +1030,7 @@ static void ext4_mb_release_desc(struct ext4_buddy *e4b)
 		page_cache_release(e4b->bd_buddy_page);
 	/* Done with the buddy cache */
 	up_read(e4b->alloc_semp);
+	__release(e4b->alloc_semp);
 }
 
 
@@ -1468,8 +1472,10 @@ static int ext4_mb_try_best_found(struct ext4_allocation_context *ac,
 
 	BUG_ON(ex.fe_len <= 0);
 	err = ext4_mb_load_buddy(ac->ac_sb, group, e4b);
-	if (err)
+	if (err) {
+		__release(e4b->alloc_semp);
 		return err;
+	}
 
 	ext4_lock_group(ac->ac_sb, group);
 	max = mb_find_extent(e4b, 0, ex.fe_start, ex.fe_len, &ex);
@@ -1499,8 +1505,10 @@ static int ext4_mb_find_by_goal(struct ext4_allocation_context *ac,
 		return 0;
 
 	err = ext4_mb_load_buddy(ac->ac_sb, group, e4b);
-	if (err)
+	if (err) {
+		__release(e4b->alloc_semp);
 		return err;
+	}
 
 	ext4_lock_group(ac->ac_sb, group);
 	max = mb_find_extent(e4b, 0, ac->ac_g_ex.fe_start,
@@ -1963,8 +1971,10 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 				continue;
 
 			err = ext4_mb_load_buddy(sb, group, &e4b);
-			if (err)
+			if (err) {
+				__release(e4b->alloc_semp);
 				goto out;
+			}
 
 			ext4_lock_group(sb, group);
 			if (!ext4_mb_good_group(ac, group, cr)) {
@@ -2275,6 +2285,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
 		sizeof(struct ext4_group_info);
 	err = ext4_mb_load_buddy(sb, group, &e4b);
 	if (err) {
+		__release(e4b->alloc_semp);
 		seq_printf(seq, "#%-5lu: I/O error\n", group);
 		return 0;
 	}
@@ -3820,6 +3831,7 @@ ext4_mb_discard_group_preallocations(struct super_block *sb,
 
 	err = ext4_mb_load_buddy(sb, group, &e4b);
 	if (err) {
+		__release(e4b->alloc_semp);
 		ext4_error(sb, __func__, "Error in loading buddy "
 				"information for %lu\n", group);
 		put_bh(bitmap_bh);
@@ -3987,6 +3999,7 @@ void ext4_discard_preallocations(struct inode *inode)
 
 		err = ext4_mb_load_buddy(sb, group, &e4b);
 		if (err) {
+			__release(e4b->alloc_semp);
 			ext4_error(sb, __func__, "Error in loading buddy "
 					"information for %lu\n", group);
 			continue;
@@ -4260,6 +4273,7 @@ ext4_mb_discard_lg_preallocations(struct super_block *sb,
 
 		ext4_get_group_no_and_offset(sb, pa->pa_pstart, &group, NULL);
 		if (ext4_mb_load_buddy(sb, group, &e4b)) {
+			__release(e4b->alloc_semp);
 			ext4_error(sb, __func__, "Error in loading buddy "
 					"information for %lu\n", group);
 			continue;
@@ -4720,8 +4734,10 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	err = ext4_mb_load_buddy(sb, block_group, &e4b);
-	if (err)
+	if (err) {
+		__release(e4b->alloc_semp);
 		goto error_return;
+	}
 	if (metadata) {
 		/* blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed */
@@ -4805,8 +4821,10 @@ ext4_mb_search_free_extents(struct inode *inode,
 	end = EXT4_BLOCKS_PER_GROUP(sb) - 1;
 
 	err = ext4_mb_load_buddy(sb, group_no, &e4b);
-	if (err)
+	if (err) {
+		__release(e4b->alloc_semp);
 		return err;
+	}
 
 	/* We consider about the boot block if bs = 1k */
 	if (sb->s_blocksize == 1024)
-- 
1.6.0.3.514.g2f91b

