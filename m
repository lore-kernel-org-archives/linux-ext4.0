From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] ext4: remove a duplicate call in ext4_init_new_dir()
Date: Tue, 12 Aug 2014 23:18:29 +0800
Message-ID: <1407856709-18612-1-git-send-email-wangshilong1991@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38865 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaHLPTS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Aug 2014 11:19:18 -0400
Received: by mail-pa0-f47.google.com with SMTP id kx10so12988340pab.6
        for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2014 08:19:17 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([223.65.191.205])
        by mx.google.com with ESMTPSA id qi7sm14921733pbc.14.2014.08.12.08.19.16
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Aug 2014 08:19:17 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

ext4_journal_get_write_access() has just been called in ext4_append()
calling it again here is duplicated.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/ext4/namei.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3520ab8..6d0d01f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2390,10 +2390,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	dir_block = ext4_append(handle, inode, &block);
 	if (IS_ERR(dir_block))
 		return PTR_ERR(dir_block);
-	BUFFER_TRACE(dir_block, "get_write_access");
-	err = ext4_journal_get_write_access(handle, dir_block);
-	if (err)
-		goto out;
 	de = (struct ext4_dir_entry_2 *)dir_block->b_data;
 	ext4_init_dot_dotdot(inode, de, blocksize, csum_size, dir->i_ino, 0);
 	set_nlink(inode, 2);
-- 
1.9.3

