From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] ext4: remove unneeded code in ext4_unlink
Date: Mon, 24 Nov 2014 15:43:47 +0900
Message-ID: <003601d007b1$ffde29e0$ff9a7da0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:58813 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaKXGnu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2014 01:43:50 -0500
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NFJ00FRV6P0H5C0@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 24 Nov 2014 15:43:48 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Setting retval to zero is not needed in ext4_unlink.
Remove unneeded code.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4262118..2291923 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2814,7 +2814,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
-	retval = 0;
 
 end_unlink:
 	brelse(bh);
-- 
1.7.11-rc0

