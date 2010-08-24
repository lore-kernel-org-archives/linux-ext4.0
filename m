From: David Rientjes <rientjes@google.com>
Subject: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and kzalloc
Date: Tue, 24 Aug 2010 03:50:19 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jens Axboe <jaxboe@fusionio.com>, Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
	cluster-devel@redhat.com, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:44555 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0HXKu3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Aug 2010 06:50:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add kmalloc_nofail(), kcalloc_nofail(), and kzalloc_nofail().  These
functions are equivalent to kmalloc(), kcalloc(), and kzalloc(),
respectively, except that they will never return NULL and instead loop
forever trying to allocate memory.

If the first allocation attempt fails, a warning will be emitted,
including a call trace.  Subsequent failures will suppress this warning.

These were added as helper functions for documentation and auditability.
No future callers should be added.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/md/dm-region-hash.c |    2 +-
 fs/btrfs/inode.c            |    2 +-
 fs/gfs2/log.c               |    2 +-
 fs/gfs2/rgrp.c              |   18 ++++---------
 fs/jbd/transaction.c        |   11 ++------
 fs/reiserfs/journal.c       |    3 +-
 include/linux/slab.h        |   55 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 68 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -290,7 +290,7 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
 	if (unlikely(!nreg))
-		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
+		nreg = kmalloc_nofail(sizeof(*nreg), GFP_NOIO);
 
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1967,7 +1967,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+	delayed = kmalloc_nofail(sizeof(*delayed), GFP_NOFS);
 	delayed->inode = inode;
 
 	spin_lock(&fs_info->delayed_iput_lock);
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -709,7 +709,7 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	}
 	trace_gfs2_log_flush(sdp, 1);
 
-	ai = kzalloc(sizeof(struct gfs2_ail), GFP_NOFS | __GFP_NOFAIL);
+	ai = kzalloc_nofail(sizeof(struct gfs2_ail), GFP_NOFS);
 	INIT_LIST_HEAD(&ai->ai_ail1_list);
 	INIT_LIST_HEAD(&ai->ai_ail2_list);
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1440,8 +1440,8 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 		rgrp_blk++;
 
 		if (!bi->bi_clone) {
-			bi->bi_clone = kmalloc(bi->bi_bh->b_size,
-					       GFP_NOFS | __GFP_NOFAIL);
+			bi->bi_clone = kmalloc_nofail(bi->bi_bh->b_size,
+					       GFP_NOFS);
 			memcpy(bi->bi_clone + bi->bi_offset,
 			       bi->bi_bh->b_data + bi->bi_offset,
 			       bi->bi_len);
@@ -1759,9 +1759,6 @@ fail:
  * @block: the block
  *
  * Figure out what RG a block belongs to and add that RG to the list
- *
- * FIXME: Don't use NOFAIL
- *
  */
 
 void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
@@ -1789,8 +1786,8 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
 	if (rlist->rl_rgrps == rlist->rl_space) {
 		new_space = rlist->rl_space + 10;
 
-		tmp = kcalloc(new_space, sizeof(struct gfs2_rgrpd *),
-			      GFP_NOFS | __GFP_NOFAIL);
+		tmp = kcalloc_nofail(new_space, sizeof(struct gfs2_rgrpd *),
+			      GFP_NOFS);
 
 		if (rlist->rl_rgd) {
 			memcpy(tmp, rlist->rl_rgd,
@@ -1811,17 +1808,14 @@ void gfs2_rlist_add(struct gfs2_sbd *sdp, struct gfs2_rgrp_list *rlist,
  * @rlist: the list of resource groups
  * @state: the lock state to acquire the RG lock in
  * @flags: the modifier flags for the holder structures
- *
- * FIXME: Don't use NOFAIL
- *
  */
 
 void gfs2_rlist_alloc(struct gfs2_rgrp_list *rlist, unsigned int state)
 {
 	unsigned int x;
 
-	rlist->rl_ghs = kcalloc(rlist->rl_rgrps, sizeof(struct gfs2_holder),
-				GFP_NOFS | __GFP_NOFAIL);
+	rlist->rl_ghs = kcalloc_nofail(rlist->rl_rgrps,
+				sizeof(struct gfs2_holder), GFP_NOFS);
 	for (x = 0; x < rlist->rl_rgrps; x++)
 		gfs2_holder_init(rlist->rl_rgd[x]->rd_gl,
 				state, 0,
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -98,14 +98,9 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
 	}
 
 alloc_transaction:
-	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
-		if (!new_transaction) {
-			ret = -ENOMEM;
-			goto out;
-		}
-	}
+	if (!journal->j_running_transaction)
+		new_transaction = kzalloc_nofail(sizeof(*new_transaction),
+						GFP_NOFS);
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
 
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2593,8 +2593,7 @@ static int journal_read(struct super_block *sb)
 static struct reiserfs_journal_list *alloc_journal_list(struct super_block *s)
 {
 	struct reiserfs_journal_list *jl;
-	jl = kzalloc(sizeof(struct reiserfs_journal_list),
-		     GFP_NOFS | __GFP_NOFAIL);
+	jl = kzalloc_nofail(sizeof(struct reiserfs_journal_list), GFP_NOFS);
 	INIT_LIST_HEAD(&jl->j_list);
 	INIT_LIST_HEAD(&jl->j_working_list);
 	INIT_LIST_HEAD(&jl->j_tail_bh_list);
diff --git a/include/linux/slab.h b/include/linux/slab.h
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -334,6 +334,61 @@ static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
+/**
+ * kmalloc_nofail - infinitely loop until kmalloc() succeeds.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ *
+ * NOTE: no new callers of this function should be implemented!
+ * All memory allocations should be failable whenever possible.
+ */
+static inline void *kmalloc_nofail(size_t size, gfp_t flags)
+{
+	void *ret;
+
+	for (;;) {
+		ret = kmalloc(size, flags);
+		if (ret)
+			return ret;
+		WARN_ONCE(1, "Out of memory, no fallback implemented "
+				"(size=%lu flags=0x%x)\n",
+				size, flags);
+	}
+}
+
+/**
+ * kcalloc_nofail - infinitely loop until kcalloc() succeeds.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kcalloc).
+ *
+ * NOTE: no new callers of this function should be implemented!
+ * All memory allocations should be failable whenever possible.
+ */
+static inline void *kcalloc_nofail(size_t n, size_t size, gfp_t flags)
+{
+	void *ret;
+
+	for (;;) {
+		ret = kcalloc(n, size, flags);
+		if (ret)
+			return ret;
+		WARN_ONCE(1, "Out of memory, no fallback implemented "
+				"(n=%lu size=%lu flags=0x%x)\n",
+				n, size, flags);
+	}
+}
+
+/**
+ * kzalloc_nofail - infinitely loop until kzalloc() succeeds.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kzalloc).
+ */
+static inline void *kzalloc_nofail(size_t size, gfp_t flags)
+{
+	return kmalloc_nofail(size, flags | __GFP_ZERO);
+}
+
 void __init kmem_cache_init_late(void);
 
 #endif	/* _LINUX_SLAB_H */
