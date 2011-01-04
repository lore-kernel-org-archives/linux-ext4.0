From: yangsheng <sickamd@gmail.com>
Subject: [PATCH resend] Update atime from future.
Date: Tue,  4 Jan 2011 16:56:58 +0800
Message-ID: <1294131418-3835-1-git-send-email-sickamd@gmail.com>
Cc: adilger@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, swhiteho@redhat.com,
	yangsheng <sickamd@gmail.com>, sickadm@gmail.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab1ADI52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Jan 2011 03:57:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If atime has been wrong set to future, then it cannot
be updated back to current time.

CC: swhiteho@redhat.com
Signed-off-by: sickadm@gmail.com
Reviewed-by: adilger@dilger.ca
---
 fs/inode.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..9cf7375 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1446,6 +1446,8 @@ sector_t bmap(struct inode *inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
+#define RELATIME_MARGIN (24 * 60 * 60)
+
 /*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
@@ -1469,10 +1471,16 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
-	 * Is the previous atime value older than a day? If yes,
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < -RELATIME_MARGIN)
+		return 1;
+	/*
+	 * Is the previous atime value old than a day? If yes,
 	 * update atime:
 	 */
-	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= RELATIME_MARGIN)
 		return 1;
 	/*
 	 * Good, we can skip the atime update:
-- 
1.7.2.3

