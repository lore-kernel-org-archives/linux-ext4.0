From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] ext4: fix memory leak when symlink decryption fails
Date: Mon, 12 Sep 2016 12:16:46 -0700
Message-ID: <1473707806-37537-1-git-send-email-ebiggers@google.com>
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        jaegeuk@kernel.org, Eric Biggers <ebiggers@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35863 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbcILTRW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Sep 2016 15:17:22 -0400
Received: by mail-pf0-f176.google.com with SMTP id 128so55076568pfb.3
        for <linux-ext4@vger.kernel.org>; Mon, 12 Sep 2016 12:17:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bug was introduced in v4.8-rc1.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/symlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 4d83d9e..04a7850 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -65,13 +65,12 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	res = fscrypt_fname_alloc_buffer(inode, cstr.len, &pstr);
 	if (res)
 		goto errout;
+	paddr = pstr.name;
 
 	res = fscrypt_fname_disk_to_usr(inode, 0, 0, &cstr, &pstr);
 	if (res < 0)
 		goto errout;
 
-	paddr = pstr.name;
