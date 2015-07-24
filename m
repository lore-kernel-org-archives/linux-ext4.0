From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] ext4: update c/mtime on truncate up
Date: Fri, 24 Jul 2015 14:56:38 +0800
Message-ID: <1437720998-1208-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>, Zirong Lang <zorro.lang@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34441 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbGXG6A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Jul 2015 02:58:00 -0400
Received: by pdbbh15 with SMTP id bh15so9123156pdb.1
        for <linux-ext4@vger.kernel.org>; Thu, 23 Jul 2015 23:58:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 3da40c7b0898 ("ext4: only call ext4_truncate when size <= isize")
introduced a bug that c/mtime is not updated on truncate up.

Fix the issue by setting c/mtime explicitly in the truncate up case.

Note that ftruncate(2) is not affected, so you won't see this bug using
truncate(1) and xfs_io(1).

Signed-off-by: Zirong Lang <zorro.lang@gmail.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/ext4/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cecf9aa..2442eb0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4725,6 +4725,14 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
 			}
+			/*
+			 * Update c/mtime on truncate up, ext4_truncate() will
+			 * update c/mtime in shrink case below
+			 */
+			if (!shrink) {
+				inode->i_mtime = ext4_current_time(inode);
+				inode->i_ctime = inode->i_mtime;
+			}
 			down_write(&EXT4_I(inode)->i_data_sem);
 			EXT4_I(inode)->i_disksize = attr->ia_size;
 			rc = ext4_mark_inode_dirty(handle, inode);
-- 
1.8.3.1

