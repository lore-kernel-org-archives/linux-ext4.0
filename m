From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: take i_mutex in ext4_symlink to eliminate a warning from ext4_truncate
Date: Wed, 27 Mar 2013 21:19:07 +0800
Message-ID: <1364390347-4360-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:63320 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3C0ND3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Mar 2013 09:03:29 -0400
Received: by mail-pb0-f42.google.com with SMTP id xb4so5255775pbc.15
        for <linux-ext4@vger.kernel.org>; Wed, 27 Mar 2013 06:03:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (8e4061cb), we will get a warning from
ext4_truncate when i_mutex isn't taken.  Here the assumption is that
i_mutex should be taken when we do a truncation.  In ext4_symlink we
could need to call ext4_truncate to trim some blocks beyond i_size, but
the i_mutex isn't taken.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/namei.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3825d6a..d75f91a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2856,7 +2856,9 @@ retry:
 		ext4_journal_stop(handle);
 		if (err)
 			goto err_drop_inode;
+		mutex_lock(&inode->i_mutex);
 		err = __page_symlink(inode, symname, l, 1);
+		mutex_unlock(&inode->i_mutex);
 		if (err)
 			goto err_drop_inode;
 		/*
-- 
1.7.12.rc2.18.g61b472e

