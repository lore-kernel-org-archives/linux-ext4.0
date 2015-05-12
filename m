From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] ext4 crypto: use inode number for xts_tweak
Date: Tue, 12 May 2015 14:21:05 -0700
Message-ID: <1431465665-36803-2-git-send-email-jaegeuk@kernel.org>
References: <1431465665-36803-1-git-send-email-jaegeuk@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38503 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135AbbELVVX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 17:21:23 -0400
In-Reply-To: <1431465665-36803-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch was from:

"f2fs crypto: use inode number for xts_tweak

Previoulsy when making xts_tweak, page->index was used.
But, when it supports fcollapse, the block address was moved, so that we can
lose the original page->index, which causes decryption failure.

In order to avoid that, let's use the inode->i_ino for xfs_tweak hint."

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/crypto.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index f265c08..5653646 100644
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
@@ -541,7 +540,7 @@ int ext4_encrypted_zeroout(struct inode *inode, struct ext4_extent *ex)
 
 	while (len--) {
 		err = ext4_page_crypto(ctx, inode, EXT4_ENCRYPT, lblk,
-				       ZERO_PAGE(0), ciphertext_page);
+				       ciphertext_page);
 		if (err)
 			goto errout;
 
-- 
2.1.1

