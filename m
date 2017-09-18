From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/7] ext4: Implement fallocate query support mode
Date: Mon, 18 Sep 2017 17:52:22 +0200
Message-ID: <1505749947-26360-3-git-send-email-lczerner@redhat.com>
References: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1505749947-26360-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Return all fallocate modes supported by ext4 file system. Ext4 does have
a lot of exceptions for inodes with various features enabled so take
that into account as well.

Cc: linux-ext4@vger.kernel.org
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h    | 11 +++++++++++
 fs/ext4/extents.c | 42 ++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e2abe01..6546c2c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -558,6 +558,17 @@ enum {
 };
 
 /*
+ * Supported fallocate modes
+ */
+#define EXT4_FALLOC_SUPPORTED	(FALLOC_FL_KEEP_SIZE |		\
+				 FALLOC_FL_PUNCH_HOLE |		\
+				 FALLOC_FL_COLLAPSE_RANGE |	\
+				 FALLOC_FL_ZERO_RANGE |		\
+				 FALLOC_FL_INSERT_RANGE |	\
+				 FALLOC_FL_QUERY_SUPPORT |	\
+				 FALLOC_FL_PREALLOC_RANGE)
+
+/*
  * Flags used by ext4_map_blocks()
  */
 	/* Allocate any needed blocks and/or convert an unwritten
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 97f0fd0..91071b3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4905,7 +4905,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	loff_t new_size = 0;
 	unsigned int max_blocks;
 	int ret = 0;
-	int flags;
+	int flags = 0;
 	ext4_lblk_t lblk;
 	unsigned int blkbits = inode->i_blkbits;
 
@@ -4919,17 +4919,27 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * leave it disabled for encrypted inodes for now.  This is a
 	 * bug we should fix....
 	 */
-	if (ext4_encrypted_inode(inode) &&
-	    (mode & (FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_INSERT_RANGE |
-		     FALLOC_FL_ZERO_RANGE)))
-		return -EOPNOTSUPP;
+	if (ext4_encrypted_inode(inode)) {
+		/* Modes not supported on encrypted indoes */
+		flags |= (FALLOC_FL_COLLAPSE_RANGE |
+			  FALLOC_FL_INSERT_RANGE |
+			  FALLOC_FL_ZERO_RANGE);
+	}
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
+		/* Modes not supported on non-extent inodes */
+		flags |= (FALLOC_FL_COLLAPSE_RANGE |
+			  FALLOC_FL_INSERT_RANGE |
+			  FALLOC_FL_ZERO_RANGE |
+			  FALLOC_FL_PREALLOC_RANGE);
+	}
 
 	/* Return error if mode is not supported */
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |
-		     FALLOC_FL_INSERT_RANGE))
+	if (mode & ~(EXT4_FALLOC_SUPPORTED & ~flags))
 		return -EOPNOTSUPP;
 
+	if (mode & FALLOC_FL_QUERY_SUPPORT)
+		return EXT4_FALLOC_SUPPORTED & ~flags;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(inode, offset, len);
 
@@ -5449,14 +5459,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	loff_t new_size, ioffset;
 	int ret;
 
-	/*
-	 * We need to test this early because xfstests assumes that a
-	 * collapse range of (0, 1) will return EOPNOTSUPP if the file
-	 * system does not support collapse range.
-	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		return -EOPNOTSUPP;
-
 	/* Collapse range works only on fs block size aligned offsets. */
 	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
 	    len & (EXT4_CLUSTER_SIZE(sb) - 1))
@@ -5596,14 +5598,6 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 	int ret = 0, depth, split_flag = 0;
 	loff_t ioffset;
 
-	/*
-	 * We need to test this early because xfstests assumes that an
-	 * insert range of (0, 1) will return EOPNOTSUPP if the file
-	 * system does not support insert range.
-	 */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		return -EOPNOTSUPP;
-
 	/* Insert range works only on fs block size aligned offsets. */
 	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
 			len & (EXT4_CLUSTER_SIZE(sb) - 1))
-- 
2.7.5
