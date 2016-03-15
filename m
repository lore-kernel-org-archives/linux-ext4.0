From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Tue, 15 Mar 2016 21:09:51 +0100
Message-ID: <20160315200951.GA1445@quack.suse.cz>
References: <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <20160313042723.GC29218@thunk.org>
 <20160314073928.GD5213@quack.suse.cz>
 <20160314143635.GM29218@thunk.org>
 <20160315104634.GG17942@quack.suse.cz>
 <20160315144633.GA12352@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Cc: Jan Kara <jack@suse.cz>,
	"HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934930AbcCOUJa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 16:09:30 -0400
Content-Disposition: inline
In-Reply-To: <20160315144633.GA12352@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 15-03-16 15:46:33, Jan Kara wrote:
> On Tue 15-03-16 11:46:34, Jan Kara wrote:
> > On Mon 14-03-16 10:36:35, Ted Tso wrote:
> > > On Mon, Mar 14, 2016 at 08:39:28AM +0100, Jan Kara wrote:
> > > > No, that won't be enough. blkdev_issue_flush() is not guaranteed to do
> > > > anything to IOs which have not reported completion before
> > > > blkdev_issue_flush() was called. Specifically, CFQ will queue submitted bio
> > > > in its internal RB tree, following flush request completely bypasses this
> > > > tree and goes directly to the disk where it flushes caches. And only later
> > > > CFQ decides to schedule async writeback from the flusher thread which is
> > > > queued in the RB tree...
> > > 
> > > Oh, right.  I am forgetting about the flushing mahchinery rewrite.
> > > Thanks for pointing that out.
> > > 
> > > But what we *could* do is to swap those two calls and then in the case
> > > where delalloc is enabled, could maintain a list of inodes where we
> > > only need to call filemap_fdatawait(), and not initiate writeback for
> > > any dirty pages which had been caused by non-allocating writes.
> > 
> > We actually don't need to swap those two calls - page is already marked as
> > under writeback in
> > 
> >   mpage_map_and_submit_buffers() -> mpage_submit_page -> ext4_bio_write_page
> > 
> > which gets called while we still hold the transaction handle. I agree
> > calling filemap_fdatawait() from JBD2 during commit should be enough to fix
> > issues with delalloc writeback. I'm just somewhat afraid that it will be
> > more fragile: If we add inode to transaction's list in ext4_map_blocks(),
> > we are pretty sure there's no way to allocate block to an inode without
> > introducing data exposure issues (which are then very hard to spot). If we
> > depend on callers of ext4_map_blocks() to properly add inode to appropriate
> > transaction list, we have much more places to check. I'll think whether we
> > could make this more robust.
> 
> OK, I have something - Huang, can you check whether the attached patches
> also fix your data exposure issues please? The first patch is the original
> fix, patch two is a cleanup, patches 3 and 4 implement the speedup
> suggested by Ted. Patches are only lightly tested so far.  I'll run more
> comprehensive tests later and in particular I want to check whether the
> additional complexity actually brings us some advantage at least for
> workloads which redirty pages in addition to writing some new ones using
> delayed allocation.

OK, there was a bug in patch 3. Attached is a new version of patches 3 and
4.
							Honza

--huq684BweRXVnRxX
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0003-jbd2-Add-support-for-avoiding-data-writes-during-tra.patch"

>From 5e3bf6cbe750979e003b132aceda655ebd5b4f2a Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Mar 2016 15:07:22 +0100
Subject: [PATCH 3/4] jbd2: Add support for avoiding data writes during
 transaction commits

Currently when filesystem needs to make sure data is on permanent
storage before committing a transaction it adds inode to transaction's
inode list. During transaction commit, jbd2 writes back all dirty
buffers that have allocated underlying blocks and waits for the IO to
finish. However when doing writeback for delayed allocated data, we
allocate blocks and immediately submit the data. Thus asking jbd2 to
write dirty pages just unnecessarily adds more work to jbd2 possibly
writing back other redirtied blocks.

Add support to jbd2 to allow filesystem to ask jbd2 to only wait for
outstanding data writes before committing a transaction and thus avoid
unnecessary writes.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h   |  3 ++-
 fs/jbd2/commit.c      |  4 ++++
 fs/jbd2/journal.c     |  3 ++-
 fs/jbd2/transaction.c | 22 ++++++++++++++++++----
 fs/ocfs2/journal.h    |  2 +-
 include/linux/jbd2.h  | 13 +++++++++++--
 6 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 5f5846211095..f1c940b38b30 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -362,7 +362,8 @@ static inline int ext4_journal_force_commit(journal_t *journal)
 static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_file_inode(handle, EXT4_I(inode)->jinode);
