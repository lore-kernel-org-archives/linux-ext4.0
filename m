From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext2: fix missing mutex_unlock in error path
Date: Tue, 14 Apr 2009 16:36:31 +0900
Message-ID: <20090414073631.GA4145@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:22249 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZDNHgh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 03:36:37 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add missing mutex_unlock in error path in ext2_quota_write()

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f983225..5c4afe6 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1395,8 +1395,10 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite)
+	if (len == towrite) {
+		mutex_unlock(&inode->i_mutex);
 		return err;
+	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;
