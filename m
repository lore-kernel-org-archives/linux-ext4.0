From: akpm@linux-foundation.org
Subject: - ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:05 -0700
Message-ID: <200707162057.l6GKv5JT002154@imap1.linux-foundation.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@sandeen.net,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759837AbXGPVRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix deadlock in ext4_remount() and orphan list handling
has been removed from the -mm tree.  Its filename was
     ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 8 insertions(+)

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

origin.patch
