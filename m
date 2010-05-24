From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 5/8] tracing: Convert more ext4 events to DEFINE_EVENT
Date: Mon, 24 May 2010 16:24:04 +0800
Message-ID: <4BFA37A4.1050208@cn.fujitsu.com>
References: <4BFA3728.3000701@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	LKML <linux-kernel@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0EXIVq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 May 2010 04:21:46 -0400
In-Reply-To: <4BFA3728.3000701@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use DECLARE_EVENT_CLASS, and save ~2.7K:

   text    data     bss     dec     hex filename
 274441    7200     260  281901   44d2d fs/ext4/ext4.o.orig
 271881    7040     256  279177   44289 fs/ext4/ext4.o

4 events are converted:

  ext4__mb_new_pa: ext4_mb_new_inode_pa, ext4_mb_new_group_pa
  ext4__mballoc:   ext4_mballoc_discard, ext4_mballoc_free

No change in functionality.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/trace/events/ext4.h |   61 ++++++++++++-------------------------------
 1 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 2aa6aa3..9425714 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -353,7 +353,7 @@ TRACE_EVENT(ext4_discard_blocks,
 		  jbd2_dev_to_name(__entry->dev), __entry->blk, __entry->count)
 );
 
-TRACE_EVENT(ext4_mb_new_inode_pa,
+DECLARE_EVENT_CLASS(ext4__mb_new_pa,
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
@@ -381,32 +381,20 @@ TRACE_EVENT(ext4_mb_new_inode_pa,
 		  __entry->pa_pstart, __entry->pa_len, __entry->pa_lstart)
 );
 
-TRACE_EVENT(ext4_mb_new_group_pa,
+DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_inode_pa,
+
 	TP_PROTO(struct ext4_allocation_context *ac,
 		 struct ext4_prealloc_space *pa),
 
-	TP_ARGS(ac, pa),
-
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	__u64,	pa_pstart		)
-		__field(	__u32,	pa_len			)
-		__field(	__u64,	pa_lstart		)
+	TP_ARGS(ac, pa)
+);
 
-	),
+DEFINE_EVENT(ext4__mb_new_pa, ext4_mb_new_group_pa,
 
-	TP_fast_assign(
-		__entry->dev		= ac->ac_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
-		__entry->pa_pstart	= pa->pa_pstart;
-		__entry->pa_len		= pa->pa_len;
-		__entry->pa_lstart	= pa->pa_lstart;
-	),
+	TP_PROTO(struct ext4_allocation_context *ac,
+		 struct ext4_prealloc_space *pa),
 
-	TP_printk("dev %s ino %lu pstart %llu len %u lstart %llu",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->pa_pstart, __entry->pa_len, __entry->pa_lstart)
+	TP_ARGS(ac, pa)
 );
 
 TRACE_EVENT(ext4_mb_release_inode_pa,
@@ -790,7 +778,7 @@ TRACE_EVENT(ext4_mballoc_prealloc,
 		  __entry->result_len, __entry->result_logical)
 );
 
-TRACE_EVENT(ext4_mballoc_discard,
+DECLARE_EVENT_CLASS(ext4__mballoc,
 	TP_PROTO(struct ext4_allocation_context *ac),
 
 	TP_ARGS(ac),
@@ -819,33 +807,18 @@ TRACE_EVENT(ext4_mballoc_discard,
 		  __entry->result_len, __entry->result_logical)
 );
 
-TRACE_EVENT(ext4_mballoc_free,
+DEFINE_EVENT(ext4__mballoc, ext4_mballoc_discard,
+
 	TP_PROTO(struct ext4_allocation_context *ac),
 
-	TP_ARGS(ac),
+	TP_ARGS(ac)
+);
 
-	TP_STRUCT__entry(
-		__field(	dev_t,	dev			)
-		__field(	ino_t,	ino			)
-		__field(	__u32, 	result_logical		)
-		__field(	  int,	result_start		)
-		__field(	__u32, 	result_group		)
-		__field(	  int,	result_len		)
-	),
+DEFINE_EVENT(ext4__mballoc, ext4_mballoc_free,
 
-	TP_fast_assign(
-		__entry->dev		= ac->ac_inode->i_sb->s_dev;
-		__entry->ino		= ac->ac_inode->i_ino;
-		__entry->result_logical	= ac->ac_b_ex.fe_logical;
-		__entry->result_start	= ac->ac_b_ex.fe_start;
-		__entry->result_group	= ac->ac_b_ex.fe_group;
-		__entry->result_len	= ac->ac_b_ex.fe_len;
-	),
+	TP_PROTO(struct ext4_allocation_context *ac),
 
-	TP_printk("dev %s inode %lu extent %u/%d/%u@%u ",
-		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
-		  __entry->result_group, __entry->result_start,
-		  __entry->result_len, __entry->result_logical)
+	TP_ARGS(ac)
 );
 
 TRACE_EVENT(ext4_forget,
-- 
1.6.3

