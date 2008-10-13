From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] -V3 ext4: Use an rbtree for tracking blocks freed
	during transaction.
Date: Mon, 13 Oct 2008 21:39:27 +0530
Message-ID: <20081013160927.GA23970@skywalker>
References: <1223891210-18547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:41828 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755768AbYJMQJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Oct 2008 12:09:38 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9DG9aSX030209
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 21:39:36 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9DG9ahf987170
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 21:39:36 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9DG9Y4J009638
	for <linux-ext4@vger.kernel.org>; Mon, 13 Oct 2008 21:39:35 +0530
Content-Disposition: inline
In-Reply-To: <1223891210-18547-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2008 at 03:16:50PM +0530, Aneesh Kumar K.V wrote:
> With this patch we track the block freed during a transaction using
> rb tree. We also make sure contiguous blocks freed are collected
> in one rb node.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---

Andreas mentioned that when merging the free blocks extents we
should not merge extents from two different transaction.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2f38754..b29dead 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4430,7 +4432,12 @@ static void ext4_mb_poll_new_transaction(struct super_block *sb,
 static int can_merge(struct ext4_free_data *entry1,
 			struct ext4_free_data *entry2)
 {
-	if (entry1->start_blk + entry1->count == entry2->start_blk)
+	/*
+	 * Even though blocks are contiguous, we don't want to
+	 * merge if they don't belong to the same transaction
+	 */
+	if (entry1->t_tid == entry2->t_tid &&
+		(entry1->start_blk + entry1->count) == entry2->start_blk)
 		return 1;
 	return 0;
 }
@@ -4454,6 +4461,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	new_entry->start_blk = block;
 	new_entry->group  = group;
 	new_entry->count = count;
+	new_entry->t_tid = handle->h_transaction->t_tid;
 	new_node = &new_entry->node;
 
 	ext4_lock_group(sb, group);
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 07dff39..c82abb9 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -111,6 +111,11 @@ struct ext4_free_data {
 	 */
 	struct rb_node node;
 
+	/* this link the free block
+	 * information from ext4_sb_info
+	 */
+	struct list_head list;
+
 	/* group this free block
 	 * extent belong
 	 */
@@ -120,10 +125,8 @@ struct ext4_free_data {
 	ext4_grpblk_t start_blk;
 	ext4_grpblk_t count;
 
-	/* this link the free block
-	 * information from ext4_sb_info
-	 */
-	struct list_head list;
+	/* transaction this extent belong */
+	tid_t	t_tid;
 };
 
 struct ext4_group_info {
