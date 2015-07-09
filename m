From: Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] ext4 crypto: fix typo
Date: Thu,  9 Jul 2015 22:11:05 +0200
Message-ID: <1436472665-6039-1-git-send-email-laurent.navet@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Laurent Navet <laurent.navet@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

derivatio -> derivation.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 fs/ext4/crypto_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
index ce75bc8..1d510c1 100644
--- a/fs/ext4/crypto_key.c
+++ b/fs/ext4/crypto_key.c
@@ -30,7 +30,7 @@ static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 
 /**
  * ext4_derive_key_aes() - Derive a key using AES-128-ECB
- * @deriving_key: Encryption key used for derivatio.
+ * @deriving_key: Encryption key used for derivation.
  * @source_key:   Source key to which to apply derivation.
  * @derived_key:  Derived key.
  *
-- 
2.1.4
