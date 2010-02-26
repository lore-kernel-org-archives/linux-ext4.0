From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext3: explicitly remove inode from orphan list after failed direct_io
Date: Fri, 26 Feb 2010 16:05:08 +0300
Message-ID: <1267189508-5273-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:19704 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936010Ab0BZNFO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Feb 2010 08:05:14 -0500
Received: by fg-out-1718.google.com with SMTP id d23so174201fga.1
        for <linux-ext4@vger.kernel.org>; Fri, 26 Feb 2010 05:05:13 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise non empty orphan list will be triggered on umount.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index cf0e3aa..2522106 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1818,6 +1818,9 @@ retry:
 			 * but cannot extend i_size. Bail out and pretend
 			 * the write failed... */
 			ret = PTR_ERR(handle);
+			if (inode->i_nlink)
+				ext3_orphan_del(NULL, inode);
+
 			goto out;
 		}
 		if (inode->i_nlink)
-- 
1.6.6

