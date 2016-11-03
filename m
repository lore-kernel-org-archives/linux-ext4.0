From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/2] fscrypto: don't use on-stack buffer for key derivation
Date: Thu,  3 Nov 2016 15:03:02 -0700
Message-ID: <1478210582-86338-2-git-send-email-ebiggers@google.com>
References: <1478210582-86338-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        richard@nod.at, luto@kernel.org, Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33690 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758207AbcKCWEd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Nov 2016 18:04:33 -0400
Received: by mail-pf0-f175.google.com with SMTP id d2so38446079pfd.0
        for <linux-ext4@vger.kernel.org>; Thu, 03 Nov 2016 15:04:32 -0700 (PDT)
In-Reply-To: <1478210582-86338-1-git-send-email-ebiggers@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With the new (in 4.9) option to use a virtually-mapped stack
(CONFIG_VMAP_STACK), stack buffers cannot be used as input/output for
the scatterlist crypto API because they may not be directly mappable to
struct page.  get_crypt_info() was using a stack buffer to hold the
output from the encryption operation used to derive the per-file key.
Fix it by using a heap buffer.

This bug could most easily be observed in a CONFIG_DEBUG_SG kernel
because this allowed the BUG in sg_set_buf() to be triggered.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 82f0285..67fb6d8 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -185,7 +185,7 @@ int get_crypt_info(struct inode *inode)
 	struct crypto_skcipher *ctfm;
 	const char *cipher_str;
 	int keysize;
-	u8 raw_key[FS_MAX_KEY_SIZE];
+	u8 *raw_key = NULL;
 	int res;
 
 	res = fscrypt_initialize();
@@ -238,6 +238,15 @@ int get_crypt_info(struct inode *inode)
 	if (res)
 		goto out;
 
+	/*
+	 * This cannot be a stack buffer because it is passed to the scatterlist
+	 * crypto API as part of key derivation.
+	 */
+	res = -ENOMEM;
+	raw_key = kmalloc(FS_MAX_KEY_SIZE, GFP_NOFS);
+	if (!raw_key)
+		goto out;
+
 	if (fscrypt_dummy_context_enabled(inode)) {
 		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
 		goto got_key;
@@ -276,7 +285,8 @@ int get_crypt_info(struct inode *inode)
 	if (res)
 		goto out;
 
-	memzero_explicit(raw_key, sizeof(raw_key));
+	kzfree(raw_key);
+	raw_key = NULL;
 	if (cmpxchg(&inode->i_crypt_info, NULL, crypt_info) != NULL) {
 		put_crypt_info(crypt_info);
 		goto retry;
@@ -287,7 +297,7 @@ int get_crypt_info(struct inode *inode)
 	if (res == -ENOKEY)
 		res = 0;
 	put_crypt_info(crypt_info);
-	memzero_explicit(raw_key, sizeof(raw_key));
+	kzfree(raw_key);
 	return res;
 }
 
-- 
2.8.0.rc3.226.g39d4020

