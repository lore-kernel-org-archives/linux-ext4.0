From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH]
Date: Thu, 11 Aug 2011 23:29:22 +0200
Message-ID: <201108112329.23043.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Dave Chinner <david@fromorbit.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:35726 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1HKV1o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Aug 2011 17:27:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: fs / ext3: Always unlock updates in ext3_freeze()

In analogy with ext4 make ext3_freeze() always call
journal_unlock_updates() to prevent it from leaving a locked mutex
behind.  Accordingly, modify ext3_unfreeze() so that it doesn't
call journal_unlock_updates() any more.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 fs/ext3/super.c |   39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

Index: linux/fs/ext3/super.c
===================================================================
--- linux.orig/fs/ext3/super.c
+++ linux/fs/ext3/super.c
@@ -2535,30 +2535,28 @@ static int ext3_sync_fs(struct super_blo
  */
 static int ext3_freeze(struct super_block *sb)
 {
-	int error = 0;
+	int error;
 	journal_t *journal;
 
-	if (!(sb->s_flags & MS_RDONLY)) {
-		journal = EXT3_SB(sb)->s_journal;
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
 
-		/* Now we set up the journal barrier. */
-		journal_lock_updates(journal);
+	journal = EXT3_SB(sb)->s_journal;
 
-		/*
-		 * We don't want to clear needs_recovery flag when we failed
-		 * to flush the journal.
-		 */
-		error = journal_flush(journal);
-		if (error < 0)
-			goto out;
-
-		/* Journal blocked and flushed, clear needs_recovery flag. */
-		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
-		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
-		if (error)
-			goto out;
-	}
-	return 0;
+	/* Now we set up the journal barrier. */
+	journal_lock_updates(journal);
+
+	/*
+	 * We don't want to clear needs_recovery flag when we failed
+	 * to flush the journal.
+	 */
+	error = journal_flush(journal);
+	if (error < 0)
+		goto out;
+
+	/* Journal blocked and flushed, clear needs_recovery flag. */
+	EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
+	error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
 
 out:
 	journal_unlock_updates(journal);
@@ -2577,7 +2575,6 @@ static int ext3_unfreeze(struct super_bl
 		EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
 		unlock_super(sb);
-		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
 	return 0;
 }
