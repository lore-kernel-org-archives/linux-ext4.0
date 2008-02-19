From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] fs/ext4/mballoc.c: Convert to list_for_each_entry_rcu()
Date: Tue, 19 Feb 2008 01:31:18 +0100
Message-ID: <47BA2356.90203@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:43029 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYBSAb6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 19:31:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please verify, this patch was not yet tested
---
Convert list_for_each_rcu() to list_for_each_entry_rcu()

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dd0fcfc..0c4dd13 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3127,6 +3127,7 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	loff_t size, orig_size, start_off;
 	ext4_lblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
+	struct ext4_prealloc_space *pa;
 
 	/* do normalize only data requests, metadata requests
 	   do not need preallocation */
@@ -3212,12 +3213,9 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, cur, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
 
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
-
 		if (pa->pa_deleted)
 			continue;
 		spin_lock(&pa->pa_lock);
@@ -3259,10 +3257,8 @@ static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		struct ext4_prealloc_space *pa;
+	list_for_each_entry_rcu(pa, cur, &ei->i_prealloc_list, pa_inode_list) {
 		unsigned long pa_end;
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
 			pa_end = pa->pa_lstart + pa->pa_len;
@@ -3397,8 +3393,7 @@ static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 
 	/* first, try per-file preallocation */
 	rcu_read_lock();
-	list_for_each_rcu(cur, &ei->i_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, cur, &ei->i_prealloc_list, pa_inode_list) {
 
 		/* all fields in this condition don't change,
 		 * so we can skip locking for them */
@@ -3430,8 +3425,7 @@ static int ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		return 0;
 
 	rcu_read_lock();
-	list_for_each_rcu(cur, &lg->lg_prealloc_list) {
-		pa = list_entry(cur, struct ext4_prealloc_space, pa_inode_list);
+	list_for_each_entry_rcu(pa, cur, &lg->lg_prealloc_list, pa_inode_list) {
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0 && pa->pa_free >= ac->ac_o_ex.fe_len) {
 			atomic_inc(&pa->pa_count);
