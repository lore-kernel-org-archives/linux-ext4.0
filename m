From: akpm@linux-foundation.org
Subject: - ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:02 -0700
Message-ID: <200707162057.l6GKv2Ng002151@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@sandeen.net,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix deadlock in ext3_remount() and orphan list handling
has been removed from the -mm tree.  Its filename was
     ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: fix deadlock in ext3_remount() and orphan list handling
From: Jan Kara <jack@suse.cz>

ext3_orphan_add() and ext3_orphan_del() functions lock sb->s_lock with a
transaction started with ext3_mark_recovery_complete() waits for a transaction
holding sb->s_lock, thus leading to a possible deadlock.  At the moment we
call ext3_mark_recovery_complete() from ext3_remount() we have done all the
work needed for remounting and thus we are safe to drop sb->s_lock before we
wait for transactions to commit.  Note that at this moment we are still
guarded by s_umount lock against other remounts/umounts.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ext3/super.c~ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling
+++ a/fs/ext3/super.c
@@ -2147,12 +2147,14 @@ static void ext3_mark_recovery_complete(
 
 	journal_lock_updates(journal);
 	journal_flush(journal);
+	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		sb->s_dirt = 0;
 		ext3_commit_super(sb, es, 1);
 	}
+	unlock_super(sb);
 	journal_unlock_updates(journal);
 }
 
@@ -2341,7 +2343,13 @@ static int ext3_remount (struct super_bl
 			    (sbi->s_mount_state & EXT3_VALID_FS))
 				es->s_state = cpu_to_le16(sbi->s_mount_state);
 
+			/*
+			 * We have to unlock super so that we can wait for
+			 * transactions.
+			 */
+			unlock_super(sb);
 			ext3_mark_recovery_complete(sb, es);
+			lock_super(sb);
 		} else {
 			__le32 ret;
 			if ((ret = EXT3_HAS_RO_COMPAT_FEATURE(sb,
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