+		return jbd2_journal_inode_add_write(handle,
+						    EXT4_I(inode)->jinode);
 	return 0;
 }
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 36345fefa3ff..7d1dbe93d290 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -221,6 +221,8 @@ static int journal_submit_data_buffers(journal_t *journal,
 
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		if (!(jinode->i_flags & JI_WRITE_DATA))
+			continue;
 		mapping = jinode->i_vfs_inode->i_mapping;
 		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
 		spin_unlock(&journal->j_list_lock);
@@ -258,6 +260,8 @@ static int journal_finish_inode_data_buffers(journal_t *journal,
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		if (!(jinode->i_flags & JI_WAIT_DATA))
+			continue;
 		set_bit(__JI_COMMIT_RUNNING, &jinode->i_flags);
 		spin_unlock(&journal->j_list_lock);
 		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 81e622681c82..8734b77ae47a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -94,7 +94,8 @@ EXPORT_SYMBOL(jbd2_journal_blocks_per_page);
 EXPORT_SYMBOL(jbd2_journal_invalidatepage);
 EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
-EXPORT_SYMBOL(jbd2_journal_file_inode);
+EXPORT_SYMBOL(jbd2_journal_inode_add_write);
+EXPORT_SYMBOL(jbd2_journal_inode_add_wait);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index ca181e81c765..d1b5c0f465b5 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2476,7 +2476,8 @@ void jbd2_journal_refile_buffer(journal_t *journal, struct journal_head *jh)
 /*
  * File inode in the inode list of the handle's transaction
  */
-int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
+static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
+				   unsigned long flags)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal;
@@ -2501,12 +2502,14 @@ int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
 	 * and if jinode->i_next_transaction == transaction, commit code
 	 * will only file the inode where we want it.
 	 */
-	if (jinode->i_transaction == transaction ||
-	    jinode->i_next_transaction == transaction)
+	if ((jinode->i_transaction == transaction ||
+	    jinode->i_next_transaction == transaction) &&
+	    (jinode->i_flags & flags) == flags)
 		return 0;
 
 	spin_lock(&journal->j_list_lock);
-
+	jinode->i_flags |= flags;
+	/* Is inode already attached where we need it? */
 	if (jinode->i_transaction == transaction ||
 	    jinode->i_next_transaction == transaction)
 		goto done;
@@ -2537,6 +2540,17 @@ done:
 	return 0;
 }
 
+int jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *jinode)
+{
+	return jbd2_journal_file_inode(handle, jinode,
+				       JI_WRITE_DATA | JI_WAIT_DATA);
+}
+
+int jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *jinode)
+{
+	return jbd2_journal_file_inode(handle, jinode, JI_WAIT_DATA);
+}
+
 /*
  * File truncate and transaction commit interact with each other in a
  * non-trivial way.  If a transaction writing data block A is
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index f4cd3c3e9fb7..497a4171ef61 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -619,7 +619,7 @@ static inline int ocfs2_calc_tree_trunc_credits(struct super_block *sb,
 
 static inline int ocfs2_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
-	return jbd2_journal_file_inode(handle, &OCFS2_I(inode)->ip_jinode);
+	return jbd2_journal_inode_add_write(handle, &OCFS2_I(inode)->ip_jinode);
 }
 
 static inline int ocfs2_begin_ordered_truncate(struct inode *inode,
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 65407f6c9120..05a8d6762b2d 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -408,11 +408,19 @@ static inline void jbd_unlock_bh_journal_head(struct buffer_head *bh)
 
 /* Flags in jbd_inode->i_flags */
 #define __JI_COMMIT_RUNNING 0
-/* Commit of the inode data in progress. We use this flag to protect us from
+#define __JI_WRITE_DATA 1
+#define __JI_WAIT_DATA 2
+
+/*
+ * Commit of the inode data in progress. We use this flag to protect us from
  * concurrent deletion of inode. We cannot use reference to inode for this
  * since we cannot afford doing last iput() on behalf of kjournald
  */
 #define JI_COMMIT_RUNNING (1 << __JI_COMMIT_RUNNING)
