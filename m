From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext3: fix incorrect block reservation on quota transfer.
Date: Tue, 08 Dec 2009 09:46:21 +0300
Message-ID: <1260254781-18041-2-git-send-email-dmonakhov@openvz.org>
References: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:36682 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932682AbZLHGqJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 01:46:09 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUB007MIN0X8400@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 08 Dec 2009 09:50:59 +0300 (MSK)
In-reply-to: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inside ->setattr() call  both ATTR_UID and ATTR_GID may be valid
This means that we end-up with transering all quotas. Add we have
to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in case of
QUOTA_INIT_BLOCKS.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 1c99eba..477927b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -3137,7 +3137,7 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
 		handle = ext3_journal_start(inode, EXT3_ALL_QUOTAS_INIT_BLOCKS(inode->i_sb)+
-					EXT3_QUOTA_DEL_BLOCKS(inode->i_sb)+3);
+					EXT3_ALL_QUOTAS_DEL_BLOCKS(inode->i_sb)+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
-- 
1.6.0.4

