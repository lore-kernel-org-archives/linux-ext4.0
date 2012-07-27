From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 02/15] jbd2: implement jbd2_journal_invalidatepage_range
Date: Fri, 27 Jul 2012 10:01:01 +0200
Message-ID: <1343376074-28034-3-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab2G0IBq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2012 04:01:46 -0400
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mm now supports invalidatepage_range address space operation and there
are two file system using jbd2 also implementing punch hole feature
which can benefit from this. We need to implement the same thing for
jbd2 layer in order to allow those file system take benefit of this
functionality.

With new function jbd2_journal_invalidatepage_range() we can now specify
length to invalidate, rather than assuming invalidate to the end of the
page.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/jbd2/journal.c     |    1 +
 fs/jbd2/transaction.c |   20 ++++++++++++++++++--
 include/linux/jbd2.h  |    2 ++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e9a3c4c..a69edc1 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -86,6 +86,7 @@ EXPORT_SYMBOL(jbd2_journal_force_commit_nested);
 EXPORT_SYMBOL(jbd2_journal_wipe);
 EXPORT_SYMBOL(jbd2_journal_blocks_per_page);
 EXPORT_SYMBOL(jbd2_journal_invalidatepage);
+EXPORT_SYMBOL(jbd2_journal_invalidatepage_range);
 EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_file_inode);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fb1ab953..225c6ba 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1993,10 +1993,20 @@ zap_buffer_unlocked:
  *
  */
 void jbd2_journal_invalidatepage(journal_t *journal,
-		      struct page *page,
-		      unsigned long offset)
+				 struct page *page,
+				 unsigned long offset)
+{
+	jbd2_journal_invalidatepage_range(journal, page, offset,
+					  PAGE_CACHE_SIZE);
+}
+
+void jbd2_journal_invalidatepage_range(journal_t *journal,
+				       struct page *page,
+				       unsigned long offset,
+				       unsigned long length)
 {
 	struct buffer_head *head, *bh, *next;
+	unsigned long stop = offset + length;
 	unsigned int curr_off = 0;
 	int may_free = 1;
 
@@ -2005,6 +2015,9 @@ void jbd2_journal_invalidatepage(journal_t *journal,
 	if (!page_has_buffers(page))
 		return;
 
+	if (stop < length)
+		stop = PAGE_CACHE_SIZE;
+
 	/* We will potentially be playing with lists other than just the
 	 * data lists (especially for journaled data mode), so be
 	 * cautious in our locking. */
@@ -2014,6 +2027,9 @@ void jbd2_journal_invalidatepage(journal_t *journal,
 		unsigned int next_off = curr_off + bh->b_size;
 		next = bh->b_this_page;
 
+		if (next_off > stop)
+			return;
+
 		if (offset <= curr_off) {
 			/* This block is wholly outside the truncation point */
 			lock_buffer(bh);
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f334c7f..c42c3436 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1101,6 +1101,8 @@ extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
 extern void	 journal_sync_buffer (struct buffer_head *);
 extern void	 jbd2_journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
+extern void	 jbd2_journal_invalidatepage_range(journal_t *, struct page *,
+				unsigned long, unsigned long);
 extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
 extern int	 jbd2_journal_stop(handle_t *);
 extern int	 jbd2_journal_flush (journal_t *);
-- 
1.7.7.6

