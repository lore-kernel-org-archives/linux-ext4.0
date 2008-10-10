From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 3/4] ext4: add checks for errors from jbd2
Date: Fri, 10 Oct 2008 18:00:37 +0900
Message-ID: <48EF19B5.2090200@hitachi.com>
References: <48EF168A.4000705@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, jack@suse.cz
To: tytso@mit.edu, adilger@sun.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752837AbYJJJA4@vger.kernel.org>
In-Reply-To: <48EF168A.4000705@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If the journal has aborted due to a checkpointing failure, we
have to keep the contents of the journal space.  Otherwise, the
filesystem will lose uncheckpointed metadata completely and
become inconsistent.  To avoid this, we need to keep needs_recovery
flag if checkpoint has failed.

With this patch, ext4_put_super() detects a checkpointing failure
from the return value of journal_destroy(), then it invokes
ext4_abort() to make the filesystem read only and keep
needs_recovery flag.  Errors from jbd2_journal_flush() are also
handled by this patch in some places.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/ext4/ioctl.c |   12 ++++++++----
 fs/ext4/super.c |   23 +++++++++++++++++++----
 2 files changed, 27 insertions(+), 8 deletions(-)

Index: linux-2.6.27-rc9-ex4-1/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/ioctl.c
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/ioctl.c
@@ -192,7 +192,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -206,8 +206,10 @@ setversion_out:
 
 		err = ext4_group_extend(sb, EXT4_SB(sb)->s_es, n_blocks_count);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
@@ -220,7 +222,7 @@ setversion_out:
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
-		int err;
+		int err, err2;
 
 		if (!capable(CAP_SYS_RESOURCE))
 			return -EPERM;
@@ -235,8 +237,10 @@ setversion_out:
 
 		err = ext4_group_add(sb, &input);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err == 0)
+			err = err2;
 		mnt_drop_write(filp->f_path.mnt);
 
 		return err;
Index: linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
===================================================================
--- linux-2.6.27-rc9-ex4-1.orig/fs/ext4/super.c
+++ linux-2.6.27-rc9-ex4-1/fs/ext4/super.c
@@ -507,7 +507,8 @@ static void ext4_put_super(struct super_
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
-	jbd2_journal_destroy(sbi->s_journal);
+	if (jbd2_journal_destroy(sbi->s_journal) < 0)
+		ext4_abort(sb, __func__, "Couldn't clean up the journal");
 	sbi->s_journal = NULL;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -2863,7 +2864,9 @@ static void ext4_mark_recovery_complete(
 	journal_t *journal = EXT4_SB(sb)->s_journal;
 
 	jbd2_journal_lock_updates(journal);
-	jbd2_journal_flush(journal);
+	if (jbd2_journal_flush(journal) < 0)
+		goto out;
+
 	lock_super(sb);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
@@ -2872,6 +2875,8 @@ static void ext4_mark_recovery_complete(
 		ext4_commit_super(sb, es, 1);
 	}
 	unlock_super(sb);
+
+out:
 	jbd2_journal_unlock_updates(journal);
 }
 
@@ -2972,7 +2977,13 @@ static void ext4_write_super_lockfs(stru
 
 		/* Now we set up the journal barrier. */
 		jbd2_journal_lock_updates(journal);
-		jbd2_journal_flush(journal);
+
+		/*
+		 * We don't want to clear needs_recovery flag when we failed
+		 * to flush the journal.
+		 */
+		if (jbd2_journal_flush(journal) < 0)
+			return;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
@@ -3412,8 +3423,12 @@ static int ext4_quota_on(struct super_bl
 		 * otherwise be livelocked...
 		 */
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
-		jbd2_journal_flush(EXT4_SB(sb)->s_journal);
+		err = jbd2_journal_flush(EXT4_SB(sb)->s_journal);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+		if (err) {
+			path_put(&nd.path);
+			return err;
+		}
 	}
 
 	err = vfs_quota_on_path(sb, type, format_id, &nd.path);
