Return-Path: <SRS0=k8Ev=N4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43329 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeKQTRR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Nov 2018 14:17:17 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: compare old and new mode before setting update_mode flag
Date: Sat, 17 Nov 2018 17:01:00 +0800
Message-Id: <20181117090100.29063-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If new mode is the same as old mode we don't have to reset
inode mode in the rest of the code, so compare old and new
mode before setting update_mode flag.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/acl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/acl.c b/fs/ext2/acl.c
index cf4c77f8dd08..f4dd728393c8 100644
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -226,7 +226,8 @@ ext2_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		error = posix_acl_update_mode(inode, &mode, &acl);
 		if (error)
 			return error;
-		update_mode = 1;
+		if (mode != inode->i_mode)
+			update_mode = 1;
 	}
 	error = __ext2_set_acl(inode, acl, type);
 	if (!error && update_mode) {
-- 
2.17.2
