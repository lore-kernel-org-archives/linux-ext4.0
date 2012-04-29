From: Miao Xie <miaoxie1984@gmail.com>
Subject: [PATCH 1/2] vfs: re-implement writeback_inodes_sb(_nr)_if_idle()
 and rename them
Date: Sun, 29 Apr 2012 23:25:13 +0800
Message-ID: <4F9D5D59.3080307@gmail.com>
Reply-To: miaoxie1984@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux FSDevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	miaox@cn.fujitsu.com, Kamal Mostafa <kamal@canonical.com>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Tsutomu Itoh <t-itoh@jp.fujitsu.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

writeback_inodes_sb(_nr)_if_idle() is re-implemented by replacing down_read()
with down_read_trylock() because
- If ->s_umount is write locked, then the sb is not idle. That is
  writeback_inodes_sb(_nr)_if_idle() needn't wait for the lock.
- writeback_inodes_sb(_nr)_if_idle() grabs s_umount lock when it want to start
  writeback, it may bring us deadlock problem when doing umount.
  (Ex. Btrfs has such a problem, see the following URL
       http://marc.info/?l=linux-btrfs&m=133540923510561&w=2)

The name of these two functions is cumbersome, so rename them to
try_to_writeback_inodes_sb(_nr).

This idea came from Christoph Hellwig.
Some code is from the patch of Kamal Mostafa.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c    |    4 ++--
 fs/ext4/inode.c           |    2 +-
 fs/fs-writeback.c         |   45 ++++++++++++++++++++-------------------------
 include/linux/writeback.h |    6 +++---
 4 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2b35f8d..deb2577 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3624,8 +3624,8 @@ static int shrink_delalloc(struct btrfs_root *root, u64 to_reclaim,
 		smp_mb();
 		nr_pages = min_t(unsigned long, nr_pages,
 		       root->fs_info->delalloc_bytes >> PAGE_CACHE_SHIFT);
-		writeback_inodes_sb_nr_if_idle(root->fs_info->sb, nr_pages,
-						WB_REASON_FS_FREE_SPACE);
+		try_to_writeback_inodes_sb_nr(root->fs_info->sb, nr_pages,
+					      WB_REASON_FS_FREE_SPACE);
 
 		spin_lock(&space_info->lock);
 		if (reserved > space_info->bytes_may_use)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c77b0bd..2dccb4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2380,7 +2380,7 @@ static int ext4_nonda_switch(struct super_block *sb)
 	 * start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
 	if (free_blocks < 2 * dirty_blocks)
-		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
+		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
 
 	return 0;
 }
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 539f36c..7bcb822 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1230,7 +1230,6 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 }
-EXPORT_SYMBOL(writeback_inodes_sb_nr);
 
 /**
  * writeback_inodes_sb	-	writeback dirty inodes from given super_block
@@ -1248,47 +1247,43 @@ void writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 EXPORT_SYMBOL(writeback_inodes_sb);
 
 /**
- * writeback_inodes_sb_if_idle	-	start writeback if none underway
+ * try_to_writeback_inodes_sb_nr - try to start writeback if none underway
  * @sb: the superblock
- * @reason: reason why some writeback work was initiated
+ * @nr: the number of pages to write
+ * @reason: the reason of writeback
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
+ * Invoke writeback_inodes_sb_nr if no writeback is currently underway.
  * Returns 1 if writeback was started, 0 if not.
  */
-int writeback_inodes_sb_if_idle(struct super_block *sb, enum wb_reason reason)
+int try_to_writeback_inodes_sb_nr(struct super_block *sb,
+				  unsigned long nr,
+				  enum wb_reason reason)
 {
-	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb(sb, reason);
-		up_read(&sb->s_umount);
+	if (writeback_in_progress(sb->s_bdi))
 		return 1;
-	} else
+
+	if (!down_read_trylock(&sb->s_umount))
 		return 0;
+
+	writeback_inodes_sb_nr(sb, nr, reason);
+	up_read(&sb->s_umount);
+	return 1;
 }
-EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
+EXPORT_SYMBOL(try_to_writeback_inodes_sb_nr);
 
 /**
- * writeback_inodes_sb_nr_if_idle	-	start writeback if none underway
+ * try_to_writeback_inodes_sb - try to start writeback if none underway
  * @sb: the superblock
- * @nr: the number of pages to write
  * @reason: reason why some writeback work was initiated
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
+ * Implement by try_to_writeback_inodes_sb_nr()
  * Returns 1 if writeback was started, 0 if not.
  */
-int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
-				   unsigned long nr,
-				   enum wb_reason reason)
+int try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 {
-	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb_nr(sb, nr, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+	return try_to_writeback_inodes_sb_nr(sb, get_nr_dirty_pages(), reason);
 }
-EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
+EXPORT_SYMBOL(try_to_writeback_inodes_sb);
 
 /**
  * sync_inodes_sb	-	sync sb inode pages
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2b84f5..0552d1a 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -86,9 +86,9 @@ int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 							enum wb_reason reason);
-int writeback_inodes_sb_if_idle(struct super_block *, enum wb_reason reason);
-int writeback_inodes_sb_nr_if_idle(struct super_block *, unsigned long nr,
-							enum wb_reason reason);
+int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
+int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
+				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
 long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason);
-- 
1.7.6.5
