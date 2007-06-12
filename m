From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix deadlock of ext3_remount() and orphan list handling (fwd)
Date: Tue, 12 Jun 2007 17:54:39 +0200
Message-ID: <20070612155439.GE6590@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:47921 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753919AbXFLPlr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jun 2007 11:41:47 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Resending the message as I've screwed up the mailing list address...

									Honza
----- Forwarded message from Jan Kara <jack@suse.cz> -----

From: Jan Kara <jack@suse.cz>
To: ext4-devel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: [PATCH] Fix deadlock of ext3_remount() and orphan list handling

  Hi,

  attached patch should fix deadlock Mark Lord has experienced
(http://lkml.org/lkml/2007/6/8/601). Please have a look whether the change
looks sane. I think so but ...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

ext3_orphan_add() and ext3_orphan_del() functions lock sb->s_lock with
a transaction started with ext3_mark_recovery_complete() waits for
a transaction holding sb->s_lock, thus leading to a possible deadlock.
At the moment we call ext3_mark_recovery_complete() from ext3_remount()
we have done all the work needed for remounting and thus we are safe
to drop sb->s_lock before we wait for transactions to commit. Note
that at this moment we are still guarded by s_umount lock against
other remounts/umounts.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.22-rc4/fs/ext3/super.c linux-2.6.22-rc4-1-ext3_orphan_deadlock/fs/ext3/super.c
--- linux-2.6.22-rc4/fs/ext3/super.c	2007-06-11 12:29:06.000000000 +0200
+++ linux-2.6.22-rc4-1-ext3_orphan_deadlock/fs/ext3/super.c	2007-06-12 12:51:42.000000000 +0200
@@ -2139,12 +2139,14 @@ static void ext3_mark_recovery_complete(
 
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
 
@@ -2333,7 +2335,13 @@ static int ext3_remount (struct super_bl
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


----- End forwarded message -----
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
