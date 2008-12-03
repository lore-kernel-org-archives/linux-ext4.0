From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4] ext4: Don't allow new groups to be added during block allocation
Date: Wed,  3 Dec 2008 20:49:49 +0530
Message-ID: <1228317589-18551-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37673 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCPW1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Dec 2008 10:22:27 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id mB3FLKTs006064
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 02:21:20 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB3FJtTL201082
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 02:19:55 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB3FJsfl030511
	for <linux-ext4@vger.kernel.org>; Thu, 4 Dec 2008 02:19:55 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After we mark the blocks in the buddy cache as allocated,
we should ensure that we don't reinit the buddy cache untill
the block bitmap is updated. The patch achieve this by holding
the group_info alloc_semaphore till ext4_mb_release_context

v4 changes:
Use ext4_mb_release_context to drop the reference. That way
we make sure the group pa is also updated.

v3 changes:
drop page refence and alloc_sem if we are retrying allocation

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   16 +++++++++++++---
 fs/ext4/mballoc.h |    5 +++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 24fc3ab..d1ba97d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1055,7 +1055,8 @@ __releases(e4b->alloc_semp)
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
 	/* Done with the buddy cache */
-	up_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		up_read(e4b->alloc_semp);
 	__release(e4b->alloc_semp);
 }
 
@@ -1375,7 +1376,9 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
 	get_page(ac->ac_buddy_page);
-
+	/* on allocation we use ac to track the held semaphore */
+	ac->alloc_semp =  e4b->alloc_semp;
+	e4b->alloc_semp = NULL;
 	/* store last allocated for subsequent stream allocation */
 	if ((ac->ac_flags & EXT4_MB_HINT_DATA)) {
 		spin_lock(&sbi->s_md_lock);
@@ -4297,6 +4300,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ac->ac_pa = NULL;
 	ac->ac_bitmap_page = NULL;
 	ac->ac_buddy_page = NULL;
+	ac->alloc_semp = NULL;
 	ac->ac_lg = NULL;
 
 	/* we have to define context: we'll we work with a file or
@@ -4478,6 +4482,8 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 		}
 		ext4_mb_put_pa(ac, ac->ac_sb, pa);
 	}
+	if (ac->alloc_semp)
+		up_read(ac->alloc_semp);
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)
@@ -4578,10 +4584,14 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
 			ext4_mb_new_preallocation(ac);
 	}
-
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
 		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_blks);
 		if (*errp ==  -EAGAIN) {
+			/*
+			 * drop the reference that we took
+			 * in ext4_mb_use_best_found
+			 */
+			ext4_mb_release_context(ac);
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
 			ac->ac_b_ex.fe_len = 0;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 95d4c7f..3b598c7 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -195,6 +195,11 @@ struct ext4_allocation_context {
 	__u8 ac_op;		/* operation, for history only */
 	struct page *ac_bitmap_page;
 	struct page *ac_buddy_page;
+	/*
+	 * pointer to the held semaphore upon successfull
+	 * block allocation
+	 */
+	struct rw_semaphore *alloc_semp;
 	struct ext4_prealloc_space *ac_pa;
 	struct ext4_locality_group *ac_lg;
 };
-- 
1.6.1.rc1

