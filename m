Return-Path: <SRS0=k8Ev=N4=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:41823 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbeKQTSG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 17 Nov 2018 14:18:06 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext4: compare old and new mode before setting update_mode flag
Date: Sat, 17 Nov 2018 17:01:52 +0800
Message-Id: <20181117090152.29132-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If new mode is the same as old mode we don't have to reset
inode mode in the rest of the code, so compare old and new
mode before setting update_mode flag.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext4/acl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index c1d570ee1d9f..8c7bbf3e566d 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -248,7 +248,8 @@ ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		error = posix_acl_update_mode(inode, &mode, &acl);
 		if (error)
 			goto out_stop;
-		update_mode = 1;
+		if (mode != inode->i_mode)
+			update_mode = 1;
 	}
 
 	error = __ext4_set_acl(handle, inode, type, acl, 0 /* xattr_flags */);
-- 
2.17.2