+/* Write allocated dirty buffers in this inode before commit */
+#define JI_WRITE_DATA (1 << __JI_WRITE_DATA)
+/* Wait for outstanding data writes for this inode before commit */
+#define JI_WAIT_DATA (1 << __JI_WAIT_DATA)
 
 /**
  * struct jbd_inode is the structure linking inodes in ordered mode
@@ -1274,7 +1282,8 @@ extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
 extern int	   jbd2_journal_force_commit_nested(journal_t *);
-extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
+extern int	   jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *inode);
+extern int	   jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *inode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
-- 
2.6.2


--huq684BweRXVnRxX
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0004-ext4-Do-not-ask-jbd2-to-write-data-for-delalloc-buff.patch"

>From e79ed02968040d8684ecfba7a9dca0a8af1c5830 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 15 Mar 2016 15:25:02 +0100
Subject: [PATCH 4/4] ext4: Do not ask jbd2 to write data for delalloc buffers

Currently we ask jbd2 to write all dirty allocated buffers before
committing a transaction when doing writeback of delay allocated blocks.
However this is unnecessary since we move all pages to writeback state
before dropping a transaction handle and then submit all the necessary
IO. We still need the transaction commit to wait for all the outstanding
writeback before flushing disk caches during transaction commit to avoid
data exposure issues though. Use the new jbd2 capability and ask it to
only wait for outstanding writeback during transaction commit when
writing back data in ext4_writepages().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h        |  3 +++
 fs/ext4/ext4_jbd2.h   | 12 +++++++++++-
 fs/ext4/inode.c       | 10 +++++++---
 fs/ext4/move_extent.c |  2 +-
 4 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bc4910bce4ff..a095e833a6c0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -561,6 +561,9 @@ enum {
 #define EXT4_GET_BLOCKS_ZERO			0x0200
 #define EXT4_GET_BLOCKS_CREATE_ZERO		(EXT4_GET_BLOCKS_CREATE |\
 					EXT4_GET_BLOCKS_ZERO)
+	/* Caller will submit data before dropping transaction handle. This
+	 * allows jbd2 to avoid submitting data before commit. */
+#define EXT4_GET_BLOCKS_IO_SUBMIT		0x0400
 
 /*
  * The bit position of these flags must not overlap with any of the
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f1c940b38b30..09c1ef38cbe6 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -359,7 +359,8 @@ static inline int ext4_journal_force_commit(journal_t *journal)
 	return 0;
 }
 
-static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
+static inline int ext4_jbd2_inode_add_write(handle_t *handle,
+					    struct inode *inode)
 {
 	if (ext4_handle_valid(handle))
 		return jbd2_journal_inode_add_write(handle,
@@ -367,6 +368,15 @@ static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
 	return 0;
 }
 
+static inline int ext4_jbd2_inode_add_wait(handle_t *handle,
+					   struct inode *inode)
+{
+	if (ext4_handle_valid(handle))
+		return jbd2_journal_inode_add_wait(handle,
+						   EXT4_I(inode)->jinode);
+	return 0;
+}
+
 static inline void ext4_update_inode_fsync_trans(handle_t *handle,
 						 struct inode *inode,
 						 int datasync)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 173da9d467d1..01ecc67985bb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -692,7 +692,10 @@ out_sem:
 		    !(map->m_flags & EXT4_MAP_UNWRITTEN) &&
 		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
 		    ext4_should_order_data(inode)) {
-			ret = ext4_jbd2_file_inode(handle, inode);
+			if (flags & EXT4_GET_BLOCKS_IO_SUBMIT)
+				ret = ext4_jbd2_inode_add_wait(handle, inode);
+			else
+				ret = ext4_jbd2_inode_add_write(handle, inode);
 			if (ret)
 				return ret;
 		}
@@ -2164,7 +2167,8 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 	 * the data was copied into the page cache.
 	 */
 	get_blocks_flags = EXT4_GET_BLOCKS_CREATE |
-			   EXT4_GET_BLOCKS_METADATA_NOFAIL;
+			   EXT4_GET_BLOCKS_METADATA_NOFAIL |
+			   EXT4_GET_BLOCKS_IO_SUBMIT;
 	dioread_nolock = ext4_should_dioread_nolock(inode);
 	if (dioread_nolock)
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
@@ -3538,7 +3542,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 		err = 0;
 		mark_buffer_dirty(bh);
 		if (ext4_should_order_data(inode))
-			err = ext4_jbd2_file_inode(handle, inode);
+			err = ext4_jbd2_inode_add_write(handle, inode);
 	}
 
 unlock:
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index fb6f11709ae6..0ce9795c7404 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -390,7 +390,7 @@ data_copy:
 
 	/* Even in case of data=writeback it is reasonable to pin
 	 * inode to transaction, to prevent unexpected data loss */
-	*err = ext4_jbd2_file_inode(handle, orig_inode);
+	*err = ext4_jbd2_inode_add_write(handle, orig_inode);
 
 unlock_pages:
 	unlock_page(pagep[0]);
-- 
2.6.2


--huq684BweRXVnRxX--
