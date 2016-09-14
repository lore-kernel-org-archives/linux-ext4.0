From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: rename completion callbacks to reflect usage
Date: Wed, 14 Sep 2016 13:57:14 -0700
Message-ID: <1473886634-24627-3-git-send-email-ebiggers@google.com>
References: <1473886634-24627-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35047 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757190AbcINU7a (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2016 16:59:30 -0400
Received: by mail-pf0-f170.google.com with SMTP id z123so9183010pfz.2
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2016 13:59:29 -0700 (PDT)
In-Reply-To: <1473886634-24627-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fscrypt_complete() was used only for data pages, not for all
encryption/decryption.  Rename it to page_crypt_complete().

dir_crypt_complete() was used for filename encryption/decryption for
both directory entries and symbolic links.  Rename it to
fname_crypt_complete().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c | 10 +++++-----
 fs/crypto/fname.c  | 10 ++++++----
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 7c39eab..61057b7d 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -127,11 +127,11 @@ struct fscrypt_ctx *fscrypt_get_ctx(struct inode *inode, gfp_t gfp_flags)
 EXPORT_SYMBOL(fscrypt_get_ctx);
 
 /**
- * fscrypt_complete() - The completion callback for page encryption
- * @req: The asynchronous encryption request context
- * @res: The result of the encryption operation
+ * page_crypt_complete() - completion callback for page crypto
+ * @req: The asynchronous cipher request context
+ * @res: The result of the cipher operation
  */
-static void fscrypt_complete(struct crypto_async_request *req, int res)
+static void page_crypt_complete(struct crypto_async_request *req, int res)
 {
 	struct fscrypt_completion_result *ecr = req->data;
 
@@ -169,7 +169,7 @@ static int do_page_crypto(struct inode *inode,
 
 	skcipher_request_set_callback(
 		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		fscrypt_complete, &ecr);
+		page_crypt_complete, &ecr);
 
 	BUILD_BUG_ON(FS_XTS_TWEAK_SIZE < sizeof(index));
 	memcpy(xts_tweak, &index, sizeof(index));
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 7f3239c..db8f798 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -20,9 +20,11 @@ static u32 size_round_up(size_t size, size_t blksize)
 }
 
 /**
- * dir_crypt_complete() -
+ * fname_crypt_complete() - completion callback for filename crypto
+ * @req: The asynchronous cipher request context
+ * @res: The result of the cipher operation
  */
-static void dir_crypt_complete(struct crypto_async_request *req, int res)
+static void fname_crypt_complete(struct crypto_async_request *req, int res)
 {
 	struct fscrypt_completion_result *ecr = req->data;
 
@@ -82,7 +84,7 @@ static int fname_encrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			dir_crypt_complete, &ecr);
+			fname_crypt_complete, &ecr);
 
 	/* Copy the input */
 	memcpy(workbuf, iname->name, iname->len);
@@ -145,7 +147,7 @@ static int fname_decrypt(struct inode *inode,
 	}
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-		dir_crypt_complete, &ecr);
+		fname_crypt_complete, &ecr);
 
 	/* Initialize IV */
 	memset(iv, 0, FS_CRYPTO_BLOCK_SIZE);
-- 
2.8.0.rc3.226.g39d4020

