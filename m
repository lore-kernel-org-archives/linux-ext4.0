From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Add new ext4 trim tracepoints
Date: Wed,  2 Feb 2011 00:56:54 +0800
Message-ID: <1296579414-4017-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:47691 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752469Ab1BAQ5R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Feb 2011 11:57:17 -0500
Received: from [111.193.1.108] (helo=taoma-linux.localdomain6)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1PkJXW-00045Q-Nh
	for linux-ext4@vger.kernel.org; Tue, 01 Feb 2011 09:57:15 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Add ext4_trim_extent and ext4_trim_all_free.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c           |    4 +++
 include/trace/events/ext4.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 02cff4a..fb5f765 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4715,6 +4715,8 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 	struct ext4_free_extent ex;
 	int ret = 0;
 
+	trace_ext4_trim_extent(sb, group, start, count);
+
 	assert_spin_locked(ext4_group_lock_ptr(sb, group));
 
 	ex.fe_start = start;
@@ -4767,6 +4769,8 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 	group = e4b->bd_group;
 	start = (e4b->bd_info->bb_first_free > start) ?
 		e4b->bd_info->bb_first_free : start;
+
+	trace_ext4_trim_all_free(sb, group, start, max);
 	ext4_lock_group(sb, group);
 
 	while (start < max) {
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index e5e345f..b8e6aeb 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1166,6 +1166,55 @@ DEFINE_EVENT(ext4__bitmap_load, ext4_mb_buddy_bitmap_load,
 	TP_ARGS(sb, group)
 );
 
+DECLARE_EVENT_CLASS(ext4__trim,
+	TP_PROTO(struct super_block *sb,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len),
+
+	TP_ARGS(sb, group, start, len),
+
+	TP_STRUCT__entry(
+		__field(	int,	dev_major               )
+		__field(	int,	dev_minor               )
+		__field(	__u32, 	group			)
+		__field(	int,	start			)
+		__field(	int,	len			)
+	),
+
+	TP_fast_assign(
+		__entry->dev_major	= MAJOR(sb->s_dev);
+		__entry->dev_minor	= MINOR(sb->s_dev);
+		__entry->group		= group;
+		__entry->start		= start;
+		__entry->len		= len;
+	),
+
+	TP_printk("dev %d,%d group %u, start %d, len %d",
+		  __entry->dev_major, __entry->dev_minor,
+		  __entry->group, __entry->start, __entry->len)
+);
+
+DEFINE_EVENT(ext4__trim, ext4_trim_extent,
+
+	TP_PROTO(struct super_block *sb,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len),
+
+	TP_ARGS(sb, group, start, len)
+);
+
+DEFINE_EVENT(ext4__trim, ext4_trim_all_free,
+
+	TP_PROTO(struct super_block *sb,
+		 ext4_group_t group,
+		 ext4_grpblk_t start,
+		 ext4_grpblk_t len),
+
+	TP_ARGS(sb, group, start, len)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
1.6.3.GIT

