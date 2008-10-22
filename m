From: akpm@linux-foundation.org
Subject: [patch 4/7] ext3: add checks for errors from jbd
Date: Wed, 22 Oct 2008 14:15:01 -0700
Message-ID: <200810222115.m9MLF176026382@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, hidehiro.kawai.ez@hitachi.com,
	jack@ucw.cz, linux-ext4@vger.kernel.org, sfr@canb.auug.org.au,
	viro@zeniv.linux.org.uk
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755841AbYJVVPN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 17:15:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

If the journal has aborted due to a checkpointing failure, we have to
keep the contents of the journal space.  Otherwise, the filesystem will
lose uncheckpointed metadata completely and become inconsistent.  To
avoid this, we need to keep needs_recovery flag if checkpoint has
failed.

With this patch, ext3_put_super() detects a checkpointing failure from
the return value of journal_destroy(), then it invokes ext3_abort() to
make the filesystem read only and keep needs_recovery flag.  Errors
from journal_flush() are also handled by this patch in some places.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Jan Kara <jack@ucw.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/ioctl.c |   12 ++++++++----
 fs/ext3/super.c |   23 +++++++++++++++++++----
 2 files changed, 27 insertions(+), 8 deletions(-)

diff -puN fs/ext3/ioctl.c~ext3-add-checks-for-errors-from-jbd fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~ext3-add-checks-for-errors-from-jbd
+++ a/fs/ext3/ioctl.c
@@ -239,7 +239,7 @@ setrsvsz_out:
 	case EXT3_IOC_GROUP_EXTEND: {
 		ext3_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -254,8 +254,10 @@ setrsvsz_out:
 		}
 		err = ext3_group_extend(sb, EXT3_SB(sb)->s_es, n_blocks_count);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 group_extend_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
@@ -263,7 +265,7 @@ group_extend_out:
 	case EXT3_IOC_GROUP_ADD: {
 		struct ext3_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -280,8 +282,10 @@ group_extend_out:
 
 		err = ext3_group_add(sb, &input);
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err2 = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 group_add_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
diff -puN fs/ext3/super.c~ext3-add-checks-for-errors-from-jbd fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-add-checks-for-errors-from-jbd
+++ a/fs/ext3/super.c
@@ -393,7 +393,8 @@ static void ext3_put_super (struct super
 	int i;
 
 	ext3_xattr_put_super(sb);
-	journal_destroy(sbi->s_journal);
+	if (journal_destroy(sbi->s_journal) < 0)
+		ext3_abort(sb, __func__, "Couldn't clean up the journal");
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2296,7 +2297,9 @@ static void ext3_mark_recovery_complete(
 	journal_t *journal = EXT3_SB(sb)->s_journal;
 
 	journal_lock_updates(journal);
-	journal_flush(journal);
+	if (journal_flush(journal) < 0)
+		goto out;
+
 	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
@@ -2305,6 +2308,8 @@ static void ext3_mark_recovery_complete(
 		ext3_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
+
+out:
 	journal_unlock_updates(journal);
 }
 
@@ -2404,7 +2409,13 @@ static void ext3_write_super_lockfs(stru
 
 		/* Now we set up the journal barrier. */
 		journal_lock_updates(journal);
-		journal_flush(journal);
+
+		/*
+		 * We don't want to clear needs_recovery flag when we failed
+		 * to flush the journal.
+		 */
+		if (journal_flush(journal) < 0)
+			return;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
@@ -2822,8 +2833,12 @@ static int ext3_quota_on(struct super_bl
 		 * otherwise be livelocked...
 		 */
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
-		journal_flush(EXT3_SB(sb)->s_journal);
+		err = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
+		if (err) {
+			path_put(&nd.path);
+			return err;
+		}
 	}
 
 	err = vfs_quota_on_path(sb, type, format_id, &nd.path);
_
