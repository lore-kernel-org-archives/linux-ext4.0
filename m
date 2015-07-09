From: Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH V2] ext4 crypto: exit cleanly if ext4_derive_key_aes() fails
Date: Thu,  9 Jul 2015 22:07:14 +0200
Message-ID: <1436472434-5853-1-git-send-email-laurent.navet@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Laurent Navet <laurent.navet@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Return value of ext4_derive_key_aes() is stored but not used.
Add test to exit cleanly if ext4_derive_key_aes() fail.
Also fix coverity CID 1309760.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 fs/ext4/crypto_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index 442d24e..ce75bc8 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -220,6 +220,8 @@ retry:
 	BUG_ON(master_key->size != EXT4_AES_256_XTS_KEY_SIZE);
 	res = ext4_derive_key_aes(ctx.nonce, master_key->raw,
 				  raw_key);
+	if (res)
+		goto out;
 got_key:
 	ctfm = crypto_alloc_ablkcipher(cipher_str, 0, 0);
 	if (!ctfm || IS_ERR(ctfm)) {
-- 
2.1.4
