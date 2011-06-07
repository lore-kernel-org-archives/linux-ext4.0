From: amir73il@users.sourceforge.net
Subject: [PATCH v1 31/36] ext4: snapshot race conditions - tracked reads
Date: Tue,  7 Jun 2011 18:07:58 +0300
Message-ID: <1307459283-22130-32-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab1FGPKV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:21 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:21 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Wait for pending read I/O requests to complete.
When a snapshot file readpage reads through to the block device,
the reading task increments the block tracked readers count.
Upon completion of the async read I/O request of the snapshot page,
the tracked readers count is decremented.
When a task is COWing a block with non-zero tracked readers count,
that task has to wait (in msleep(1) loop), until the block's tracked
readers count drops to zero, before the COW operation is completed.
After a pending COW operation has started, reader tasks have to wait
(again, in msleep(1) loop), until the pending COW operation is
completed, so the COWing task cannot be starved by reader tasks.
The sleep loop method was copied from LVM snapshot code, which does
the same thing to deal with these (rare) races without wait queues.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h            |    6 ++
 fs/ext4/snapshot.c        |   17 +++++
 fs/ext4/snapshot.h        |   76 ++++++++++++++++++++++
 fs/ext4/snapshot_buffer.c |  155 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_inode.c  |   24 +++++++
 5 files changed, 278 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ea1f38a..0599fef 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2238,12 +2238,18 @@ enum ext4_state_bits {
 			 * now used by snapshot to do mow
 			 */
 	BH_Partial_Write,	/* Buffer should be uptodate before write */
+	BH_Tracked_Read,	/* Buffer read I/O is being tracked,
+				 * to serialize write I/O to block device.
+				 * that is, don't write over this block
+				 * until I finished reading it.
+				 */
 };
 
 BUFFER_FNS(Uninit, uninit)
 TAS_BUFFER_FNS(Uninit, uninit)
 BUFFER_FNS(Remap, remap)
 BUFFER_FNS(Partial_Write, partial_write)
+BUFFER_FNS(Tracked_Read, tracked_read)
 
 /*
  * Add new method to test wether block and inode bitmaps are properly
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index bd6a833..a1e4175 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -107,6 +107,23 @@ ext4_snapshot_complete_cow(handle_t *handle, struct inode *snapshot,
 {
 	int err = 0;
 
+	/* wait for completion of tracked reads before completing COW */
+	while (bh && buffer_tracked_readers_count(bh) > 0) {
+		snapshot_debug_once(2, "waiting for tracked reads: "
+			"block = [%llu/%llu], "
+			"tracked_readers_count = %d...\n",
+			SNAPSHOT_BLOCK_TUPLE(bh->b_blocknr),
+			buffer_tracked_readers_count(bh));
+		/*
+		 * Quote from LVM snapshot pending_complete() function:
+		 * "Check for conflicting reads. This is extremely improbable,
+		 *  so msleep(1) is sufficient and there is no need for a wait
+		 *  queue." (drivers/md/dm-snap.c).
+		 */
+		msleep(1);
+		/* XXX: Should we fail after N retries? */
+	}
+
 	unlock_buffer(sbh);
 	err = ext4_jbd2_file_inode(handle, snapshot);
 	if (err)
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 37f5c2d..3282fe7 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -538,6 +538,82 @@ static inline void ext4_snapshot_test_pending_cow(struct buffer_head *sbh,
 		/* XXX: Should we fail after N retries? */
 	}
 }
+/*
+ * A tracked reader takes 0x10000 reference counts on the block device buffer.
+ * b_count is not likely to reach 0x10000 by get_bh() calls, but even if it
+ * does, that will only affect the result of buffer_tracked_readers_count().
+ * After 0x10000 subsequent calls to get_bh_tracked_reader(), b_count will
+ * overflow, but that requires 0x10000 parallel readers from 0x10000 different
+ * snapshots and very slow disk I/O...
+ */
+#define BH_TRACKED_READERS_COUNT_SHIFT 16
+
+static inline void get_bh_tracked_reader(struct buffer_head *bdev_bh)
+{
+	atomic_add(1<<BH_TRACKED_READERS_COUNT_SHIFT, &bdev_bh->b_count);
+}
+
+static inline void put_bh_tracked_reader(struct buffer_head *bdev_bh)
+{
+	atomic_sub(1<<BH_TRACKED_READERS_COUNT_SHIFT, &bdev_bh->b_count);
+}
+
+static inline int buffer_tracked_readers_count(struct buffer_head *bdev_bh)
+{
+	return atomic_read(&bdev_bh->b_count)>>BH_TRACKED_READERS_COUNT_SHIFT;
+}
+
+/* buffer.c */
+extern int start_buffer_tracked_read(struct buffer_head *bh);
+extern void cancel_buffer_tracked_read(struct buffer_head *bh);
+extern int ext4_read_full_page(struct page *page, get_block_t *get_block);
+
+#ifdef CONFIG_EXT4_DEBUG
+extern void __ext4_trace_bh_count(const char *fn, struct buffer_head *bh);
+#define ext4_trace_bh_count(bh) __ext4_trace_bh_count(__func__, bh)
+#else
+#define ext4_trace_bh_count(bh)
+#define __ext4_trace_bh_count(fn, bh)
+#endif
+
+#define sb_bread(sb, blk) ext4_sb_bread(__func__, sb, blk)
+#define sb_getblk(sb, blk) ext4_sb_getblk(__func__, sb, blk)
+#define sb_find_get_block(sb, blk) ext4_sb_find_get_block(__func__, sb, blk)
+
+static inline struct buffer_head *
+ext4_sb_bread(const char *fn, struct super_block *sb, sector_t block)
+{
+	struct buffer_head *bh;
+
+	bh = __bread(sb->s_bdev, block, sb->s_blocksize);
+	if (bh)
+		__ext4_trace_bh_count(fn, bh);
+	return bh;
+}
+
+static inline struct buffer_head *
+ext4_sb_getblk(const char *fn, struct super_block *sb, sector_t block)
+{
+	struct buffer_head *bh;
+
+	bh = __getblk(sb->s_bdev, block, sb->s_blocksize);
+	if (bh)
+		__ext4_trace_bh_count(fn, bh);
+	return bh;
+}
+
+static inline struct buffer_head *
+ext4_sb_find_get_block(const char *fn, struct super_block *sb, sector_t block)
+{
+	struct buffer_head *bh;
+
+	bh = __find_get_block(sb->s_bdev, block, sb->s_blocksize);
+	if (bh)
+		__ext4_trace_bh_count(fn, bh);
+	return bh;
+}
+
+
 
 #else /* CONFIG_EXT4_FS_SNAPSHOT */
 
diff --git a/fs/ext4/snapshot_buffer.c b/fs/ext4/snapshot_buffer.c
index acea9a3..387965e 100644
--- a/fs/ext4/snapshot_buffer.c
+++ b/fs/ext4/snapshot_buffer.c
@@ -55,6 +55,156 @@ static void buffer_io_error(struct buffer_head *bh)
 }
 
 /*
+ * Tracked read functions.
+ * When reading through a ext4 snapshot file hole to a block device block,
+ * all writes to this block need to wait for completion of the async read.
+ * ext4_snapshot_readpage() always calls ext4_read_full_page() to attach
+ * a buffer head to the page and be aware of tracked reads.
+ * ext4_snapshot_get_block() calls start_buffer_tracked_read() to mark both
+ * snapshot page buffer and block device page buffer.
+ * ext4_snapshot_get_block() calls cancel_buffer_tracked_read() if snapshot
+ * doesn't need to read through to the block device.
+ * ext4_read_full_page() calls submit_buffer_tracked_read() to submit a
+ * tracked async read.
+ * end_buffer_async_read() calls end_buffer_tracked_read() to complete the
+ * tracked read operation.
+ * The only lock needed in all these functions is PageLock on the snapshot page,
+ * which is guarantied in readpage() and verified in ext4_read_full_page().
+ * The block device page buffer doesn't need any lock because the operations
+ * {get|put}_bh_tracked_reader() are atomic.
+ */
+
+#ifdef CONFIG_EXT4_DEBUG
+/*
+ * trace maximum value of b_count on all fs buffers to see if we are
+ * overflowing to upper word (tracked readers count)
+ */
+void __ext4_trace_bh_count(const char *fn, struct buffer_head *bh)
+{
+	static sector_t blocknr;
+	static int maxcount;
+	static int maxbit = 1;
+	static int maxorder;
+	int count = atomic_read(&bh->b_count) & 0x0000ffff;
+
+	BUG_ON(count < 0);
+	if (count <= maxcount)
+		return;
+	maxcount = count;
+	blocknr = bh->b_blocknr;
+
+	if (count <= maxbit)
+		return;
+	while (count > maxbit) {
+		maxbit <<= 1;
+		maxorder++;
+	}
+
+	snapshot_debug(maxorder > 7 ? 1 : 2,
+			"%s: buffer refcount maxorder = %d, "
+			"maxcount = 0x%08x, block = [%llu/%llu].\n",
+			fn, maxorder, maxcount,
+			SNAPSHOT_BLOCK_TUPLE(blocknr));
+}
+#endif
+
+/*
+ * start buffer tracked read
+ * called from inside get_block()
+ * get tracked reader ref count on buffer cache entry
+ * and set buffer tracked read flag
+ */
+int start_buffer_tracked_read(struct buffer_head *bh)
+{
+	struct buffer_head *bdev_bh;
+
+	BUG_ON(buffer_tracked_read(bh));
+	BUG_ON(!buffer_mapped(bh));
+
+	/* grab the buffer cache entry */
+	bdev_bh = __getblk(bh->b_bdev, bh->b_blocknr, bh->b_size);
+	if (!bdev_bh)
+		return -EIO;
+
+	BUG_ON(bdev_bh == bh);
+	ext4_trace_bh_count(bdev_bh);
+	set_buffer_tracked_read(bh);
+	get_bh_tracked_reader(bdev_bh);
+	put_bh(bdev_bh);
+	return 0;
+}
+
+/*
+ * cancel buffer tracked read
+ * called for tracked read that was started but was not submitted
+ * put tracked reader ref count on buffer cache entry
+ * and clear buffer tracked read flag
+ */
+void cancel_buffer_tracked_read(struct buffer_head *bh)
+{
+	struct buffer_head *bdev_bh;
+
+	BUG_ON(!buffer_tracked_read(bh));
+	BUG_ON(!buffer_mapped(bh));
+
+	/* try to grab the buffer cache entry */
+	bdev_bh = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+	BUG_ON(!bdev_bh || bdev_bh == bh);
+	ext4_trace_bh_count(bdev_bh);
+	clear_buffer_tracked_read(bh);
+	clear_buffer_mapped(bh);
+	put_bh_tracked_reader(bdev_bh);
+	put_bh(bdev_bh);
+}
+
+/*
+ * submit buffer tracked read
+ * save a reference to buffer cache entry and submit I/O
+ */
+static int submit_buffer_tracked_read(struct buffer_head *bh)
+{
+	struct buffer_head *bdev_bh;
+	BUG_ON(!buffer_tracked_read(bh));
+	BUG_ON(!buffer_mapped(bh));
+	/* tracked read doesn't work with multiple buffers per page */
+	BUG_ON(bh->b_this_page != bh);
+
+	/*
+	 * Try to grab the buffer cache entry before submitting async read
+	 * because we cannot call blocking function __find_get_block()
+	 * in interrupt context inside end_buffer_tracked_read().
+	 */
+	bdev_bh = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
+	BUG_ON(!bdev_bh || bdev_bh == bh);
+	ext4_trace_bh_count(bdev_bh);
+	/* override page buffers list with reference to buffer cache entry */
+	bh->b_this_page = bdev_bh;
+	submit_bh(READ, bh);
+	return 0;
+}
+
+/*
+ * end buffer tracked read
+ * complete submitted tracked read
+ */
+static void end_buffer_tracked_read(struct buffer_head *bh)
+{
+	struct buffer_head *bdev_bh = bh->b_this_page;
+
+	BUG_ON(!buffer_tracked_read(bh));
+	BUG_ON(!bdev_bh || bdev_bh == bh);
+	bh->b_this_page = bh;
+	/*
+	 * clear the buffer mapping to make sure
+	 * that get_block() will always be called
+	 */
+	clear_buffer_mapped(bh);
+	clear_buffer_tracked_read(bh);
+	put_bh_tracked_reader(bdev_bh);
+	put_bh(bdev_bh);
+}
+
+/*
  * I/O completion handler for ext4_read_full_page() - pages
  * which come unlocked at the end of I/O.
  */
