From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 13/15] ext4: update ext4_ext_remove_space trace point
Date: Fri, 27 Jul 2012 10:01:12 +0200
Message-ID: <1343376074-28034-14-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab2G0ICK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2012 04:02:10 -0400
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add "end" variable.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c           |    6 +++---
 include/trace/events/ext4.h |   21 ++++++++++++++-------
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d0084e..014bec4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2572,7 +2572,7 @@ static int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 again:
 	ext4_ext_invalidate_cache(inode);
 
-	trace_ext4_ext_remove_space(inode, start, depth);
+	trace_ext4_ext_remove_space(inode, start, end, depth);
 
 	/*
 	 * Check if we are removing extents inside the extent tree. If that
@@ -2725,8 +2725,8 @@ cont:
 		}
 	}
 
-	trace_ext4_ext_remove_space_done(inode, start, depth, partial_cluster,
-			path->p_hdr->eh_entries);
+	trace_ext4_ext_remove_space_done(inode, start, end, depth,
+			partial_cluster, path->p_hdr->eh_entries);
 
 	/* If we still have something in the partial cluster and we have removed
 	 * even the first extent, then we should free the blocks in the partial
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 30bae72..884cbf2 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1999,14 +1999,16 @@ TRACE_EVENT(ext4_ext_rm_idx,
 );
 
 TRACE_EVENT(ext4_ext_remove_space,
-	TP_PROTO(struct inode *inode, ext4_lblk_t start, int depth),
+	TP_PROTO(struct inode *inode, ext4_lblk_t start,
+		 ext4_lblk_t end, int depth),
 
-	TP_ARGS(inode, start, depth),
+	TP_ARGS(inode, start, end, depth),
 
 	TP_STRUCT__entry(
 		__field(	ino_t,		ino	)
 		__field(	dev_t,		dev	)
 		__field(	ext4_lblk_t,	start	)
+		__field(	ext4_lblk_t,	end	)
 		__field(	int,		depth	)
 	),
 
@@ -2014,26 +2016,29 @@ TRACE_EVENT(ext4_ext_remove_space,
 		__entry->ino	= inode->i_ino;
 		__entry->dev	= inode->i_sb->s_dev;
 		__entry->start	= start;
+		__entry->end	= end;
 		__entry->depth	= depth;
 	),
 
-	TP_printk("dev %d,%d ino %lu since %u depth %d",
+	TP_printk("dev %d,%d ino %lu start %u end %u depth %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->start,
+		  (unsigned) __entry->end,
 		  __entry->depth)
 );
 
 TRACE_EVENT(ext4_ext_remove_space_done,
-	TP_PROTO(struct inode *inode, ext4_lblk_t start, int depth,
-		ext4_lblk_t partial, unsigned short eh_entries),
+	TP_PROTO(struct inode *inode, ext4_lblk_t start, ext4_lblk_t end,
+		 int depth, ext4_lblk_t partial, unsigned short eh_entries),
 
-	TP_ARGS(inode, start, depth, partial, eh_entries),
+	TP_ARGS(inode, start, end, depth, partial, eh_entries),
 
 	TP_STRUCT__entry(
 		__field(	ino_t,		ino		)
 		__field(	dev_t,		dev		)
 		__field(	ext4_lblk_t,	start		)
+		__field(	ext4_lblk_t,	end		)
 		__field(	int,		depth		)
 		__field(	ext4_lblk_t,	partial		)
 		__field(	unsigned short,	eh_entries	)
@@ -2043,16 +2048,18 @@ TRACE_EVENT(ext4_ext_remove_space_done,
 		__entry->ino		= inode->i_ino;
 		__entry->dev		= inode->i_sb->s_dev;
 		__entry->start		= start;
+		__entry->end		= end;
 		__entry->depth		= depth;
 		__entry->partial	= partial;
 		__entry->eh_entries	= eh_entries;
 	),
 
-	TP_printk("dev %d,%d ino %lu since %u depth %d partial %u "
+	TP_printk("dev %d,%d ino %lu start %u end %u depth %d partial %u "
 		  "remaining_entries %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
 		  (unsigned) __entry->start,
+		  (unsigned) __entry->end,
 		  __entry->depth,
 		  (unsigned) __entry->partial,
 		  (unsigned short) __entry->eh_entries)
-- 
1.7.7.6

