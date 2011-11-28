From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 8/8] ext4: show the result of io types accouting
Date: Mon, 28 Nov 2011 20:20:28 +0800
Message-ID: <1322482828-5529-8-git-send-email-wenqing.lz@taobao.com>
References: <1322482392-5346-1-git-send-email-wenqing.lz@taobao.com>
 <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab1K1MSz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:18:55 -0500
In-Reply-To: <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We create a io_stats file in sysfs to show the result. Meanwhile, io_stats_reset
is used to reset the s_ios_counters.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h  |    2 +
 fs/ext4/super.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 617be9f..35f4d02 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1107,6 +1107,8 @@ struct ext4_super_block {
 #define EXT4_MF_MNTDIR_SAMPLED	0x0001
 #define EXT4_MF_FS_ABORTED	0x0002	/* Fatal error detected */
 
+#define EXT4_IOS_VERSION	"1.0"
+
 /*
  * ext4 io types
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9f708ba..eb0f64f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2538,6 +2538,69 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static inline u64 ext4_get_ios_counter(struct ext4_sb_info *sbi,
+		int rw, int flag);
+static inline void ext4_reset_ios_counter(struct ext4_sb_info *sbi);
+static ssize_t io_stats_show(struct ext4_attr *a,
+		struct ext4_sb_info *sbi, char *buf)
+{
+	int i;
+	unsigned long ios_counters[EXT4_IOS_TYPE_END][2] = {{0,},};
+
+	for (i = 0; i < EXT4_IOS_TYPE_END; i++) {
+		ios_counters[i][READ] = ext4_get_ios_counter(sbi, READ, i);
+		ios_counters[i][WRITE] = ext4_get_ios_counter(sbi, WRITE, i);
+	}
+
+	return snprintf(buf, PAGE_SIZE,
+			"Version: %s\n"
+			"TYPE                   READ    WRITE\n"
+			"super block            %8lu %8lu\n"
+			"group descriptor       %8lu %8lu\n"
+			"inode bitmap           %8lu %8lu\n"
+			"block bitmap           %8lu %8lu\n"
+			"inode table            %8lu %8lu\n"
+			"extent block           %8lu %8lu\n"
+			"indirect block         %8lu %8lu\n"
+			"dir entry              %8lu %8lu\n"
+			"extended attribute     %8lu %8lu\n"
+			"regular data           %8lu %8lu\n",
+			EXT4_IOS_VERSION,
+			ios_counters[EXT4_IOS_SUPER_BLOCK][READ],
+			ios_counters[EXT4_IOS_SUPER_BLOCK][WRITE],
+			ios_counters[EXT4_IOS_GROUP_DESC][READ],
+			ios_counters[EXT4_IOS_GROUP_DESC][WRITE],
+			ios_counters[EXT4_IOS_INODE_BITMAP][READ],
+			ios_counters[EXT4_IOS_INODE_BITMAP][WRITE],
+			ios_counters[EXT4_IOS_BLOCK_BITMAP][READ],
+			ios_counters[EXT4_IOS_BLOCK_BITMAP][WRITE],
+			ios_counters[EXT4_IOS_INODE_TABLE][READ],
+			ios_counters[EXT4_IOS_INODE_TABLE][WRITE],
+			ios_counters[EXT4_IOS_EXTENT_BLOCK][READ],
+			ios_counters[EXT4_IOS_EXTENT_BLOCK][WRITE],
+			ios_counters[EXT4_IOS_INDIRECT_BLOCK][READ],
+			ios_counters[EXT4_IOS_INDIRECT_BLOCK][WRITE],
+			ios_counters[EXT4_IOS_DIR_ENTRY][READ],
+			ios_counters[EXT4_IOS_DIR_ENTRY][WRITE],
+			ios_counters[EXT4_IOS_EXTENDED_ATTR][READ],
+			ios_counters[EXT4_IOS_EXTENDED_ATTR][WRITE],
+			ios_counters[EXT4_IOS_REGULAR_DATA][READ],
+			ios_counters[EXT4_IOS_REGULAR_DATA][WRITE]);
+}
+
+static ssize_t io_stats_reset_store(struct ext4_attr *a,
+				    struct ext4_sb_info *sbi,
+				    const char *buf, size_t count)
+{
+	unsigned long t;
+
+	if (parse_strtoul(buf, 0xffffffff, &t))
+		return -EINVAL;
+	if (t == 1)
+		ext4_reset_ios_counter(sbi);
+	return count;
+}
+
 static ssize_t sbi_ui_show(struct ext4_attr *a,
 			   struct ext4_sb_info *sbi, char *buf)
 {
@@ -2571,6 +2634,7 @@ static struct ext4_attr ext4_attr_##name = __ATTR(name, mode, show, store)
 
 #define EXT4_INFO_ATTR(name) EXT4_ATTR(name, 0444, NULL, NULL)
 #define EXT4_RO_ATTR(name) EXT4_ATTR(name, 0444, name##_show, NULL)
+#define EXT4_WO_ATTR(name) EXT4_ATTR(name, 0222, NULL, name##_store)
 #define EXT4_RW_ATTR(name) EXT4_ATTR(name, 0644, name##_show, name##_store)
 #define EXT4_RW_ATTR_SBI_UI(name, elname)	\
 	EXT4_ATTR_OFFSET(name, 0644, sbi_ui_show, sbi_ui_store, elname)
@@ -2581,6 +2645,8 @@ EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
 EXT4_RO_ATTR(extent_cache_hits);
 EXT4_RO_ATTR(extent_cache_misses);
+EXT4_RO_ATTR(io_stats);
+EXT4_WO_ATTR(io_stats_reset);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
@@ -2607,6 +2673,8 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(io_stats),
+	ATTR_LIST(io_stats_reset),
 	NULL,
 };
 
-- 
1.7.4.1

