From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Fix deadlock in journal_unmap_buffer()
Date: Wed, 12 Dec 2012 21:50:16 +0100
Message-ID: <1355345416-13565-2-git-send-email-jack@suse.cz>
References: <1355345416-13565-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab2LLUu1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Dec 2012 15:50:27 -0500
In-Reply-To: <1355345416-13565-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We cannot wait for transaction commit in journal_unmap_buffer() because we hold
page lock which ranks below transaction start. We solve the issue by bailing
out of journal_unmap_buffer() and jbd2_journal_invalidatepage() with -EBUSY.
Caller is then responsible for waiting for transaction commit to finish and try
invalidation again. Since the issue can happen only for page stradding i_size,
it is simple enough to manually call jbd2_journal_invalidatepage() for such
page from ext4_setattr(), check the return value and wait if necessary.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c             |   82 +++++++++++++++++++++++++++++++++++++------
 fs/jbd2/transaction.c       |   27 +++++++-------
 include/linux/jbd2.h        |    2 +-
 include/trace/events/ext4.h |    4 +-
 4 files changed, 88 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 66abac7..cc0abeb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2813,8 +2813,8 @@ static void ext4_invalidatepage(struct page *page, unsigned long offset)
 	block_invalidatepage(page, offset);
 }
 
-static void ext4_journalled_invalidatepage(struct page *page,
-					   unsigned long offset)
+static int __ext4_journalled_invalidatepage(struct page *page,
+					    unsigned long offset)
 {
 	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
 
@@ -2826,7 +2826,14 @@ static void ext4_journalled_invalidatepage(struct page *page,
 	if (offset == 0)
 		ClearPageChecked(page);
 
-	jbd2_journal_invalidatepage(journal, page, offset);
+	return jbd2_journal_invalidatepage(journal, page, offset);
+}
+
+/* Wrapper for aops... */
+static void ext4_journalled_invalidatepage(struct page *page,
+					   unsigned long offset)
+{
+	WARN_ON(__ext4_journalled_invalidatepage(page, offset) < 0);
 }
 
 static int ext4_releasepage(struct page *page, gfp_t wait)
@@ -4230,6 +4237,47 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 }
 
 /*
+ * In data=journal mode ext4_journalled_invalidatepage() may fail to invalidate
+ * buffers that are attached to a page stradding i_size and are undergoing
+ * commit. In that case we have to wait for commit to finish and try again.
+ */
+static void ext4_wait_for_tail_page_commit(struct inode *inode)
+{
+	struct page *page;
+	unsigned offset;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+	tid_t commit_tid = 0;
+	int ret;
+
+	offset = inode->i_size & (PAGE_CACHE_SIZE - 1);
+	/*
+	 * All buffers in the last page remain valid? Then there's nothing to
+	 * do. We do the check mainly to optimize the common PAGE_CACHE_SIZE ==
+	 * blocksize case
+	 */
+	if (offset > PAGE_CACHE_SIZE - (1 << inode->i_blkbits))
+		return;
+	while (1) {
+		page = find_lock_page(inode->i_mapping,
+				      inode->i_size >> PAGE_CACHE_SHIFT);
+		if (!page)
+			return;
+		ret = __ext4_journalled_invalidatepage(page, offset);
+		unlock_page(page);
+		page_cache_release(page);
+		if (ret != -EBUSY)
+			return;
+		commit_tid = 0;
+		read_lock(&journal->j_state_lock);
+		if (journal->j_committing_transaction)
+			commit_tid = journal->j_committing_transaction->t_tid;
+		read_unlock(&journal->j_state_lock);
+		if (commit_tid)
+			jbd2_log_wait_commit(journal, commit_tid);
+	}
+}
+
+/*
  * ext4_setattr()
  *
  * Called from notify_change.
@@ -4342,16 +4390,28 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
-		if (attr->ia_size != i_size_read(inode)) {
-			truncate_setsize(inode, attr->ia_size);
-			/* Inode size will be reduced, wait for dio in flight.
-			 * Temporarily disable dioread_nolock to prevent
-			 * livelock. */
+		if (attr->ia_size != inode->i_size) {
+			loff_t oldsize = inode->i_size;
+
+			i_size_write(inode, attr->ia_size);
+			/*
+			 * Blocks are going to be removed from the inode. Wait
+			 * for dio in flight.  Temporarily disable
+			 * dioread_nolock to prevent livelock.
+			 */
 			if (orphan) {
-				ext4_inode_block_unlocked_dio(inode);
-				inode_dio_wait(inode);
-				ext4_inode_resume_unlocked_dio(inode);
+				if (!ext4_should_journal_data(inode)) {
+					ext4_inode_block_unlocked_dio(inode);
+					inode_dio_wait(inode);
+					ext4_inode_resume_unlocked_dio(inode);
+				} else
+					ext4_wait_for_tail_page_commit(inode);
 			}
+			/*
+			 * Truncate pagecache after we've waited for commit
+			 * in data=journal mode to make pages freeable.
+			 */
+			truncate_pagecache(inode, oldsize, inode->i_size);
 		}
 		ext4_truncate(inode);
 	}
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a74ba46..e1475b4 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1850,7 +1850,6 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 
 	BUFFER_TRACE(bh, "entry");
 
