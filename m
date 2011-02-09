From: Tao Ma <tm@tao.ma>
Subject: [PATCH 3/4] ext4: Add new ext4 trim tracepoints
Date: Wed,  9 Feb 2011 13:57:27 +0800
Message-ID: <1297231048-3458-3-git-send-email-tm@tao.ma>
References: <4D522B9B.5070707@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:59318 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750926Ab1BIF6Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 00:58:16 -0500
Received: from [114.251.86.0] (helo=taoma-linux.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <tm@tao.ma>)
	id 1Pn34A-0005it-CA
	for linux-ext4@vger.kernel.org; Tue, 08 Feb 2011 22:58:15 -0700
In-Reply-To: <4D522B9B.5070707@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Add ext4_trim_extent and ext4_trim_all_free.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c           |    5 ++++
 include/trace/events/ext4.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 806adb2..4eadac8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4715,6 +4715,8 @@ static int ext4_trim_extent(struct super_block *sb, int start, int count,
 	struct ext4_free_extent ex;
 	int ret = 0;
 
+	trace_ext4_trim_extent(sb, group, start, count);
+
 	assert_spin_locked(ext4_group_lock_ptr(sb, group));
 
 	ex.fe_start = start;
@@ -4767,8 +4769,11 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
 	group = e4b->bd_group;
 	start = (e4b->bd_info->bb_first_free > start) ?
 		e4b->bd_info->bb_first_free : start;
+
 	ext4_lock_group(sb, group);
 
+	trace_ext4_trim_all_free(sb, group, start, max);
+
 	while (start < max) {
 		start = mb_find_next_zero_bit(bitmap, max, start);
 		if (start >= max)
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

