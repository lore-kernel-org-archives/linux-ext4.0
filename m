From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 08/28] ext4: don't return to userspace after freezing the fs with a mutex held
Date: Tue,  1 Jun 2010 12:12:55 -0400
Message-ID: <1275408795-17487-8-git-send-email-tytso@mit.edu>
References: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56867 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0FAQNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:21 -0400
In-Reply-To: <1275408795-17487-1-git-send-email-tytso@mit.edu>
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
index e14d22c..00d09f5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,6 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3485,8 +3486,10 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal)
+	if (journal) {
+		vfs_check_frozen(sb, SB_FREEZE_WRITE);
 		ret = ext4_journal_force_commit(journal);
+	}
 
 	return ret;
 }
@@ -3535,18 +3538,16 @@ static int ext4_freeze(struct super_block *sb)
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
@@ -3563,7 +3564,6 @@ static int ext4_unfreeze(struct super_block *sb)
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
 	unlock_super(sb);
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return 0;
 }
 
-- 
1.6.6.1.1.g974db.dirty

