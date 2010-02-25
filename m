From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: explicitly remove inode from orphan list after failed direct io
Date: Fri, 26 Feb 2010 00:20:06 +0300
Message-ID: <1267132807-5882-2-git-send-email-dmonakhov@openvz.org>
References: <1267132807-5882-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57660 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933352Ab0BYVUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Feb 2010 16:20:17 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so3261752bwz.21
        for <linux-ext4@vger.kernel.org>; Thu, 25 Feb 2010 13:20:17 -0800 (PST)
In-Reply-To: <1267132807-5882-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise non empty orphan list will be triggered on umount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8c00127..0383b18 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3467,6 +3467,9 @@ retry:
 			 * but cannot extend i_size. Bail out and pretend
 			 * the write failed... */
 			ret = PTR_ERR(handle);
+			if (inode->i_nlink)
+				ext4_orphan_del(NULL, inode);
+
 			goto out;
 		}
 		if (inode->i_nlink)
-- 
1.6.6

