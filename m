From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 3/3] ext4: Clarify the locking details in mballoc
Date: Mon,  7 Sep 2009 15:08:14 +0530
Message-ID: <1252316294-10164-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46155 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZIGJic (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Sep 2009 05:38:32 -0400
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [202.81.31.247])
	by e23smtp03.au.ibm.com (8.14.3/8.13.1) with ESMTP id n879aA4V000744
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:36:10 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n879aj1o1224922
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:36:45 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n879cWQ4014809
	for <linux-ext4@vger.kernel.org>; Mon, 7 Sep 2009 19:38:33 +1000
In-Reply-To: <20090907093520.GA6079@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We don't need to take the alloc_sem lock when we
are adding new group. mballoc won't see the new
group added untill we bump sbi->s_groups_count.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    7 +++++--
 fs/ext4/resize.c  |    6 +-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4ed869e..97b2d89 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -926,8 +926,11 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
 	this_grp = ext4_get_group_info(sb, group);
 	/*
-	 * This ensures we don't add group
-	 * to this buddy cache via resize
+	 * This ensures that we don't reinit the buddy cache
+	 * page which map to the group from which we are already
+	 * allocating. If we are looking at the buddy cache we would
+	 * have taken a reference using ext4_mb_load_buddy and that
+	 * would have taken the alloc_sem lock.
 	 */
 	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
 	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 68b0351..4135974 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -856,7 +856,6 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
          * using the new disk blocks.
          */
 
-	num_grp_locked = ext4_mb_get_buddy_cache_lock(sb, input->group);
 	/* Update group descriptor block for new group */
 	gdp = (struct ext4_group_desc *)((char *)primary->b_data +
 					 gdb_off * EXT4_DESC_SIZE(sb));
@@ -875,10 +874,8 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	 * descriptor
 	 */
 	err = ext4_mb_add_groupinfo(sb, input->group, gdp);
-	if (err) {
-		ext4_mb_put_buddy_cache_lock(sb, input->group, num_grp_locked);
+	if (err)
 		goto exit_journal;
-	}
 
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
@@ -920,7 +917,6 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count++;
-	ext4_mb_put_buddy_cache_lock(sb, input->group, num_grp_locked);
 
 	ext4_handle_dirty_metadata(handle, NULL, primary);
 
-- 
1.6.4.2.253.g0b1fac

