From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] fscrypt: move the policy flags and encryption mode definitions to uapi header
Date: Sat, 26 Nov 2016 23:41:55 -0500
Message-ID: <20161127044155.23022-4-tytso@mit.edu>
References: <20161127044155.23022-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60646 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753232AbcK0EmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 26 Nov 2016 23:42:12 -0500
In-Reply-To: <20161127044155.23022-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These constants are part of the UAPI, so they belong in
include/uapi/linux/fs.h instead of include/linux/fscrypto.h

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 include/linux/fscrypto.h | 14 --------------
 include/uapi/linux/fs.h  | 14 ++++++++++++++
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 71e8a20711ec..42ef82d60790 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -18,20 +18,6 @@
 #include <crypto/skcipher.h>
 #include <uapi/linux/fs.h>
 
-#define FS_POLICY_FLAGS_PAD_4		0x00
-#define FS_POLICY_FLAGS_PAD_8		0x01
-#define FS_POLICY_FLAGS_PAD_16		0x02
-#define FS_POLICY_FLAGS_PAD_32		0x03
-#define FS_POLICY_FLAGS_PAD_MASK	0x03
-#define FS_POLICY_FLAGS_VALID		0x03
-
-/* Encryption algorithms */
-#define FS_ENCRYPTION_MODE_INVALID		0
-#define FS_ENCRYPTION_MODE_AES_256_XTS		1
-#define FS_ENCRYPTION_MODE_AES_256_GCM		2
-#define FS_ENCRYPTION_MODE_AES_256_CBC		3
-#define FS_ENCRYPTION_MODE_AES_256_CTS		4
-
 #define FS_CRYPTO_BLOCK_SIZE		16
 
 struct fscrypt_info;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index acb2b6152ba0..0496d37abe28 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -254,6 +254,20 @@ struct fsxattr {
 /* Policy provided via an ioctl on the topmost directory */
 #define FS_KEY_DESCRIPTOR_SIZE	8
 
+#define FS_POLICY_FLAGS_PAD_4		0x00
+#define FS_POLICY_FLAGS_PAD_8		0x01
+#define FS_POLICY_FLAGS_PAD_16		0x02
+#define FS_POLICY_FLAGS_PAD_32		0x03
+#define FS_POLICY_FLAGS_PAD_MASK	0x03
+#define FS_POLICY_FLAGS_VALID		0x03
+
+/* Encryption algorithms */
+#define FS_ENCRYPTION_MODE_INVALID		0
+#define FS_ENCRYPTION_MODE_AES_256_XTS		1
+#define FS_ENCRYPTION_MODE_AES_256_GCM		2
+#define FS_ENCRYPTION_MODE_AES_256_CBC		3
+#define FS_ENCRYPTION_MODE_AES_256_CTS		4
+
 struct fscrypt_policy {
 	__u8 version;
 	__u8 contents_encryption_mode;
-- 
2.11.0.rc0.7.gbe5a750

