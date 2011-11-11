From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: remove unneeded variable.
Date: Sat, 12 Nov 2011 00:02:24 +0900
Message-ID: <1321023744-16249-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34343 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab1KKPCj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Nov 2011 10:02:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ret2 is not needed in ext4_flush_completed_IO().

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/ext4/fsync.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 00a2cb7..40397ac 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -81,7 +81,6 @@ int ext4_flush_completed_IO(struct inode *inode)
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned long flags;
 	int ret = 0;
-	int ret2 = 0;
 
 	dump_completed_IO(inode);
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
@@ -105,12 +104,10 @@ int ext4_flush_completed_IO(struct inode *inode)
 		 */
 		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 		ret = ext4_end_io_nolock(io);
-		if (ret < 0)
-			ret2 = ret;
 		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
 	}
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-	return (ret2 < 0) ? ret2 : 0;
+	return (ret < 0) ? ret : 0;
 }
 
 /*
-- 
1.7.4.4

