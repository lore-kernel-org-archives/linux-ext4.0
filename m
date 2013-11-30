From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: enable punch hole for bigalloc
Date: Sat, 30 Nov 2013 22:03:38 +0800
Message-ID: <1385820218-4673-1-git-send-email-wenqing.lz@taobao.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Lukas Czerner <lczerner@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50570 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab3K3OAx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Nov 2013 09:00:53 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so15913165pbc.24
        for <linux-ext4@vger.kernel.org>; Sat, 30 Nov 2013 06:00:52 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (d23142c6), ext4 has supported punch hole for
a file system with bigalloc feature.  But we forgot to enable it.  This
commit fixes it.

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0757634..2d73587 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3513,11 +3513,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	if (!S_ISREG(inode->i_mode))
 		return -EOPNOTSUPP;
 
-	if (EXT4_SB(sb)->s_cluster_ratio > 1) {
-		/* TODO: Add support for bigalloc file systems */
-		return -EOPNOTSUPP;
-	}
