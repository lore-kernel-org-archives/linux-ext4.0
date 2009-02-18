From: Greg KH <gregkh@suse.de>
Subject: [patch 30/36] ext4: Dont allow new groups to be added during block
	allocation
Date: Wed, 18 Feb 2009 14:29:51 -0800
Message-ID: <20090218222951.GE10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:35069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757284AbZBRWcV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2009 17:32:21 -0500
Content-Disposition: inline; filename="ext4-don-t-allow-new-groups-to-be-added-during-block-allocation.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

(cherry picked from commit 8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae)

After we mark the blocks in the buddy cache as allocated,
we need to ensure that we don't reinit the buddy cache until
the block bitmap is updated.  This commit achieves this by holding
the group_info alloc_semaphore till ext4_mb_release_context

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/mballoc.c |   18 ++++++++++++++----
 fs/ext4/mballoc.h |    5 +++++
 2 files changed, 19 insertions(+), 4 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1054,7 +1054,8 @@ static void ext4_mb_release_desc(struct 
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
 	/* Done with the buddy cache */
-	up_read(e4b->alloc_semp);
+	if (e4b->alloc_semp)
+		up_read(e4b->alloc_semp);
 }
 
 
@@ -1374,7 +1375,9 @@ static void ext4_mb_use_best_found(struc
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
@@ -3148,7 +3151,7 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	    in_range(block + len - 1, ext4_inode_table(sb, gdp),
 		     EXT4_SB(sb)->s_itb_per_group)) {
 		ext4_error(sb, __func__,
-			   "Allocating block %llu in system zone of %d group\n",
+			   "Allocating block %llu in system zone of %lu group\n",
 			   block, ac->ac_b_ex.fe_group);
 		/* File system mounted not to panic on error
 		 * Fix the bitmap and repeat the block allocation
@@ -4399,6 +4402,7 @@ ext4_mb_initialize_context(struct ext4_a
 	ac->ac_pa = NULL;
 	ac->ac_bitmap_page = NULL;
 	ac->ac_buddy_page = NULL;
+	ac->alloc_semp = NULL;
 	ac->ac_lg = NULL;
 
 	/* we have to define context: we'll we work with a file or
@@ -4579,6 +4583,8 @@ static int ext4_mb_release_context(struc
 		}
 		ext4_mb_put_pa(ac, ac->ac_sb, pa);
 	}
+	if (ac->alloc_semp)
+		up_read(ac->alloc_semp);
 	if (ac->ac_bitmap_page)
 		page_cache_release(ac->ac_bitmap_page);
 	if (ac->ac_buddy_page)
@@ -4682,10 +4688,14 @@ repeat:
 				ac->ac_o_ex.fe_len < ac->ac_b_ex.fe_len)
 			ext4_mb_new_preallocation(ac);
 	}
-
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
 		*errp = ext4_mb_mark_diskspace_used(ac, handle);
 		if (*errp ==  -EAGAIN) {
+			/*
+			 * drop the reference that we took
+			 * in ext4_mb_use_best_found
+			 */
+			ext4_mb_release_context(ac);
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
 			ac->ac_b_ex.fe_len = 0;
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -213,6 +213,11 @@ struct ext4_allocation_context {
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

