From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/5] ext4: add data structure and functions for io statistic
Date: Mon, 31 Oct 2011 17:43:00 +0800
Message-ID: <1320054184-14329-2-git-send-email-wenqing.lz@taobao.com>
References: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64293 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 05:41:54 -0400
In-Reply-To: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

This patch adds two data structures and related functions for
counting different io types. The per-cpu counters are added for ios which
are issued to the disk.

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/ext4.h     |   43 ++++++++++++++++++++++++++++
 fs/ext4/super.c    |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    8 +++++
 3 files changed, 131 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b7d7bd0..b0c51da 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1080,6 +1080,31 @@ struct ext4_super_block {
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
 /*
+ * ext4 io statistics flags
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
+struct ext4_ios {
+	const char *function;
+	unsigned int line;
+	int rw;
+	int flag;
+	int count;
+};
+
+/*
  * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
@@ -1248,6 +1273,11 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 		 ino <= le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count));
 }
 
+static inline unsigned ext4_blocks_per_page(struct inode *inode)
+{
+	return PAGE_CACHE_SIZE >> inode->i_blkbits;
+}
+
 /*
  * Inode dynamic state flags
  */
@@ -1875,6 +1905,19 @@ extern int ext4_group_extend(struct super_block *sb,
 				ext4_fsblk_t n_blocks_count);
 
 /* super.c */
+extern void __ext4_io_stat(const char *, unsigned int, int, int, unsigned long);
+extern void ext4_io_stat_read(void *ios);
+extern void ext4_io_stat_write(handle_t *, struct buffer_head *,
+			       const char *, unsigned int,
+			       int, unsigned long);
+extern void __ext4_init_ios(struct ios *ios, struct ext4_ios *ext4_ios,
+			    const char *function, unsigned int line,
+			    int rw, int flag, unsigned long count,
+			    void (*io_stat)(void *));
+#define ext4_init_ios(ios, ext4_ios, flag) \
+	__ext4_init_ios(ios, ext4_ios, __func__, __LINE__, \
+			READ, flag, 1, ext4_io_stat_read)
+
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 44d0c8d..684f98a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4851,6 +4851,86 @@ out:
 
 #endif
 
+#define EXT4_IOS_DEBUG
+
+#ifdef EXT4_IOS_DEBUG
+#define ext4_ios_debug(f, a...) trace_printk(f, ##a)
+#else
+#define ext4_ios_debug(f, a...)
+#endif
+
+static DEFINE_PER_CPU(unsigned long [EXT4_IOS_TYPE_END][2], ext4_ios_counters);
+
+void ext4_io_stat_write(handle_t *handle, struct buffer_head *bh,
+			const char *function, unsigned int line,
+			int flag, unsigned long count)
+{
+	if (!bh)
+		goto write;
+
+	if (!handle || !ext4_handle_valid(handle)) {
+		if (buffer_dirty(bh))
+			return;
+	} else {
+		if (buffer_jbddirty(bh))
+			return;
+	}
+write:
+	__ext4_io_stat(function, line, WRITE, flag, count);
+}
+
+static inline unsigned long ext4_get_ios_counter(int rw, int flag)
+{
+	unsigned long sum = 0;
+	int i;
+
+	for_each_possible_cpu(i)
+		sum += per_cpu(ext4_ios_counters[flag][rw], i);
+
+	return sum;
+}
+
+void __ext4_io_stat(const char *function, unsigned int line,
+		    int rw, int flag, unsigned long count)
+{
+	const char *rwstr = rw ? "write" : "read";
+	const char *typestr[EXT4_IOS_TYPE_END] = {
+		"super block", "group descriptor",
+		"inode bitmap", "block bitmap",
+		"inode table", "extent block",
+		"indirect block", "dir entry",
+		"extended attributes", "regular data"
+	};
+
+	BUG_ON(flag < 0 || flag >= EXT4_IOS_TYPE_END);
+	this_cpu_add(ext4_ios_counters[flag][rw], count);
+
+	ext4_ios_debug("%s:%d - %s %s - %ld block" " - total %s %ld block\n",
+		       function, line, rwstr, typestr[flag], count, rwstr,
+		       ext4_get_ios_counter(rw, flag));
+}
+
+void ext4_io_stat_read(void *data)
+{
+	struct ext4_ios *ext4_ios = data;
+	return __ext4_io_stat(ext4_ios->function, ext4_ios->line,
+			      ext4_ios->rw, ext4_ios->flag, ext4_ios->count);
+}
+
+void __ext4_init_ios(struct ios *ios, struct ext4_ios *ext4_ios,
+		     const char *function, unsigned int line,
+		     int rw, int flag, unsigned long count,
+		     void (*io_stat)(void *))
+{
+	ext4_ios->function = function;
+	ext4_ios->line = line;
+	ext4_ios->rw = rw;
+	ext4_ios->flag = flag;
+	ext4_ios->count = count;
+	ios->data = ext4_ios;
+	ios->io_stat = io_stat;
+}
+
 static struct dentry *ext4_mount(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 14493a2..49b3c24 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2676,5 +2676,13 @@ static inline void inode_has_no_xattr(struct inode *inode)
 		inode->i_flags |= S_NOSEC;
 }
 
+/*
+ * IO statistics
+ */
+struct ios {
+	void *data;
+	void (*io_stat)(void *data);
+};
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_FS_H */
-- 
1.7.4.1

