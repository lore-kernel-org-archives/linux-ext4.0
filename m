From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add tracepoint for ext4_journal_start
Date: Sun, 10 Jul 2011 23:28:41 -0400
Message-ID: <1310354921-29876-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43722 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756965Ab1GKD2o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 10 Jul 2011 23:28:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This will help debug who is responsible for starting a jbd2 transaction.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c             |    1 +
 include/trace/events/ext4.h |   22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..7910e61 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -269,6 +269,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	journal_t *journal;
 	handle_t  *handle;
 
+	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 5ce2b2f..6f27a59 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -1520,6 +1520,28 @@ TRACE_EVENT(ext4_load_inode,
 		  (unsigned long) __entry->ino)
 );
 
+TRACE_EVENT(ext4_journal_start,
+	TP_PROTO(struct super_block *sb, int nblocks, unsigned long IP),
+
+	TP_ARGS(sb, nblocks, IP),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	  int, 	nblocks			)
+		__field(unsigned long,	ip			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	 = sb->s_dev;
+		__entry->nblocks = nblocks;
+		__entry->ip	 = IP;
+	),
+
+	TP_printk("dev %d,%d nblocks %d caller %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nblocks, (void *)__entry->ip)
+);
+
 #endif /* _TRACE_EXT4_H */
 
 /* This part must be outside protection */
-- 
1.7.4.1.22.gec8e1.dirty

