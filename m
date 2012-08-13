From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] jbd2: check return value of blkdev_issue_flush()
Date: Sun, 12 Aug 2012 23:38:40 -0400
Message-ID: <1344829121-23739-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44328 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab2HMDip (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2012 23:38:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkdev_issue_flush() can fail; make sure the error gets properly
propagated.

This is a port of the equivalent jbd patch from commit 349ecd6a3c0e.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/recovery.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 0131e43..626846b 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -289,8 +289,11 @@ int jbd2_journal_recover(journal_t *journal)
 	if (!err)
 		err = err2;
 	/* Make sure all replayed data is on permanent storage */
-	if (journal->j_flags & JBD2_BARRIER)
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+	if (journal->j_flags & JBD2_BARRIER) {
+		err2 = blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		if (!err)
+			err = err2;
+	}
 	return err;
 }
 
-- 
1.7.12.rc0.22.gcdd159b

