From: yangsheng <sickamd@gmail.com>
Subject: [PATCH] Update atime from future.
Date: Wed, 29 Dec 2010 21:58:41 +0800
Message-ID: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, yangsheng <sickamd@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59716 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab0L2N7H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Dec 2010 08:59:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: sickamd@gmail.com
---
 fs/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index da85e56..6c8effd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
 		return 1;
 
 	/*
-	 * Is the previous atime value older than a day? If yes,
+	 * Is the previous atime value in future? If yes,
+	 * update atime:
+	 */
+	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
+		return 1;
+	/*
+	 * Is the previous atime value old than a day? If yes,
 	 * update atime:
 	 */
 	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
-- 
1.7.2.3

