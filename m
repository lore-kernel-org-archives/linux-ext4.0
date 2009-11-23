From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/8] ext4: print i_mode in octal in ext4 tracepoints
Date: Sun, 22 Nov 2009 21:18:28 -0500
Message-ID: <1258942710-31930-7-git-send-email-tytso@mit.edu>
References: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48714 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZKWCS3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 21:18:29 -0500
In-Reply-To: <1258942710-31930-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode permissions are much easier to understand if they are printed in
octal.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 include/trace/events/ext4.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 74f628b..287347c 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -38,7 +38,7 @@ TRACE_EVENT(ext4_free_inode,
 		__entry->blocks	= inode->i_blocks;
 	),
 
-	TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
+	TP_printk("dev %s ino %lu mode 0%o uid %u gid %u blocks %llu",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
 		  __entry->mode, __entry->uid, __entry->gid,
 		  (unsigned long long) __entry->blocks)
@@ -61,7 +61,7 @@ TRACE_EVENT(ext4_request_inode,
 		__entry->mode	= mode;
 	),
 
-	TP_printk("dev %s dir %lu mode %d",
+	TP_printk("dev %s dir %lu mode 0%o",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->dir,
 		  __entry->mode)
 );
@@ -85,7 +85,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		__entry->mode	= mode;
 	),
 
-	TP_printk("dev %s ino %lu dir %lu mode %d",
+	TP_printk("dev %s ino %lu dir %lu mode 0%o",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
 		  (unsigned long) __entry->dir, __entry->mode)
 );
@@ -930,7 +930,7 @@ TRACE_EVENT(ext4_forget,
 		__entry->block	= block;
 	),
 
-	TP_printk("dev %s ino %lu mode %d is_metadata %d block %llu",
+	TP_printk("dev %s ino %lu mode 0%o is_metadata %d block %llu",
 		  jbd2_dev_to_name(__entry->dev), (unsigned long) __entry->ino,
 		  __entry->mode, __entry->is_metadata, __entry->block)
 );
-- 
1.6.5.216.g5288a.dirty

