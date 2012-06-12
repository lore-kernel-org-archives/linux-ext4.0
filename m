From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/27] ext4: Convert to new freezing mechanism
Date: Tue, 12 Jun 2012 16:20:38 +0200
Message-ID: <1339510848-16992-18-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We remove most of frozen checks since upper layer takes care of blocking all
writes. We have to handle protection in ext4_page_mkwrite() in a special way
because we cannot use generic block_page_mkwrite(). Also we add a freeze
protection to ext4_evict_inode() so that iput() of unlinked inode cannot modify
a frozen filesystem (we cannot easily instrument ext4_journal_start() /
ext4_journal_stop() with freeze protection because we are missing the
superblock pointer in ext4_journal_stop() in nojournal mode).

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |   15 ++++++++++-----
 fs/ext4/mmp.c   |    6 ++++++
 fs/ext4/super.c |   31 +++++++------------------------
 3 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..301e1c2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -233,6 +233,11 @@ void ext4_evict_inode(struct inode *inode)
 	if (is_bad_inode(inode))
 		goto no_delete;
 
+	/*
+	 * Protect us against freezing - iput() caller didn't have to have any
+	 * protection against it
+	 */
+	sb_start_intwrite(inode->i_sb);
 	handle = ext4_journal_start(inode, ext4_blocks_for_truncate(inode)+3);
 	if (IS_ERR(handle)) {
 		ext4_std_error(inode->i_sb, PTR_ERR(handle));
@@ -242,6 +247,7 @@ void ext4_evict_inode(struct inode *inode)
 		 * cleaned up.
 		 */
 		ext4_orphan_del(NULL, inode);
+		sb_end_intwrite(inode->i_sb);
 		goto no_delete;
 	}
 
@@ -273,6 +279,7 @@ void ext4_evict_inode(struct inode *inode)
 		stop_handle:
 			ext4_journal_stop(handle);
 			ext4_orphan_del(NULL, inode);
+			sb_end_intwrite(inode->i_sb);
 			goto no_delete;
 		}
 	}
@@ -301,6 +308,7 @@ void ext4_evict_inode(struct inode *inode)
 	else
 		ext4_free_inode(handle, inode);
 	ext4_journal_stop(handle);
+	sb_end_intwrite(inode->i_sb);
 	return;
 no_delete:
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
@@ -4701,11 +4709,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
-	/*
-	 * This check is racy but catches the common case. We rely on
-	 * __block_page_mkwrite() to do a reliable check.
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_pagefault(inode->i_sb);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -4773,5 +4777,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index f99a131..fe7c63f 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -44,6 +44,11 @@ static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 {
 	struct mmp_struct *mmp = (struct mmp_struct *)(bh->b_data);
 
+	/*
+	 * We protect against freezing so that we don't create dirty buffers
+	 * on frozen filesystem.
+	 */
+	sb_start_write(sb);
 	ext4_mmp_csum_set(sb, mmp);
 	mark_buffer_dirty(bh);
 	lock_buffer(bh);
@@ -51,6 +56,7 @@ static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 	get_bh(bh);
 	submit_bh(WRITE_SYNC, bh);
 	wait_on_buffer(bh);
+	sb_end_write(sb);
 	if (unlikely(!buffer_uptodate(bh)))
 		return 1;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..bd6a415 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -332,33 +332,17 @@ static void ext4_put_nojournal(handle_t *handle)
  * journal_end calls result in the superblock being marked dirty, so
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
- *
- * To avoid j_barrier hold in userspace when a user calls freeze(),
- * ext4 prevents a new handle from being started by s_frozen, which
- * is in an upper layer.
  */
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 {
 	journal_t *journal;
-	handle_t  *handle;
 
 	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
+	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
 	journal = EXT4_SB(sb)->s_journal;
-	handle = ext4_journal_current_handle();
-
-	/*
-	 * If a handle has been started, it should be allowed to
-	 * finish, otherwise deadlock could happen between freeze
-	 * and others(e.g. truncate) due to the restart of the
-	 * journal handle if the filesystem is forzen and active
-	 * handles are not stopped.
-	 */
-	if (!handle)
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
-
 	if (!journal)
 		return ext4_get_nojournal();
 	/*
@@ -2723,6 +2707,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
 
+	sb_start_write(sb);
 	for (group = elr->lr_next_group; group < ngroups; group++) {
 		gdp = ext4_get_group_desc(sb, group, NULL);
 		if (!gdp) {
@@ -2749,6 +2734,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
 	}
+	sb_end_write(sb);
 
 	return ret;
 }
@@ -4302,10 +4288,8 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+	if (journal)
 		ret = ext4_journal_force_commit(journal);
-	}
 
 	return ret;
 }
@@ -4337,9 +4321,8 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
  * gives us a chance to flush the journal completely and mark the fs clean.
  *
  * Note that only this function cannot bring a filesystem to be in a clean
- * state independently, because ext4 prevents a new handle from being started
- * by @sb->s_frozen, which stays in an upper layer.  It thus needs help from
- * the upper layer.
+ * state independently. It relies on upper layer to stop all data & metadata
+ * modifications.
  */
 static int ext4_freeze(struct super_block *sb)
 {
@@ -4366,7 +4349,7 @@ static int ext4_freeze(struct super_block *sb)
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	error = ext4_commit_super(sb, 1);
 out:
-	/* we rely on s_frozen to stop further updates */
+	/* we rely on upper layer to stop further updates */
 	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return error;
 }
-- 
1.7.1