-retry:
 	/*
 	 * It is safe to proceed here without the j_list_lock because the
 	 * buffers cannot be stolen by try_to_free_buffers as long as we are
@@ -1945,14 +1944,11 @@ retry:
 		 * for commit and try again.
 		 */
 		if (partial_page) {
-			tid_t tid = journal->j_committing_transaction->t_tid;
-
 			jbd2_journal_put_journal_head(jh);
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			write_unlock(&journal->j_state_lock);
-			jbd2_log_wait_commit(journal, tid);
-			goto retry;
+			return -EBUSY;
 		}
 		/*
 		 * OK, buffer won't be reachable after truncate. We just set
@@ -2013,21 +2009,23 @@ zap_buffer_unlocked:
  * @page:    page to flush
  * @offset:  length of page to invalidate.
  *
- * Reap page buffers containing data after offset in page.
- *
+ * Reap page buffers containing data after offset in page. Can return -EBUSY
+ * if buffers are part of the committing transaction and the page is straddling
+ * i_size. Caller then has to wait for current commit and try again.
  */
-void jbd2_journal_invalidatepage(journal_t *journal,
-		      struct page *page,
-		      unsigned long offset)
+int jbd2_journal_invalidatepage(journal_t *journal,
+				struct page *page,
+				unsigned long offset)
 {
 	struct buffer_head *head, *bh, *next;
 	unsigned int curr_off = 0;
 	int may_free = 1;
+	int ret = 0;
 
 	if (!PageLocked(page))
 		BUG();
 	if (!page_has_buffers(page))
-		return;
+		return 0;
 
 	/* We will potentially be playing with lists other than just the
 	 * data lists (especially for journaled data mode), so be
@@ -2041,9 +2039,11 @@ void jbd2_journal_invalidatepage(journal_t *journal,
 		if (offset <= curr_off) {
 			/* This block is wholly outside the truncation point */
 			lock_buffer(bh);
-			may_free &= journal_unmap_buffer(journal, bh,
-							 offset > 0);
+			ret = journal_unmap_buffer(journal, bh, offset > 0);
 			unlock_buffer(bh);
+			if (ret < 0)
+				return ret;
+			may_free &= ret;
 		}
 		curr_off = next_off;
 		bh = next;
@@ -2054,6 +2054,7 @@ void jbd2_journal_invalidatepage(journal_t *journal,
 		if (may_free && try_to_free_buffers(page))
 			J_ASSERT(!page_has_buffers(page));
 	}
+	return 0;
 }
 
 /*
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3efc43f..cb7d6af 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1099,7 +1099,7 @@ extern int	 jbd2_journal_dirty_metadata (handle_t *, struct buffer_head *);
 extern void	 jbd2_journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
 extern void	 journal_sync_buffer (struct buffer_head *);
-extern void	 jbd2_journal_invalidatepage(journal_t *,
+extern int	 jbd2_journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
 extern int	 jbd2_journal_stop(handle_t *);
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index df972d9..3ef522e 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -476,13 +476,13 @@ DECLARE_EVENT_CLASS(ext4_invalidatepage_op,
 		  (unsigned long) __entry->index, __entry->offset)
 );
 
-DEFINE_EVENT(ext4_invalidatepage_op, ext4_invalidatepage
+DEFINE_EVENT(ext4_invalidatepage_op, ext4_invalidatepage,
 	TP_PROTO(struct page *page, unsigned long offset),
 
 	TP_ARGS(page, offset)
 );
 
-DEFINE_EVENT(ext4_invalidatepage_op, ext4_journalled_invalidatepage
+DEFINE_EVENT(ext4_invalidatepage_op, ext4_journalled_invalidatepage,
 	TP_PROTO(struct page *page, unsigned long offset),
 
 	TP_ARGS(page, offset)
-- 
1.7.1