@@ -68,6 +218,9 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 
 	BUG_ON(!buffer_async_read(bh));
 
+	if (buffer_tracked_read(bh))
+		end_buffer_tracked_read(bh);
+
 	page = bh->b_page;
 	if (uptodate) {
 		set_buffer_uptodate(bh);
@@ -229,6 +382,8 @@ int ext4_read_full_page(struct page *page, get_block_t *get_block)
 	 */
 	for (i = 0; i < nr; i++) {
 		bh = arr[i];
+		if (buffer_tracked_read(bh))
+			return submit_buffer_tracked_read(bh);
 		if (buffer_uptodate(bh))
 			end_buffer_async_read(bh, 1);
 		else
diff --git a/fs/ext4/snapshot_inode.c b/fs/ext4/snapshot_inode.c
index 55cac07..f2311e4 100644
--- a/fs/ext4/snapshot_inode.c
+++ b/fs/ext4/snapshot_inode.c
@@ -195,11 +195,35 @@ get_block:
 	err = ext4_snapshot_get_block_access(inode, &prev_snapshot);
 	if (err < 0)
 		return err;
+	if (!prev_snapshot) {
+		/*
+		 * Possible read through to block device.
+		 * Start tracked read before checking if block is mapped to
+		 * avoid race condition with COW that maps the block after
+		 * we checked if the block is mapped.  If we find that the
+		 * block is mapped, we will cancel the tracked read before
+		 * returning from this function.
+		 */
+		map_bh(bh_result, inode->i_sb, SNAPSHOT_BLOCK(iblock));
+		err = start_buffer_tracked_read(bh_result);
+		if (err < 0) {
+			snapshot_debug(1,
+					"snapshot (%u) failed to start "
+					"tracked read on block (%lld) "
+					"(err=%d)\n", inode->i_generation,
+					(long long)bh_result->b_blocknr, err);
+			return err;
+		}
+	}
 	err = ext4_map_blocks(NULL, inode, &map, 0);
 	snapshot_debug(4, "ext4_snapshot_read_through(%lld): block = "
 		       "(%lld), err = %d\n prev_snapshot = %u",
 		       (long long)iblock, map.m_pblk, err,
 		       prev_snapshot ? prev_snapshot->i_generation : 0);
+	/* if it's not a hole - cancel tracked read before we deadlock
+	 * on pending COW */
+	if (err && buffer_tracked_read(bh_result))
+		cancel_buffer_tracked_read(bh_result);
 	if (err < 0)
 		return err;
 	if (!err && prev_snapshot) {
-- 
1.7.4.1

