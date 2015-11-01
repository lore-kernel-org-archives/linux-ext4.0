From: Xu Cang <cangxumu@gmail.com>
Subject: [PATCH] ext4:cyrpto two minor fixes for checking return value of ext4_get_encryption_info()
Date: Sun, 1 Nov 2015 17:03:45 -0500
Message-ID: <CAOjcEBJ_rC2Vh+XHtsGPPBerQ73QZK5cnFE_Mgp_zh07eem-Zg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:36099 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbKAWDr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 17:03:47 -0500
Received: by wibvt6 with SMTP id vt6so8396467wib.3
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2015 14:03:45 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To make it consistent with other occurrences, check "res" instead of "res < 0".

diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index ad05069..a222996 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -194,7 +194,7 @@ int ext4_inherit_context(struct inode *parent,
struct inode *child)
        int res;

        res = ext4_get_encryption_info(parent);
-       if (res < 0)
+       if (res)
                return res;
        ci = EXT4_I(parent)->i_crypt_info;
        if (ci == NULL)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 52a79d4..6ca06d5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -968,7 +968,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
        /* Check if the directory is encrypted */
        if (ext4_encrypted_inode(dir)) {
                err = ext4_get_encryption_info(dir);
-               if (err < 0) {
+               if (err) {
                        brelse(bh);
                        return err;
                }
