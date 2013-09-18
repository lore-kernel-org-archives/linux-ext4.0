From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH] ext4: drop unsed reclen variable from ext4_add_dirent_to_inline()
Date: Thu, 19 Sep 2013 00:17:30 +0400
Message-ID: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
Cc: Azat Khuzhin <a3at.mail@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org (open list:EXT4 FILE SYSTEM)
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:54019 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab3IRUSM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Sep 2013 16:18:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Functions that need in it, already calculate reclen from namelen by
themselves:
- ext4_find_dest_de()
- ext4_insert_dentry()

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
---
 fs/ext4/inline.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..809f285 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -994,11 +994,9 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	struct inode	*dir = dentry->d_parent->d_inode;
 	const char	*name = dentry->d_name.name;
 	int		namelen = dentry->d_name.len;
-	unsigned short	reclen;
 	int		err;
 	struct ext4_dir_entry_2 *de;
 
-	reclen = EXT4_DIR_REC_LEN(namelen);
 	err = ext4_find_dest_de(dir, inode, iloc->bh,
 				inline_start, inline_size,
 				name, namelen, &de);
-- 
1.8.4.rc3

