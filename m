From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 37/53] ext4: don't return to userspace after freezing the fs with a mutex held
Date: Sun, 30 May 2010 22:49:50 -0400
Message-ID: <1275274206-3900-37-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44652 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab0EaCuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:22 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

commit 6b0310fbf087ad6e9e3b8392adca97cd77184084 upstream (as of v2.6.34-git13)

ext4_freeze() used jbd2_journal_lock_updates() which takes
the j_barrier mutex, and then returns to userspace.  The
kernel does not like this:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
lvcreate/1075 is leaving the kernel with locks still held!
1 lock held by lvcreate/1075:
 #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
jbd2_journal_lock_updates+0xe1/0xf0

Use vfs_check_frozen() added to ext4_journal_start_sb() and
ext4_force_commit() instead.

Addresses-Red-Hat-Bugzilla: #568503

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 252f30b..d85549c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -227,6 +227,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3391,8 +3392,10 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal)
+	if (journal) {
+		vfs_check_frozen(sb, SB_FREEZE_WRITE);
 		ret = ext4_journal_force_commit(journal);
+	}
 
 	return ret;
 }
@@ -3441,18 +3444,16 @@ static int ext4_freeze(struct super_block *sb)
 	 * the journal.
 	 */
 	error = jbd2_journal_flush(journal);
-	if (error < 0) {
-	out:
-		jbd2_journal_unlock_updates(journal);
-		return error;
-	}
+	if (error < 0)
+		goto out;
 
 	/* Journal blocked and flushed, clear needs_recovery flag. */
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	error = ext4_commit_super(sb, 1);
-	if (error)
-		goto out;
-	return 0;
+out:
+	/* we rely on s_frozen to stop further updates */
+	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	return error;
 }
 
 /*
@@ -3469,7 +3470,6 @@ static int ext4_unfreeze(struct super_block *sb)
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
 	unlock_super(sb);
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return 0;
 }
 
-- 
1.6.6.1.1.g974db.dirty

