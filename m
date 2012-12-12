From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Split off ext4_journalled_invalidatepage()
Date: Wed, 12 Dec 2012 21:50:15 +0100
Message-ID: <1355345416-13565-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab2LLUu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 15:50:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In data=journal mode we don't need delalloc or DIO handling in invalidatepage
and similarly in other modes we don't need the journal handling. So split
invalidatepage implementations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c             |   23 ++++++++++++++++-------
 include/trace/events/ext4.h |   14 +++++++++++++-
 2 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b3c243b..66abac7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2799,8 +2799,6 @@ static void ext4_invalidatepage_free_endio(struct page *page, unsigned long offs
 
 static void ext4_invalidatepage(struct page *page, unsigned long offset)
 {
-	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
-
 	trace_ext4_invalidatepage(page, offset);
 
 	/*
@@ -2808,16 +2806,27 @@ static void ext4_invalidatepage(struct page *page, unsigned long offset)
 	 */
 	if (ext4_should_dioread_nolock(page->mapping->host))
 		ext4_invalidatepage_free_endio(page, offset);
+
+	/* No journalling happens on data buffers when this function is used */
+	WARN_ON(page_has_buffers(page) && buffer_jbd(page_buffers(page)));
+
+	block_invalidatepage(page, offset);
+}
+
+static void ext4_journalled_invalidatepage(struct page *page,
+					   unsigned long offset)
+{
+	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
+
+	trace_ext4_journalled_invalidatepage(page, offset);
+
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
 		ClearPageChecked(page);
 
-	if (journal)
-		jbd2_journal_invalidatepage(journal, page, offset);
-	else
-		block_invalidatepage(page, offset);
+	jbd2_journal_invalidatepage(journal, page, offset);
 }
 
 static int ext4_releasepage(struct page *page, gfp_t wait)
@@ -3201,7 +3210,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.write_end		= ext4_journalled_write_end,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
+	.invalidatepage		= ext4_journalled_invalidatepage,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index d49b285..df972d9 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -450,7 +450,7 @@ DEFINE_EVENT(ext4__page_op, ext4_releasepage,
 	TP_ARGS(page)
 );
 
-TRACE_EVENT(ext4_invalidatepage,
+DECLARE_EVENT_CLASS(ext4_invalidatepage_op,
 	TP_PROTO(struct page *page, unsigned long offset),
 
 	TP_ARGS(page, offset),
@@ -476,6 +476,18 @@ TRACE_EVENT(ext4_invalidatepage,
 		  (unsigned long) __entry->index, __entry->offset)
 );
 
+DEFINE_EVENT(ext4_invalidatepage_op, ext4_invalidatepage
+	TP_PROTO(struct page *page, unsigned long offset),
+
+	TP_ARGS(page, offset)
+);
+
+DEFINE_EVENT(ext4_invalidatepage_op, ext4_journalled_invalidatepage
+	TP_PROTO(struct page *page, unsigned long offset),
+
+	TP_ARGS(page, offset)
+);
+
 TRACE_EVENT(ext4_discard_blocks,
 	TP_PROTO(struct super_block *sb, unsigned long long blk,
 			unsigned long long count),
-- 
1.7.1

