From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH v2 1/4] ext4: improve extents status tree trace point
Date: Wed, 16 Apr 2014 19:30:27 +0800
Message-ID: <1397647830-24444-2-git-send-email-wenqing.lz@taobao.com>
References: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33964 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbaDPLYU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 07:24:20 -0400
Received: by mail-pa0-f52.google.com with SMTP id rd3so10815762pab.39
        for <linux-ext4@vger.kernel.org>; Wed, 16 Apr 2014 04:24:19 -0700 (PDT)
In-Reply-To: <1397647830-24444-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit improves the trace point of extents status tree.  We rename
trace_ext4_es_shrink_enter in ext4_es_count() because it is also used
in ext4_es_scan() and we can not identify them from the result.

Further this commit fixes a variable name in trace point in order to
keep consistency with others.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents_status.c    |    6 +++---
 include/trace/events/ext4.h |   28 ++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 0a014a7..090e69a 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1015,7 +1015,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
 
 	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
 	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
-	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
+	trace_ext4_es_shrink_count(sbi->s_sb, sc->nr_to_scan, nr);
 	return nr;
 }
 
@@ -1028,14 +1028,14 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
 	int ret, nr_shrunk;
 
 	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
-	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
+	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
 
 	if (!nr_to_scan)
 		return ret;
 
 	nr_shrunk = __ext4_es_shrink(sbi, nr_to_scan, NULL);
 
-	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
+	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
 	return nr_shrunk;
 }
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 010ea89..c1d7a7c 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2379,7 +2379,7 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
 		  show_extent_status(__entry->found ? __entry->status : 0))
 );
 
-TRACE_EVENT(ext4_es_shrink_enter,
+DECLARE_EVENT_CLASS(ext4__es_shrink_enter,
 	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
 
 	TP_ARGS(sb, nr_to_scan, cache_cnt),
@@ -2401,26 +2401,38 @@ TRACE_EVENT(ext4_es_shrink_enter,
 		  __entry->nr_to_scan, __entry->cache_cnt)
 );
 
-TRACE_EVENT(ext4_es_shrink_exit,
-	TP_PROTO(struct super_block *sb, int shrunk_nr, int cache_cnt),
+DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_count,
+	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
+
+	TP_ARGS(sb, nr_to_scan, cache_cnt)
+);
+
+DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_scan_enter,
+	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
+
+	TP_ARGS(sb, nr_to_scan, cache_cnt)
+);
+
+TRACE_EVENT(ext4_es_shrink_scan_exit,
+	TP_PROTO(struct super_block *sb, int nr_shrunk, int cache_cnt),
 
-	TP_ARGS(sb, shrunk_nr, cache_cnt),
+	TP_ARGS(sb, nr_shrunk, cache_cnt),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	int,	shrunk_nr		)
+		__field(	int,	nr_shrunk		)
 		__field(	int,	cache_cnt		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
-		__entry->shrunk_nr	= shrunk_nr;
+		__entry->nr_shrunk	= nr_shrunk;
 		__entry->cache_cnt	= cache_cnt;
 	),
 
-	TP_printk("dev %d,%d shrunk_nr %d cache_cnt %d",
+	TP_printk("dev %d,%d nr_shrunk %d cache_cnt %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->shrunk_nr, __entry->cache_cnt)
+		  __entry->nr_shrunk, __entry->cache_cnt)
 );
 
 TRACE_EVENT(ext4_collapse_range,
-- 
1.7.9.7

