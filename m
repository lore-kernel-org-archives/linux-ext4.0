From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] f2fs: do not unnecessarily null-terminate encrypted symlink data
Date: Thu, 22 Sep 2016 13:31:48 -0700
Message-ID: <1474576309-86917-2-git-send-email-ebiggers@google.com>
References: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35783 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756200AbcIVUcZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Sep 2016 16:32:25 -0400
Received: by mail-pf0-f176.google.com with SMTP id z123so34049141pfz.2
        for <linux-ext4@vger.kernel.org>; Thu, 22 Sep 2016 13:32:25 -0700 (PDT)
In-Reply-To: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Null-terminating the fscrypt_symlink_data on read is unnecessary because
it is not string data --- it contains binary ciphertext.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/namei.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index afd5633..5b4733e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1010,7 +1010,6 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	struct fscrypt_str cstr = FSTR_INIT(NULL, 0);
 	struct fscrypt_str pstr = FSTR_INIT(NULL, 0);
 	struct fscrypt_symlink_data *sd;
-	loff_t size = min_t(loff_t, i_size_read(inode), PAGE_SIZE - 1);
 	u32 max_size = inode->i_sb->s_blocksize;
 	int res;
 
@@ -1025,7 +1024,6 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	if (IS_ERR(cpage))
 		return ERR_CAST(cpage);
 	caddr = page_address(cpage);
-	caddr[size] = 0;
 
 	/* Symlink is encrypted */
 	sd = (struct fscrypt_symlink_data *)caddr;
-- 
2.8.0.rc3.226.g39d4020

