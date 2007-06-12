From: akpm@linux-foundation.org
Subject: + ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch added to -mm tree
Date: Tue, 12 Jun 2007 14:03:27 -0700
Message-ID: <200706122103.l5CL3RVE021128@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, sandeen@sandeen.net
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750950AbXFLVDj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2007 17:03:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix deadlock in ext3_remount() and orphan list handling
has been added to the -mm tree.  Its filename is
     ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 8 insertions(+)

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

udf-fix-possible-leakage-of-blocks.patch
udf-fix-possible-leakage-of-blocks-fix.patch
ext2-fix-a-comment-when-ext2_release_file-is-called.patch
ext3-fix-deadlock-in-ext3_remount-and-orphan-list-handling.patch
ext4-fix-deadlock-in-ext4_remount-and-orphan-list-handling.patch
