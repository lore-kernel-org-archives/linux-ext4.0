From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 14/30] ext4: snapshot block operations
Date: Mon,  9 May 2011 19:41:32 +0300
Message-ID: <1304959308-11122-15-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1EIQnu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:43:50 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:43:49 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
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
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8f59322..c7fd33e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -557,6 +557,16 @@ struct ext4_new_group_data {
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
index e0fef0d..79b6594 100644
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
index 425dabb..ba66545 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1600,8 +1600,8 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 
 	map.m_lblk = block;
 	map.m_len = 1;
-	err = ext4_map_blocks(handle, inode, &map,
-			      create ? EXT4_GET_BLOCKS_CREATE : 0);
+	/* passing SNAPMAP flags on create argument */
+	err = ext4_map_blocks(handle, inode, &map, create);
 
 	if (err < 0)
 		*errp = err;
-- 
1.7.0.4

