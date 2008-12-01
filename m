From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 3/4] ext4: Don't allow new groups to be added during block allocation
Date: Mon,  1 Dec 2008 19:13:45 +0530
Message-ID: <1228139026-22736-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1228139026-22736-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1228139026-22736-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:54549 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYLANn6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 08:43:58 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1DhtC9000933
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:55 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1DhAuF3424496
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:10 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1DhsPn015907
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 00:43:54 +1100
In-Reply-To: <1228139026-22736-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After we mark the blocks in the buddy cache as allocated,
we should ensure that we don't reinit the buddy cache untill
the block bitmap is updated. The patch achieve this by holding
the group_info alloc_semaphore till ext4_mb_release_context

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   10 ++++++++--
 fs/ext4/mballoc.h |    5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 24fc3ab..8f33691 100644
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
1.6.0.4.735.gea4f

