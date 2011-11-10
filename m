From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 8/8] ext4: Show the result of io types statistic in sysfs
Date: Thu, 10 Nov 2011 18:34:54 +0800
Message-ID: <1320921294-30321-9-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

io_stats file is created to show the result in sysfs.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/super.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8e27b9c..bc1476d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2532,6 +2532,52 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static inline unsigned long ext4_get_ios_counter(int rw, int flag);
+static ssize_t io_stats_show(struct ext4_attr *a,
+			     struct ext4_sb_info *sbi, char *buf)
+{
+	int i;
+	unsigned long ios_counters[EXT4_IOS_TYPE_END][2] = {{0,},};
+
+	for (i = 0; i < EXT4_IOS_TYPE_END; i++) {
+		ios_counters[i][READ] = ext4_get_ios_counter(READ, i);
+		ios_counters[i][WRITE] = ext4_get_ios_counter(WRITE, i);
+	}
+
+	return snprintf(buf, PAGE_SIZE,
+			"TYPE			READ	WRITE\n"
+			"super block		%8lu %8lu\n"
+			"group descriptor	%8lu %8lu\n"
+			"inode bitmap		%8lu %8lu\n"
+			"block bitmap		%8lu %8lu\n"
+			"inode table		%8lu %8lu\n"
+			"extent block		%8lu %8lu\n"
+			"indirect block		%8lu %8lu\n"
+			"dir entry		%8lu %8lu\n"
+			"extended attribute	%8lu %8lu\n"
+			"regular data		%8lu %8lu\n",
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
 static ssize_t sbi_ui_show(struct ext4_attr *a,
 			   struct ext4_sb_info *sbi, char *buf)
 {
@@ -2575,6 +2621,7 @@ EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
 EXT4_RO_ATTR(extent_cache_hits);
 EXT4_RO_ATTR(extent_cache_misses);
+EXT4_RO_ATTR(io_stats);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
@@ -2601,6 +2648,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(io_stats),
 	NULL,
 };
 
-- 
1.7.4.1

