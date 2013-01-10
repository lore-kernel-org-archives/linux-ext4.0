From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V2] vfs: re-implement writeback_inodes_sb(_nr)_if_idle() and
 rename them
Date: Thu, 10 Jan 2013 13:47:57 +0800
Message-ID: <50EE560D.6040604@cn.fujitsu.com>
References: <50D2E3DF.4010105@cn.fujitsu.com> <20121228143338.GW14116@twin.jikos.cz>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dsterba@suse.cz, Christoph Hellwig <hch@infradead.org>,
	Kamal Mostafa <kamal@canonical.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Linux Fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3AJFrY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Jan 2013 00:47:24 -0500
In-Reply-To: <20121228143338.GW14116@twin.jikos.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

writeback_inodes_sb(_nr)_if_idle() is re-implemented by replacing down_read()
with down_read_trylock() because
- If ->s_umount is write locked, then the sb is not idle. That is
  writeback_inodes_sb(_nr)_if_idle() needn't wait for the lock.
- writeback_inodes_sb(_nr)_if_idle() grabs s_umount lock when it want to start
  writeback, it may bring us deadlock problem when doing umount. In order to
  fix the problem, ext4 and btrfs implemented their own writeback functions
  instead of writeback_inodes_sb(_nr)_if_idle(), but it introduced the redundant
  code, it is better to implement a new writeback_inodes_sb(_nr)_if_idle().

The name of these two functions is cumbersome, so rename them to
try_to_writeback_inodes_sb(_nr).

This idea came from Christoph Hellwig.
Some code is from the patch of Kamal Mostafa.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- do not remove EXPORT_SYMBOL of writeback_inodes_sb_br()
---
 fs/btrfs/extent-tree.c    | 20 +++-----------------
 fs/ext4/inode.c           |  8 ++------
 fs/fs-writeback.c         | 44 ++++++++++++++++++++------------------------
 include/linux/writeback.h |  6 +++---
 4 files changed, 28 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 521e9d4..f31abb1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3689,20 +3689,6 @@ static int can_overcommit(struct btrfs_root *root,
 	return 0;
 }
 
-static int writeback_inodes_sb_nr_if_idle_safe(struct super_block *sb,
-					       unsigned long nr_pages,
-					       enum wb_reason reason)
-{
-	if (!writeback_in_progress(sb->s_bdi) &&
-	    down_read_trylock(&sb->s_umount)) {
-		writeback_inodes_sb_nr(sb, nr_pages, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	}
-
-	return 0;
-}
-
 /*
  * shrink metadata reservation for delalloc
  */
@@ -3735,9 +3721,9 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
-		writeback_inodes_sb_nr_if_idle_safe(root->fs_info->sb,
-						    nr_pages,
-						    WB_REASON_FS_FREE_SPACE);
+		try_to_writeback_inodes_sb_nr(root->fs_info->sb,
+					      nr_pages,
+					      WB_REASON_FS_FREE_SPACE);
 
 		/*
 		 * We need to wait for the async pages to actually start before
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cbfe13b..5f6eef7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2512,12 +2512,8 @@ static int ext4_nonda_switch(struct super_block *sb)
 	/*
 	 * Start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
-	if (dirty_blocks && (free_blocks < 2 * dirty_blocks) &&
-	    !writeback_in_progress(sb->s_bdi) &&
-	    down_read_trylock(&sb->s_umount)) {
-		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
-		up_read(&sb->s_umount);
-	}
+	if (dirty_blocks && (free_blocks < 2 * dirty_blocks))
+		try_to_writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
 
 	if (2 * free_blocks < 3 * dirty_blocks ||
 		free_blocks < (dirty_blocks + EXT4_FREECLUSTERS_WATERMARK)) {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 310972b..ad3cc46 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1332,47 +1332,43 @@ void writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
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
index b82a83a..9a9367c 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -87,9 +87,9 @@ int inode_wait(void *);
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
1.7.11.7

