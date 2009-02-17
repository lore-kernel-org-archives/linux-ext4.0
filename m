From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 17/24] ext4: Don't allow new groups to be added during block allocation
Date: Tue, 17 Feb 2009 10:32:35 -0500
Message-ID: <1234884762-13580-18-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
 <1234884762-13580-11-git-send-email-tytso@mit.edu>
 <1234884762-13580-12-git-send-email-tytso@mit.edu>
 <1234884762-13580-13-git-send-email-tytso@mit.edu>
 <1234884762-13580-14-git-send-email-tytso@mit.edu>
 <1234884762-13580-15-git-send-email-tytso@mit.edu>
 <1234884762-13580-16-git-send-email-tytso@mit.edu>
 <1234884762-13580-17-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33245 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZBQQJe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:09:34 -0500
In-Reply-To: <1234884762-13580-17-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

After we mark the blocks in the buddy cache as allocated,
we need to ensure that we don't reinit the buddy cache until
the block bitmap is updated.  This commit achieves this by holding
the group_info alloc_semaphore till ext4_mb_release_context

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae)
---
 fs/ext4/mballoc.c |   16 +++++++++++++---
 fs/ext4/mballoc.h |    5 +++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3c4d75e..851411f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1052,7 +1052,8 @@ static void ext4_mb_release_desc(struct ext4_buddy *e4b)
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
 	/* Done with the buddy cache */
-	up_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		up_read(e4b->alloc_semp);
 }
 
 
@@ -1372,7 +1373,9 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
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
@@ -4286,6 +4289,7 @@ ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	ac->ac_pa = NULL;
 	ac->ac_bitmap_page = NULL;
 	ac->ac_buddy_page = NULL;
+	ac->alloc_semp = NULL;
 	ac->ac_lg = NULL;
 
 	/* we have to define context: we'll we work with a file or
@@ -4466,6 +4470,8 @@ static int ext4_mb_release_context(struct ext4_allocation_context *ac)
 		}
 		ext4_mb_put_pa(ac, ac->ac_sb, pa);
 	}
+	if (ac->alloc_semp)
+		up_read(ac->alloc_semp);
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)
@@ -4566,10 +4572,14 @@ repeat:
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
index 997f78f..85eb45c 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -216,6 +216,11 @@ struct ext4_allocation_context {
 	__u8 ac_op;		/* operation, for history only */
 	struct page *ac_bitmap_page;
 	struct page *ac_buddy_page;
+	/*
+	 * pointer to the held semaphore upon successful
+	 * block allocation
+	 */
+	struct rw_semaphore *alloc_semp;
 	struct ext4_prealloc_space *ac_pa;
 	struct ext4_locality_group *ac_lg;
 };
-- 
1.5.6.3

