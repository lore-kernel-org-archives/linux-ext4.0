From: amir73il@users.sourceforge.net
Subject: [PATCH v1 30/36] ext4: snapshot race conditions - concurrent COW operations
Date: Tue,  7 Jun 2011 18:07:57 +0300
Message-ID: <1307459283-22130-31-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1FGPKT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:19 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:18 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Wait for pending COW operations to complete.
When concurrent tasks try to COW the same buffer, the task that takes
the active snapshot i_data_sem is elected as the the COWing task.
The COWing task allocates a new snapshot block and creates a buffer
cache entry with ref_count=1 for that new block.  It then locks the
new buffer and marks it with the buffer_new flag.  The rest of the
tasks wait (in msleep(1) loop), until the buffer_new flag is cleared.
The COWing task copies the source buffer into the 'new' buffer,
unlocks it, clears the new_buffer flag and drops its reference count.
On active snapshot readpage, the buffer cache is checked.
If a 'new' buffer entry is found, the reader task waits until the
buffer_new flag is cleared and then copies the 'new' buffer directly
into the snapshot file page.
The sleep loop method was copied from LVM snapshot code, which does
the same thing to deal with these (rare) races without wait queues.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c          |   26 ++++++++++++++++++
 fs/ext4/snapshot.c       |   11 ++++++++
 fs/ext4/snapshot.h       |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_inode.c |   40 ++++++++++++++++++++++++++++
 4 files changed, 141 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index de40993..89a97da 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1049,6 +1049,7 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	int depth;
 	int count = 0;
 	ext4_fsblk_t first_block = 0;
+	struct buffer_head *sbh = NULL;
 
 	trace_ext4_ind_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
 	J_ASSERT(!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)));
@@ -1155,6 +1156,25 @@ static int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 	if (err)
 		goto cleanup;
 
+	if (SNAPMAP_ISCOW(flags)) {
+		/*
+		 * COWing block or creating COW bitmap.
+		 * we now have exclusive access to the COW destination block
+		 * and we are about to create the snapshot block mapping
+		 * and make it public.
+		 * grab the buffer cache entry and mark it new
+		 * to indicate a pending COW operation.
+		 * the refcount for the buffer cache will be released
+		 * when the COW operation is either completed or canceled.
+		 */
+		sbh = sb_getblk(inode->i_sb, le32_to_cpu(chain[depth-1].key));
+		if (!sbh) {
+			err = -EIO;
+			goto cleanup;
+		}
+		ext4_snapshot_start_pending_cow(sbh);
+	}
+
 	if (map->m_flags & EXT4_MAP_REMAP) {
 		map->m_len = count;
 		/* move old block to snapshot */
@@ -1198,6 +1218,12 @@ got_it:
 	/* Clean up and exit */
 	partial = chain + depth - 1;	/* the whole chain */
 cleanup:
+	/* cancel pending COW operation on failure to alloc snapshot block */
+	if (SNAPMAP_ISCOW(flags)) {
+		if (err < 0 && sbh)
+			ext4_snapshot_end_pending_cow(sbh);
+		brelse(sbh);
+	}
 	while (partial > chain) {
 		BUFFER_TRACE(partial->bh, "call brelse");
 		brelse(partial->bh);
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index 000e655..bd6a833 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -115,6 +115,8 @@ ext4_snapshot_complete_cow(handle_t *handle, struct inode *snapshot,
 	if (sync)
 		sync_dirty_buffer(sbh);
 out:
+	/* COW operation is complete */
+	ext4_snapshot_end_pending_cow(sbh);
 	return err;
 }
 
@@ -688,6 +690,12 @@ int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
 	 * we allocated this block -
 	 * copy block data to snapshot and complete COW operation
 	 */
+	snapshot_debug(3, "COWing block [%llu/%llu] of snapshot "
+			"(%u)...\n",
+			SNAPSHOT_BLOCK_TUPLE(block),
+			active_snapshot->i_generation);
+	/* sleep 1 tunable delay unit */
+	snapshot_test_delay(SNAPTEST_COW);
 	err = ext4_snapshot_copy_buffer_cow(handle, active_snapshot,
 			sbh, bh);
 	if (err)
@@ -700,6 +708,9 @@ int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
 
 	trace_cow_inc(handle, copied);
 test_pending_cow:
+	if (sbh)
+		/* wait for pending COW to complete */
+		ext4_snapshot_test_pending_cow(sbh, block);
 
 cowed:
 	/* mark the buffer COWed in the current transaction */
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 44bac96..37f5c2d 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -474,6 +474,70 @@ static inline int ext4_snapshot_mow_in_tid(struct inode *inode)
 		      ext4_snapshot_get_tid(inode->i_sb));
 }
 
