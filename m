From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] ext3: fix compilation with quotas enabled
Date: Thu, 23 Oct 2008 20:28:39 +0200
Message-ID: <20081023182839.GA25764@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: torvalds@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:40543 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbYJWS2t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2008 14:28:49 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An error path ext3_quota_on reference the nd variable that is gone now.
Instead of fixing this in place change the code slightly so that we use
one single callsite for path_put instead of three.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ext3/super.c
===================================================================
--- linux-2.6.orig/fs/ext3/super.c	2008-10-23 20:23:04.000000000 +0200
+++ linux-2.6/fs/ext3/super.c	2008-10-23 20:28:20.000000000 +0200
@@ -2811,9 +2811,10 @@ static int ext3_quota_on(struct super_bl
 
 	/* Quotafile not on the same filesystem? */
 	if (path.mnt->mnt_sb != sb) {
-		path_put(&path);
-		return -EXDEV;
+		err = -EXDEV;
+		goto out_path_put;
 	}
+
 	/* Journaling quota? */
 	if (EXT3_SB(sb)->s_qf_names[type]) {
 		/* Quotafile not of fs root? */
@@ -2835,13 +2836,12 @@ static int ext3_quota_on(struct super_bl
 		journal_lock_updates(EXT3_SB(sb)->s_journal);
 		err = journal_flush(EXT3_SB(sb)->s_journal);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
-		if (err) {
-			path_put(&nd.path);
-			return err;
-		}
+		if (err)
+			goto out_path_put;
 	}
 
 	err = vfs_quota_on_path(sb, type, format_id, &path);
+ out_path_put:
 	path_put(&path);
 	return err;
 }
