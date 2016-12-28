From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] fscrypt: fix the test_dummy_encryption mount option
Date: Tue, 27 Dec 2016 19:51:47 -0500
Message-ID: <20161228005147.751-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Commit f1c131b45410a: "crypto: xts - Convert to skcipher" now fails
the setkey operation if the AES key is the same as the tweak key.
Previously this check was only done if FIPS mode is enabled.  Now this
check is also done if weak key checking was requested.  This is
reasonable, but since we were using the dummy key which was a constant
series of 0x42 bytes, it now caused dummy encrpyption test mode to
fail.

Fix this by using 0x42... and 0x24... for the two keys, so they are
different.

Fixes: f1c131b45410a202eb45cc55980a7a9e4e4b4f40
Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/keyinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 6eeea1dcba41..95cd4c3b06c3 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -248,7 +248,8 @@ int fscrypt_get_crypt_info(struct inode *inode)
 		goto out;
 
 	if (fscrypt_dummy_context_enabled(inode)) {
-		memset(raw_key, 0x42, FS_AES_256_XTS_KEY_SIZE);
+		memset(raw_key, 0x42, keysize/2);
+		memset(raw_key+keysize/2, 0x24, keysize - (keysize/2));
 		goto got_key;
 	}
 
-- 
2.11.0.rc0.7.gbe5a750
