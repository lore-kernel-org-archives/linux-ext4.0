From: Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] ext4 crypto: remove unneeded assignation
Date: Wed,  8 Jul 2015 21:51:15 +0200
Message-ID: <1436385075-22559-1-git-send-email-laurent.navet@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Laurent Navet <laurent.navet@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Return value of ext4_derive_key_aes() is stored but never used before
being overwritten.
Also fix coverity CID 1309760.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 fs/ext4/crypto_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 442d24e..92f9172 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -218,7 +218,7 @@ retry:
 	BUILD_BUG_ON(EXT4_AES_128_ECB_KEY_SIZE !=
 		     EXT4_KEY_DERIVATION_NONCE_SIZE);
 	BUG_ON(master_key->size != EXT4_AES_256_XTS_KEY_SIZE);
-	res = ext4_derive_key_aes(ctx.nonce, master_key->raw,
+	ext4_derive_key_aes(ctx.nonce, master_key->raw,
 				  raw_key);
 got_key:
 	ctfm = crypto_alloc_ablkcipher(cipher_str, 0, 0);
-- 
2.1.4
