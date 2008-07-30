From: akpm@linux-foundation.org
Subject: + ext3-add-checks-for-errors-from-jbd.patch added to -mm tree
Date: Tue, 29 Jul 2008 19:52:24 -0700
Message-ID: <200807300252.m6U2qOif003320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, jack@ucw.cz,
	linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: add checks for errors from jbd
has been added to the -mm tree.  Its filename is
     ext3-add-checks-for-errors-from-jbd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: add checks for errors from jbd
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
@@ -2280,7 +2281,9 @@ static void ext3_mark_recovery_complete(
 	journal_t *journal = EXT3_SB(sb)->s_journal;
 
 	journal_lock_updates(journal);
-	journal_flush(journal);
+	if (journal_flush(journal) < 0)
+		goto out;
+
 	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
@@ -2289,6 +2292,8 @@ static void ext3_mark_recovery_complete(
 		ext3_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
+
+out:
 	journal_unlock_updates(journal);
 }
 
@@ -2388,7 +2393,13 @@ static void ext3_write_super_lockfs(stru
 
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
@@ -2806,8 +2817,12 @@ static int ext3_quota_on(struct super_bl
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
 
 	path_put(&nd.path);
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are

linux-next.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch

