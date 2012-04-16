From: Jan Kara <jack@suse.cz>
Subject: [PATCH 17/27] ext4: Convert to new freezing mechanism
Date: Mon, 16 Apr 2012 18:13:55 +0200
Message-ID: <1334592845-22862-18-git-send-email-jack@suse.cz>
References: <1334592845-22862-1-git-send-email-jack@suse.cz>
Cc: dchinner@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334592845-22862-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We remove most of frozen checks since upper layer takes care
of blocking all writes. We only have to handle protection in
ext4_page_mkwrite() in a special way because we cannot use
generic block_page_mkwrite().

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
BugLink: https://bugs.launchpad.net/bugs/897421
Tested-by: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Tested-by: Dann Frazier <dann.frazier@canonical.com>
Tested-by: Massimo Morana <massimo.morana@canonical.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 ++-----
 fs/ext4/mmp.c   |   14 ++++++++++----
 fs/ext4/super.c |   31 +++++++------------------------
 3 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c77b0bd..bf568fb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4600,11 +4600,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -4672,5 +4668,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index ed6548d..4f63f90 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -10,14 +10,20 @@
  * Write the MMP block using WRITE_SYNC to try to get the block on-disk
  * faster.
  */
-static int write_mmp_block(struct buffer_head *bh)
+static int write_mmp_block(struct super_block *sb, struct buffer_head *bh)
 {
+	/*
+	 * We protect against freezing so that we don't create dirty buffers
+	 * on frozen filesystem.
+	 */
+	sb_start_write(sb);
 	mark_buffer_dirty(bh);
 	lock_buffer(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	get_bh(bh);
 	submit_bh(WRITE_SYNC, bh);
 	wait_on_buffer(bh);
+	sb_end_write(sb);
 	if (unlikely(!buffer_uptodate(bh)))
 		return 1;
 
@@ -120,7 +126,7 @@ static int kmmpd(void *data)
 		mmp->mmp_time = cpu_to_le64(get_seconds());
 		last_update_time = jiffies;
 
-		retval = write_mmp_block(bh);
+		retval = write_mmp_block(sb, bh);
 		/*
 		 * Don't spew too many error messages. Print one every
 		 * (s_mmp_update_interval * 60) seconds.
@@ -200,7 +206,7 @@ static int kmmpd(void *data)
 	mmp->mmp_seq = cpu_to_le32(EXT4_MMP_SEQ_CLEAN);
 	mmp->mmp_time = cpu_to_le64(get_seconds());
 
-	retval = write_mmp_block(bh);
+	retval = write_mmp_block(sb, bh);
 
 failed:
 	kfree(data);
@@ -299,7 +305,7 @@ skip:
 	seq = mmp_new_seq();
 	mmp->mmp_seq = cpu_to_le32(seq);
 
-	retval = write_mmp_block(bh);
+	retval = write_mmp_block(sb, bh);
 	if (retval)
 		goto failed;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..08c7326 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -290,33 +290,17 @@ static void ext4_put_nojournal(handle_t *handle)
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
@@ -2635,6 +2619,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 	sb = elr->lr_super;
 	ngroups = EXT4_SB(sb)->s_groups_count;
 
+	sb_start_write(sb);
 	for (group = elr->lr_next_group; group < ngroups; group++) {
 		gdp = ext4_get_group_desc(sb, group, NULL);
 		if (!gdp) {
@@ -2661,6 +2646,7 @@ static int ext4_run_li_request(struct ext4_li_request *elr)
 		elr->lr_next_sched = jiffies + elr->lr_timeout;
 		elr->lr_next_group = group + 1;
 	}
+	sb_end_write(sb);
 
 	return ret;
 }
@@ -4137,10 +4123,8 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+	if (journal)
 		ret = ext4_journal_force_commit(journal);
-	}
 
 	return ret;
 }
@@ -4172,9 +4156,8 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
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
@@ -4201,7 +4184,7 @@ static int ext4_freeze(struct super_block *sb)
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
