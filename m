From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] jbd: Check return value of blkdev_issue_flush()
Date: Mon,  9 Jul 2012 23:45:06 +0200
Message-ID: <1341870307-11803-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2GIVpK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 17:45:10 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 745ACA2111
	for <linux-ext4@vger.kernel.org>; Mon,  9 Jul 2012 23:45:09 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkdev_issue_flush() can fail. Make sure the error gets properly propagated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/recovery.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

 I have queued this patch in my tree and plan to send it to Linus in the
next merge window.

diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index 008bf06..a748fe2 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -265,8 +265,11 @@ int journal_recover(journal_t *journal)
 	if (!err)
 		err = err2;
 	/* Flush disk caches to get replayed data on the permanent storage */
-	if (journal->j_flags & JFS_BARRIER)
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+	if (journal->j_flags & JFS_BARRIER) {
+		err2 = blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+		if (!err)
+			err = err2;
+	}
 
 	return err;
 }
-- 
1.7.1

