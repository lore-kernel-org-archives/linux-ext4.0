From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: use standard macros to compute length of fname ciphertext
Date: Thu, 22 Sep 2016 13:31:49 -0700
Message-ID: <1474576309-86917-3-git-send-email-ebiggers@google.com>
References: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1474576309-86917-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 90697c7..9a28133 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -14,11 +14,6 @@
 #include <linux/ratelimit.h>
 #include <linux/fscrypto.h>
 
-static u32 size_round_up(size_t size, size_t blksize)
-{
-	return ((size + blksize - 1) / blksize) * blksize;
-}
-
 /**
  * fname_crypt_complete() - completion callback for filename crypto
  * @req: The asynchronous cipher request context
@@ -60,10 +55,9 @@ static int fname_encrypt(struct inode *inode,
 	if (iname->len <= 0 || iname->len > lim)
 		return -EIO;
 
-	ciphertext_len = (iname->len < FS_CRYPTO_BLOCK_SIZE) ?
-					FS_CRYPTO_BLOCK_SIZE : iname->len;
-	ciphertext_len = size_round_up(ciphertext_len, padding);
-	ciphertext_len = (ciphertext_len > lim) ? lim : ciphertext_len;
+	ciphertext_len = max(iname->len, (u32)FS_CRYPTO_BLOCK_SIZE);
+	ciphertext_len = round_up(ciphertext_len, padding);
+	ciphertext_len = min(ciphertext_len, lim);
 
 	if (ciphertext_len <= sizeof(buf)) {
 		workbuf = buf;
@@ -233,9 +227,8 @@ u32 fscrypt_fname_encrypted_size(struct inode *inode, u32 ilen)
 
 	if (ci)
 		padding = 4 << (ci->ci_flags & FS_POLICY_FLAGS_PAD_MASK);
-	if (ilen < FS_CRYPTO_BLOCK_SIZE)
-		ilen = FS_CRYPTO_BLOCK_SIZE;
-	return size_round_up(ilen, padding);
+	ilen = max(ilen, (u32)FS_CRYPTO_BLOCK_SIZE);
+	return round_up(ilen, padding);
 }
 EXPORT_SYMBOL(fscrypt_fname_encrypted_size);
 
-- 
2.8.0.rc3.226.g39d4020

