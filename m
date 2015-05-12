From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 3/3 v2] ext4 crypto: use inode number for xts_tweak
Date: Tue, 12 May 2015 14:31:35 -0700
Message-ID: <20150512213135.GA37624@jaegeuk-mac02.mot.com>
References: <1431465665-36803-1-git-send-email-jaegeuk@kernel.org>
 <1431465665-36803-2-git-send-email-jaegeuk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39278 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964847AbbELVbk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 17:31:40 -0400
Content-Disposition: inline
In-Reply-To: <1431465665-36803-2-git-send-email-jaegeuk@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry for the noise.

Chnage log from v1:
 - fix wrong code changes.

-- >8 --
>From 2c5474450be7811d9553b3920fb0ed0681f9fddd Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Tue, 12 May 2015 14:14:49 -0700
Subject: [PATCH] ext4 crypto: use inode number for xts_tweak

This patch was from:

"f2fs crypto: use inode number for xts_tweak

Previoulsy when making xts_tweak, page->index was used.
But, when it supports fcollapse, the block address was moved, so that we can
lose the original page->index, which causes decryption failure.

In order to avoid that, let's use the inode->i_ino for xfs_tweak hint."

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/crypto.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f265c08..7ae6c3d 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -337,7 +337,6 @@ typedef enum {
 static int ext4_page_crypto(struct ext4_crypto_ctx *ctx,
 			    struct inode *inode,
 			    ext4_direction_t rw,
-			    pgoff_t index,
 			    struct page *src_page,
 			    struct page *dest_page)
 
@@ -382,10 +381,10 @@ static int ext4_page_crypto(struct ext4_crypto_ctx *ctx,
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		ext4_crypt_complete, &ecr);
 
-	BUILD_BUG_ON(EXT4_XTS_TWEAK_SIZE < sizeof(index));
-	memcpy(xts_tweak, &index, sizeof(index));
-	memset(&xts_tweak[sizeof(index)], 0,
-	       EXT4_XTS_TWEAK_SIZE - sizeof(index));
+	BUILD_BUG_ON(EXT4_XTS_TWEAK_SIZE < sizeof(inode->i_ino));
+	memcpy(xts_tweak, &inode->i_ino, sizeof(inode->i_ino));
+	memset(&xts_tweak[sizeof(inode->i_ino)], 0,
+	       EXT4_XTS_TWEAK_SIZE - sizeof(inode->i_ino));
 
 	sg_init_table(&dst, 1);
 	sg_set_page(&dst, dest_page, PAGE_CACHE_SIZE, 0);
@@ -459,7 +458,7 @@ struct page *ext4_encrypt(struct inode *inode,
 	ctx->flags |= EXT4_WRITE_PATH_FL;
 	ctx->w.bounce_page = ciphertext_page;
 	ctx->w.control_page = plaintext_page;
-	err = ext4_page_crypto(ctx, inode, EXT4_ENCRYPT, plaintext_page->index,
+	err = ext4_page_crypto(ctx, inode, EXT4_ENCRYPT,
 			       plaintext_page, ciphertext_page);
 	if (err) {
 		ext4_release_crypto_ctx(ctx);
@@ -487,7 +486,7 @@ int ext4_decrypt(struct ext4_crypto_ctx *ctx, struct page *page)
 	BUG_ON(!PageLocked(page));
 
 	return ext4_page_crypto(ctx, page->mapping->host,
-				EXT4_DECRYPT, page->index, page, page);
+				EXT4_DECRYPT, page, page);
 }
 
 /*
@@ -512,7 +511,6 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 	struct ext4_crypto_ctx	*ctx;
 	struct page		*ciphertext_page = NULL;
 	struct bio		*bio;
-	ext4_lblk_t		lblk = ex->ee_block;
 	ext4_fsblk_t		pblk = ext4_ext_pblock(ex);
 	unsigned int		len = ext4_ext_get_actual_len(ex);
 	int			err = 0;
@@ -540,7 +538,7 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 	ctx->w.bounce_page = ciphertext_page;
 
 	while (len--) {
-		err = ext4_page_crypto(ctx, inode, EXT4_ENCRYPT, lblk,
+		err = ext4_page_crypto(ctx, inode, EXT4_ENCRYPT,
 				       ZERO_PAGE(0), ciphertext_page);
 		if (err)
 			goto errout;
-- 
2.1.1
