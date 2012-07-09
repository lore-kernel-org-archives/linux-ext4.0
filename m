From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext3: Check return value of blkdev_issue_flush()
Date: Mon,  9 Jul 2012 23:45:07 +0200
Message-ID: <1341870307-11803-2-git-send-email-jack@suse.cz>
References: <1341870307-11803-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab2GIVpL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2012 17:45:11 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id CD0FDA2111
	for <linux-ext4@vger.kernel.org>; Mon,  9 Jul 2012 23:45:10 +0200 (CEST)
In-Reply-To: <1341870307-11803-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

blkdev_issue_flush() can fail. Make sure the error gets properly propagated.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/fsync.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

 I have queued this patch in my tree and plan to send it to Linus in the
next merge window.

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index d4dff27..b31dbd4 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -92,8 +92,13 @@ int ext3_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * disk caches manually so that data really is on persistent
 	 * storage
 	 */
-	if (needs_barrier)
-		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+	if (needs_barrier) {
+		int err;
+
+		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+		if (!ret)
+			ret = err;
+	}
 out:
 	trace_ext3_sync_file_exit(inode, ret);
 	return ret;
-- 
1.7.1

