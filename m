From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 5/5] ext4: io stat show result in sysfs
Date: Mon, 31 Oct 2011 17:43:04 +0800
Message-ID: <1320054184-14329-6-git-send-email-wenqing.lz@taobao.com>
References: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Cc: Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51255 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJmE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 05:42:04 -0400
In-Reply-To: <1320054184-14329-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

Show statistic results in sysfs

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/super.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 93ec9a7..049d06c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2510,6 +2510,52 @@ static ssize_t inode_readahead_blks_store(struct ext4_attr *a,
 	return count;
 }
 
+static inline unsigned long ext4_get_ios_counter(int rw, int flag);
+static ssize_t io_stats_show(struct ext4_attr *a,
+			     struct ext4_sb_info *sbi, char *buf)
+{
+	int i = 0;
+	unsigned long ios_counters[EXT4_IOS_TYPE_END][2] = {{0,},};
+
+	for (i = 0; i < EXT4_IOS_TYPE_END; i++) {
+		ios_counters[i][READ] = ext4_get_ios_counter(READ, i);
+		ios_counters[i][WRITE] = ext4_get_ios_counter(WRITE, i);
+	}
+
+	return snprintf(buf, PAGE_SIZE,
+			"TYPE                     READ    WRITE\n"
+			"super block        %8lu %8lu\n"
+			"group descriptor   %8lu %8lu\n"
+			"inode bitmap       %8lu %8lu\n"
+			"block bitmap       %8lu %8lu\n"
+			"inode table        %8lu %8lu\n"
+			"extent block       %8lu %8lu\n"
+			"indirect block     %8lu %8lu\n"
+			"dir entry          %8lu %8lu\n"
+			"extended attribute %8lu %8lu\n"
+			"regular data       %8lu %8lu\n",
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
@@ -2553,6 +2599,7 @@ EXT4_RO_ATTR(session_write_kbytes);
 EXT4_RO_ATTR(lifetime_write_kbytes);
 EXT4_RO_ATTR(extent_cache_hits);
 EXT4_RO_ATTR(extent_cache_misses);
+EXT4_RO_ATTR(io_stats);
 EXT4_ATTR_OFFSET(inode_readahead_blks, 0644, sbi_ui_show,
 		 inode_readahead_blks_store, s_inode_readahead_blks);
 EXT4_RW_ATTR_SBI_UI(inode_goal, s_inode_goal);
@@ -2579,6 +2626,7 @@ static struct attribute *ext4_attrs[] = {
 	ATTR_LIST(mb_stream_req),
 	ATTR_LIST(mb_group_prealloc),
 	ATTR_LIST(max_writeback_mb_bump),
+	ATTR_LIST(io_stats),
 	NULL,
 };
 
-- 
1.7.4.1

