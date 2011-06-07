From: amir73il@users.sourceforge.net
Subject: [PATCH v1 14/36] ext4: snapshot block operations
Date: Tue,  7 Jun 2011 18:07:41 +0300
Message-ID: <1307459283-22130-15-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPJe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:34 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:33 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Core API of special snapshot file block operations.
The argument @create to the function ext4_getblk()
is re-interpreted as a snapshot block command argument.  The old
argument values 0(=read) and 1(=create) preserve the original
behavior of the function.  The bit field h_cowing in the current
transaction handle is used to prevent COW recursions.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h      |   10 ++++++++++
 fs/ext4/ext4_jbd2.h |    3 +++
 fs/ext4/inode.c     |    4 ++--
 fs/ext4/snapshot.c  |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot.h  |   37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 81e6add..5564111 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -544,6 +544,16 @@ struct ext4_new_group_data {
 	 * if EXT4_GET_BLOCKS_CREATE is not set, return REMAP flags.
 	 */
 #define EXT4_GET_BLOCKS_MOVE_ON_WRITE		0x0100
+/*
+ * snapshot_map_blocks() flags passed to ext4_map_blocks() for mapping
+ * blocks to snapshot.
+ */
+	/* handle COW race conditions */
+#define EXT4_GET_BLOCKS_COW			0x200
+	/* allocate only indirect blocks */
+#define EXT4_GET_BLOCKS_MOVE			0x400
+	/* bypass journal and sync allocated indirect blocks directly to disk */
+#define EXT4_GET_BLOCKS_SYNC			0x800
 
 /*
  * Flags used by ext4_free_blocks
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 4d57fcb..4af0bb5 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -173,6 +173,9 @@ int __ext4_handle_dirty_super(const char *where, unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))
 
+#define trace_cow_add(handle, name, num)
+#define trace_cow_inc(handle, name)
+
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e64cf64..410bc8b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1603,8 +1603,8 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 
 	map.m_lblk = block;
 	map.m_len = 1;
-	err = ext4_map_blocks(handle, inode, &map,
-			      create ? EXT4_GET_BLOCKS_CREATE : 0);
+	/* passing SNAPMAP flags on create argument */
+	err = ext4_map_blocks(handle, inode, &map, create);
 
 	if (err < 0)
 		*errp = err;
diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index e8db8ca..ef84551 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -16,3 +16,46 @@
 #include "snapshot.h"
 #include "ext4.h"
 #include "mballoc.h"
+
+#define snapshot_debug_hl(n, f, a...) snapshot_debug_l(n, handle ? \
+					IS_COWING(handle) : 0, f, ## a)
+
+/*
+ * ext4_snapshot_map_blocks() - helper function for
+ * ext4_snapshot_test_and_cow().  Test if blocks are mapped in snapshot file.
+ * If @block is not mapped and if @cmd is non zero, try to allocate @maxblocks.
+ * Also used by ext4_snapshot_create() to pre-allocate snapshot blocks.
+ *
+ * Return values:
+ * > 0 - no. of mapped blocks in snapshot file
+ * = 0 - @block is not mapped in snapshot file
+ * < 0 - error
+ */
+int ext4_snapshot_map_blocks(handle_t *handle, struct inode *inode,
+			      ext4_snapblk_t block, unsigned long maxblocks,
+			      ext4_fsblk_t *mapped, int cmd)
+{
+	int err;
+	struct ext4_map_blocks map;
+
+	map.m_lblk = SNAPSHOT_IBLOCK(block);
+	map.m_len = maxblocks;
+
+	err = ext4_map_blocks(handle, inode, &map, cmd);
+	/*
+	 * ext4_get_blocks_handle() returns number of blocks
+	 * mapped. 0 in case of a HOLE.
+	 */
+	if (mapped && err > 0)
+		*mapped = map.m_pblk;
+
+	snapshot_debug_hl(4, "snapshot (%u) map_blocks "
+			"[%lld/%lld] = [%lld/%lld] "
+			"cmd=%d, maxblocks=%lu, mapped=%d\n",
+			inode->i_generation,
+			SNAPSHOT_BLOCK_TUPLE(block),
+			SNAPSHOT_BLOCK_TUPLE(map.m_pblk),
+			cmd, maxblocks, err);
+	return err;
+}
+
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 19e3416..ea87a5a 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -137,6 +137,43 @@ static inline int EXT4_SNAPSHOTS(struct super_block *sb)
 			EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT);
 }
 
+/*
+ * snapshot_map_blocks() command flags passed to ext4_map_blocks() on its
+ * @flags argument. The higher bits are used for mapping snapshot blocks.
+ */
+/* original meaning - only check if blocks are mapped */
+#define SNAPMAP_READ	0
+/* original meaning - allocate missing blocks and indirect blocks */
+#define SNAPMAP_WRITE	EXT4_GET_BLOCKS_CREATE
+/* creating COWed block */
+#define SNAPMAP_COW	(SNAPMAP_WRITE|EXT4_GET_BLOCKS_COW)
+/* moving blocks to snapshot */
+#define SNAPMAP_MOVE	(SNAPMAP_WRITE|EXT4_GET_BLOCKS_MOVE)
+ /* creating COW bitmap - handle COW races and bypass journal */
+#define SNAPMAP_BITMAP	(SNAPMAP_COW|EXT4_GET_BLOCKS_SYNC)
+
+/* test special cases when mapping snapshot blocks */
+#define SNAPMAP_ISCOW(cmd)	(unlikely((cmd) & EXT4_GET_BLOCKS_COW))
+#define SNAPMAP_ISMOVE(cmd)	(unlikely((cmd) & EXT4_GET_BLOCKS_MOVE))
+#define SNAPMAP_ISSYNC(cmd)	(unlikely((cmd) & EXT4_GET_BLOCKS_SYNC))
+
+#define IS_COWING(handle)	(unlikely((handle)->h_cowing))
+
+/* snapshot.c */
+
+/* helper functions for ext4_snapshot_create() */
+extern int ext4_snapshot_map_blocks(handle_t *handle, struct inode *inode,
+				     ext4_snapblk_t block,
+				     unsigned long maxblocks,
+				     ext4_fsblk_t *mapped, int cmd);
+/* helper function for ext4_snapshot_take() */
+extern void ext4_snapshot_copy_buffer(struct buffer_head *sbh,
+					   struct buffer_head *bh,
+					   const char *mask);
+/* helper function for ext4_snapshot_get_block() */
+extern int ext4_snapshot_read_block_bitmap(struct super_block *sb,
+		unsigned int block_group, struct buffer_head *bitmap_bh);
+
 #define ext4_snapshot_cow(handle, inode, block, bh, cow) 0
 
 #define ext4_snapshot_move(handle, inode, block, pcount, move) (0)
-- 
1.7.4.1

