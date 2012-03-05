From: Jan Kara <jack@suse.cz>
Subject: [PATCH 10/19] ext4: Convert to new freezing mechanism
Date: Mon,  5 Mar 2012 17:01:08 +0100
Message-ID: <1330963277-26336-11-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
	sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We remove most of frozen checks since upper layer takes care
of blocking all writes. We only have to handle protection in
ext4_page_mkwrite() in a special way because we cannot use
generic block_page_mkwrite().

CC: linux-ext4@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    7 ++-----
 fs/ext4/super.c |   29 +++++------------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..c65baf9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4593,11 +4593,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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
@@ -4665,5 +4661,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 502c61f..0f1024a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -289,33 +289,17 @@ static void ext4_put_nojournal(handle_t *handle)
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
@@ -4280,10 +4264,8 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+	if (journal)
 		ret = ext4_journal_force_commit(journal);
-	}
 
 	return ret;
 }
@@ -4315,9 +4297,8 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
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
@@ -4344,7 +4325,7 @@ static int ext4_freeze(struct super_block *sb)
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
