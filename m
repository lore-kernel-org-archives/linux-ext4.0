From: akpm@linux-foundation.org
Subject: + ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:03:29 -0700
Message-ID: <200706122103.l5CL3Tti021131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@sandeen.net
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix deadlock in ext4_remount() and orphan list handling
has been added to the -mm tree.  Its filename is
     ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4: fix deadlock in ext4_remount() and orphan list handling
From: Jan Kara <jack@suse.cz>

ext4_orphan_add() and ext4_orphan_del() functions lock sb->s_lock with a
transaction started with ext4_mark_recovery_complete() waits for a transaction
holding sb->s_lock, thus leading to a possible deadlock.  At the moment we
call ext4_mark_recovery_complete() from ext4_remount() we have done all the
work needed for remounting and thus we are safe to drop sb->s_lock before we
wait for transactions to commit.  Note that at this moment we are still
guarded by s_umount lock against other remounts/umounts.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN fs/ext4/super.c~ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling
+++ a/fs/ext4/super.c
@@ -2222,12 +2222,14 @@ static void ext4_mark_recovery_complete(
 
 	jbd2_journal_lock_updates(journal);
 	jbd2_journal_flush(journal);
+	lock_super(sb);
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		sb->s_dirt = 0;
 		ext4_commit_super(sb, es, 1);
 	}
+	unlock_super(sb);
 	jbd2_journal_unlock_updates(journal);
 }
 
@@ -2416,7 +2418,13 @@ static int ext4_remount (struct super_bl
 			    (sbi->s_mount_state & EXT4_VALID_FS))
 				es->s_state = cpu_to_le16(sbi->s_mount_state);
 
+			/*
+			 * We have to unlock super so that we can wait for
+			 * transactions.
+			 */
+			unlock_super(sb);
 			ext4_mark_recovery_complete(sb, es);
+			lock_super(sb);
 		} else {
 			__le32 ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
_

Patches currently in -mm which might be from jack@suse.cz are

udf-fix-possible-leakage-of-blocks.patch
udf-fix-possible-leakage-of-blocks-fix.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
