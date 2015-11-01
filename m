From: Xu Cang <cangxumu@gmail.com>
Subject: [PATCH] ext4: use le32_to_cpu for ee_block in crypto.c
Date: Sun, 1 Nov 2015 16:14:49 -0500
Message-ID: <CAOjcEBL4eOHAkVpoaMby=Dm9ot5egFG27aGSRAwMYnnQBTBT0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:34556 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbbKAVOu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Nov 2015 16:14:50 -0500
Received: by wicuk10 with SMTP id uk10so8318900wic.1
        for <linux-ext4@vger.kernel.org>; Sun, 01 Nov 2015 13:14:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index af06830..1a08350 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -389,7 +389,7 @@ int ext4_encrypted_zeroout(struct inode *inode,
struct ext4_extent *ex)
        struct ext4_crypto_ctx  *ctx;
        struct page             *ciphertext_page = NULL;
        struct bio              *bio;
-       ext4_lblk_t             lblk = ex->ee_block;
+       ext4_lblk_t             lblk = le32_to_cpu(ex->ee_block);
        ext4_fsblk_t            pblk = ext4_ext_pblock(ex);
        unsigned int            len = ext4_ext_get_actual_len(ex);
        int                     ret, err = 0;
