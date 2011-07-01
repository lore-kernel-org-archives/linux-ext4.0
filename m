From: Tao Ma <tm@tao.ma>
Subject: [PATCH 3/5] ext4: Add new ext4 trim tracepoints
Date: Fri,  1 Jul 2011 23:27:54 +0800
Message-ID: <1309534076-2784-3-git-send-email-tm@tao.ma>
References: <4E0DE63A.7030103@tao.ma>
 <1309534076-2784-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:49412 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751700Ab1GAPai (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jul 2011 11:30:38 -0400
In-Reply-To: <1309534076-2784-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Add ext4_trim_extent and ext4_trim_all_free.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c           |    4 +++
 include/trace/events/ext4.h |   49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 3bd06ca..cf42fdd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4782,6 +4782,8 @@ static void ext4_trim_extent(struct super_block *sb, int start, int count,
 {
 	struct ext4_free_extent ex;
 
+	trace_ext4_trim_extent(sb, group, start, count);
+
 	assert_spin_locked(ext4_group_lock_ptr(sb, group));
 
 	ex.fe_start = start;
@@ -4827,6 +4829,8 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 	struct ext4_buddy e4b;
 	int ret;
 
+	trace_ext4_trim_all_free(sb, group, start, max);
+
 	ret = ext4_mb_load_buddy(sb, group, &e4b);
 	if (ret) {
 		ext4_error(sb, "Error in loading buddy "
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 5ce2b2f..c5a517c 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1520,6 +1520,55 @@ TRACE_EVENT(ext4_load_inode,
 		  (unsigned long) __entry->ino)
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
+		__field(	int,	dev_major		)
+		__field(	int,	dev_minor		)
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
1.7.4

