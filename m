From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] fscrypto: remove unnecessary includes
Date: Wed, 14 Sep 2016 13:57:12 -0700
Message-ID: <1473886634-24627-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        tytso@mit.edu, jaegeuk@kernel.org,
        Eric Biggers <ebiggers@google.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch removes some #includes that are clearly not needed, such as a
reference to ecryptfs, which is unrelated to the new filesystem
encryption code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c  | 1 -
 fs/crypto/fname.c   | 2 --
 fs/crypto/keyinfo.c | 3 ---
 3 files changed, 6 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index c502c11..7c39eab 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -28,7 +28,6 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/fscrypto.h>
-#include <linux/ecryptfs.h>
 
 static unsigned int num_prealloc_crypto_pages = 32;
 static unsigned int num_prealloc_crypto_ctxs = 128;
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 5d6d491..3108806 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -10,8 +10,6 @@
  * This has not yet undergone a rigorous security audit.
  */
 
-#include <keys/encrypted-type.h>
-#include <keys/user-type.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
 #include <linux/fscrypto.h>
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 1ac263e..58b1c82 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -8,11 +8,8 @@
  * Written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar, 2015.
  */
 
-#include <keys/encrypted-type.h>
 #include <keys/user-type.h>
-#include <linux/random.h>
 #include <linux/scatterlist.h>
-#include <uapi/linux/keyctl.h>
 #include <linux/fscrypto.h>
 
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
-- 
2.8.0.rc3.226.g39d4020

