From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 2/8] ext4: Add new data structures and related functions to count io types
Date: Thu, 10 Nov 2011 18:34:48 +0800
Message-ID: <1320921294-30321-3-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1KJKdt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:33:49 -0500
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

A per-cpu counter is defined to store io types in ext4. We define 10 io types
in ext4, which includes 9 metadata types and 1 data type. Read and write
operations are counted separately. When checks 'Issue' flag, filesystem needs
to lock buffer.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/ext4.h  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c |   19 +++++++++++++++++++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5b0e26a..39a1495 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1108,6 +1108,23 @@ struct ext4_super_block {
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
 /*
+ * ext4 io types
+ */
+enum {
+	EXT4_IOS_SUPER_BLOCK = 0,
+	EXT4_IOS_GROUP_DESC,
+	EXT4_IOS_INODE_BITMAP,
+	EXT4_IOS_BLOCK_BITMAP,
+	EXT4_IOS_INODE_TABLE,
+	EXT4_IOS_EXTENT_BLOCK,
+	EXT4_IOS_INDIRECT_BLOCK,
+	EXT4_IOS_DIR_ENTRY,
+	EXT4_IOS_EXTENDED_ATTR,
+	EXT4_IOS_REGULAR_DATA,
+	EXT4_IOS_TYPE_END,
+};
+
+/*
  * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
@@ -1284,6 +1301,11 @@ static inline void ext4_set_io_unwritten_flag(struct inode *inode,
 	}
 }
 
+static inline unsigned ext4_blocks_per_page(struct inode *inode)
+{
+	return PAGE_CACHE_SIZE >> inode->i_blkbits;
+}
+
 /*
  * Inode dynamic state flags
  */
@@ -1926,6 +1948,37 @@ extern int ext4_group_extend(struct super_block *sb,
 				ext4_fsblk_t n_blocks_count);
 
 /* super.c */
+extern void __ext4_io_stat(int, int, unsigned long);
+#define ext4_ios_read(bh, type, count)					\
+	do {								\
+		if (!bh)						\
+			break;						\
+		lock_buffer(bh);					\
+		if (buffer_issue(bh)) {					\
+			clear_buffer_issue(bh);				\
+			__ext4_io_stat(READ, type, count);		\
+		}							\
+		unlock_buffer(bh);					\
+	} while (0)
+#define ext4_ios_write(handle, bh, type, count)				\
+	do {								\
+		if (!bh) {						\
+			__ext4_io_stat(WRITE, type, count);		\
+			break;						\
+		}							\
+		if (!handle || !ext4_handle_valid(handle)) {		\
+			if (buffer_dirty(bh))				\
+				break;					\
+		} else {						\
+			if (buffer_jbddirty(bh))			\
+				break;					\
+		}							\
+		__ext4_io_stat(WRITE, type, count);			\
+	} while(0)
+#define ext4_ios_read_one(bh, type)	ext4_ios_read(bh, type, 1)
+#define ext4_ios_write_one(handle, bh, type) \
+	ext4_ios_write(handle, bh, type, 1)
+
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9953d80..3bec50c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4940,6 +4940,25 @@ out:
 
 #endif
 
+static DEFINE_PER_CPU(unsigned long [EXT4_IOS_TYPE_END][2], ext4_ios_counters);
+
+static inline unsigned long ext4_get_ios_counter(int rw, int type)
+{
+	unsigned long sum = 0;
+	int i;
+
+	for_each_possible_cpu(i)
+		sum += per_cpu(ext4_ios_counters[type][rw], i);
+
+	return sum;
+}
+
+void __ext4_io_stat(int rw, int type, unsigned long count)
+{
+	BUG_ON(type < 0 || type >= EXT4_IOS_TYPE_END);
+	this_cpu_add(ext4_ios_counters[type][rw], count);
+}
+
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data)
 {
-- 
1.7.4.1