+/*
+ * Pending COW functions
+ */
+
+/*
+ * Start pending COW operation from get_blocks_handle()
+ * after allocating snapshot block and before connecting it
+ * to the snapshot inode.
+ */
+static inline void ext4_snapshot_start_pending_cow(struct buffer_head *sbh)
+{
+	/*
+	 * setting the 'new' flag on a newly allocated snapshot block buffer
+	 * indicates that the COW operation is pending.
+	 */
+	set_buffer_new(sbh);
+	/* keep buffer in cache as long as we need to test the 'new' flag */
+	get_bh(sbh);
+}
+
+/*
+ * End pending COW operation started in get_blocks_handle().
+ * Called on failure to connect the new snapshot block to the inode
+ * or on successful completion of the COW operation.
+ */
+static inline void ext4_snapshot_end_pending_cow(struct buffer_head *sbh)
+{
+	/*
+	 * clearing the 'new' flag from the snapshot block buffer
+	 * indicates that the COW operation is complete.
+	 */
+	clear_buffer_new(sbh);
+	/* we no longer need to keep the buffer in cache */
+	put_bh(sbh);
+}
+
+/*
+ * Test for pending COW operation and wait for its completion.
+ */
+static inline void ext4_snapshot_test_pending_cow(struct buffer_head *sbh,
+						sector_t blocknr)
+{
+	while (buffer_new(sbh)) {
+		/* wait for pending COW to complete */
+		snapshot_debug_once(2, "waiting for pending cow: "
+				"block = [%llu/%llu]...\n",
+				SNAPSHOT_BLOCK_TUPLE(blocknr));
+		/*
+		 * An unusually long pending COW operation can be caused by
+		 * the debugging function snapshot_test_delay(SNAPTEST_COW)
+		 * and by waiting for tracked reads to complete.
+		 * The new COW buffer is locked during those events, so wait
+		 * on the buffer before the short msleep.
+		 */
+		wait_on_buffer(sbh);
+		/*
+		 * This is an unlikely event that can happen only once per
+		 * block/snapshot, so msleep(1) is sufficient and there is
+		 * no need for a wait queue.
+		 */
+		msleep(1);
+		/* XXX: Should we fail after N retries? */
+	}
+}
 
 #else /* CONFIG_EXT4_FS_SNAPSHOT */
 
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index a97411e..55cac07 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -183,6 +183,7 @@ static int ext4_snapshot_read_through(struct inode *inode, sector_t iblock,
 	int err;
 	struct ext4_map_blocks map;
 	struct inode *prev_snapshot;
+	struct buffer_head *sbh = NULL;
 
 	map.m_lblk = iblock;
 	map.m_pblk = 0;
@@ -214,6 +215,45 @@ get_block:
 	bh_result->b_state = (bh_result->b_state & ~EXT4_MAP_FLAGS) |
 		map.m_flags;
 
+	/*
+	 * On read of active snapshot, a mapped block may belong to a non
+	 * completed COW operation.  Use the buffer cache to test this
+	 * condition.  if (bh_result->b_blocknr == SNAPSHOT_BLOCK(iblock)),
+	 * then this is either read through to block device or moved block.
+	 * Either way, it is not a COWed block, so it cannot be pending COW.
+	 */
+	if (ext4_snapshot_is_active(inode) &&
+	    bh_result->b_blocknr != SNAPSHOT_BLOCK(iblock))
+		sbh = sb_find_get_block(inode->i_sb, bh_result->b_blocknr);
+	if (!sbh)
+		return 0;
+	/* wait for pending COW to complete */
+	ext4_snapshot_test_pending_cow(sbh, SNAPSHOT_BLOCK(iblock));
+	lock_buffer(sbh);
+	if (buffer_uptodate(sbh)) {
+		/*
+		 * Avoid disk I/O and copy out snapshot page directly
+		 * from block device page when possible.
+		 */
+		BUG_ON(!sbh->b_page);
+		BUG_ON(!bh_result->b_page);
+		lock_buffer(bh_result);
+		copy_highpage(bh_result->b_page, sbh->b_page);
+		set_buffer_uptodate(bh_result);
+		unlock_buffer(bh_result);
+	} else if (buffer_dirty(sbh)) {
+		/*
+		 * If snapshot data buffer is dirty (just been COWed),
+		 * then it is not safe to read it from disk yet.
+		 * We shouldn't get here because snapshot data buffer
+		 * only becomes dirty during COW and because we waited
+		 * for pending COW to complete, which means that a
+		 * dirty snapshot data buffer should be uptodate.
+		 */
+		WARN_ON(1);
+	}
+	unlock_buffer(sbh);
+	brelse(sbh);
 	return 0;
 }
 
-- 
1.7.4.1

