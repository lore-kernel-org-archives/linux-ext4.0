From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: change umode_t in tracepoint headers to be an explicit __u16
Date: Sat, 30 Jul 2011 12:52:22 -0400
Message-ID: <1312044742-15148-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59647 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1G3QwZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 30 Jul 2011 12:52:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As requested by Al Viro, since umode_t may be changing to a u32 for
some architectures.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 include/trace/events/ext4.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 51d8813..bf5518d 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -23,7 +23,7 @@ TRACE_EVENT(ext4_free_inode,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16, mode			)
 		__field(	uid_t,	uid			)
 		__field(	gid_t,	gid			)
 		__field(	__u64, blocks			)
@@ -52,7 +52,7 @@ TRACE_EVENT(ext4_request_inode,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	dir			)
-		__field(	umode_t, mode			)
+		__field(	__u16, mode			)
 	),
 
 	TP_fast_assign(
@@ -75,7 +75,7 @@ TRACE_EVENT(ext4_allocate_inode,
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
 		__field(	ino_t,	dir			)
-		__field(	umode_t, mode			)
+		__field(	__u16,	mode			)
 	),
 
 	TP_fast_assign(
@@ -727,7 +727,7 @@ TRACE_EVENT(ext4_free_blocks,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16,	mode			)
 		__field(	__u64,	block			)
 		__field(	unsigned long,	count		)
 		__field(	int,	flags			)
@@ -1014,7 +1014,7 @@ TRACE_EVENT(ext4_forget,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16,	mode			)
 		__field(	int,	is_metadata		)
 		__field(	__u64,	block			)
 	),
@@ -1041,7 +1041,7 @@ TRACE_EVENT(ext4_da_update_reserve_space,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16,	mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	used_blocks		)
 		__field(	int,	reserved_data_blocks	)
@@ -1078,7 +1078,7 @@ TRACE_EVENT(ext4_da_reserve_space,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16,  mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	md_needed		)
 		__field(	int,	reserved_data_blocks	)
@@ -1112,7 +1112,7 @@ TRACE_EVENT(ext4_da_release_space,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	ino_t,	ino			)
-		__field(	umode_t, mode			)
+		__field(	__u16,  mode			)
 		__field(	__u64,	i_blocks		)
 		__field(	int,	freed_blocks		)
 		__field(	int,	reserved_data_blocks	)
-- 
1.7.4.1.22.gec8e1.dirty

