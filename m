From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/4] fscrypt: rename get_crypt_info() to fscrypt_get_crypt_info()
Date: Sat, 26 Nov 2016 23:41:52 -0500
Message-ID: <20161127044155.23022-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60648 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753239AbcK0EmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 26 Nov 2016 23:42:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To avoid namespace collisions, rename get_crypt_info() to
fscrypt_get_crypt_info().  The function is only used inside the
fs/crypto directory, so declare it in the new header file,
fscrypt_private.h.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/fname.c           |  4 ++--
 fs/crypto/fscrypt_private.h | 19 +++++++++++++++++++
 fs/crypto/keyinfo.c         |  6 +++---
 include/linux/fscrypto.h    |  1 -
 4 files changed, 24 insertions(+), 6 deletions(-)
 create mode 100644 fs/crypto/fscrypt_private.h

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6b45d9caeeb0..56ad9d195f18 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -12,7 +12,7 @@
 
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
-#include <linux/fscrypto.h>
+#include "fscrypt_private.h"
 
 /**
  * fname_crypt_complete() - completion callback for filename crypto
@@ -350,7 +350,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 		fname->disk_name.len = iname->len;
 		return 0;
 	}
-	ret = get_crypt_info(dir);
+	ret = fscrypt_get_crypt_info(dir);
 	if (ret && ret != -EOPNOTSUPP)
 		return ret;
 
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
new file mode 100644
index 000000000000..7c31108728e4
--- /dev/null
+++ b/fs/crypto/fscrypt_private.h
@@ -0,0 +1,19 @@
+/*
+ * fscrypt_private.h
+ *
+ * Copyright (C) 2015, Google, Inc.
+ *
+ * This contains encryption key functions.
+ *
+ * Written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar, 2015.
+ */
+
+#ifndef _FSCRYPT_PRIVATE_H
+#define _FSCRYPT_PRIVATE_H
+
+#include <linux/fscrypto.h>
+
+/* keyinfo.c */
+extern int fscrypt_get_crypt_info(struct inode *);
+
+#endif /* _FSCRYPT_PRIVATE_H */
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 67fb6d8876d0..35d3317a27b3 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -10,7 +10,7 @@
 
 #include <keys/user-type.h>
 #include <linux/scatterlist.h>
-#include <linux/fscrypto.h>
+#include "fscrypt_private.h"
 
 static void derive_crypt_complete(struct crypto_async_request *req, int rc)
 {
@@ -178,7 +178,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
-int get_crypt_info(struct inode *inode)
+int fscrypt_get_crypt_info(struct inode *inode)
 {
 	struct fscrypt_info *crypt_info;
 	struct fscrypt_context ctx;
@@ -327,7 +327,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		 (ci->ci_keyring_key->flags & ((1 << KEY_FLAG_INVALIDATED) |
 					       (1 << KEY_FLAG_REVOKED) |
 					       (1 << KEY_FLAG_DEAD)))))
-		return get_crypt_info(inode);
+		return fscrypt_get_crypt_info(inode);
 	return 0;
 }
 EXPORT_SYMBOL(fscrypt_get_encryption_info);
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index be94684dc05f..2f8894f0696c 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -265,7 +265,6 @@ extern int fscrypt_has_permitted_context(struct inode *, struct inode *);
 extern int fscrypt_inherit_context(struct inode *, struct inode *,
 					void *, bool);
 /* keyinfo.c */
-extern int get_crypt_info(struct inode *);
 extern int fscrypt_get_encryption_info(struct inode *);
 extern void fscrypt_put_encryption_info(struct inode *, struct fscrypt_info *);
 
-- 
2.11.0.rc0.7.gbe5a750

