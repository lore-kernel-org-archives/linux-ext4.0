From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] fscrypt: unexport fscrypt_initialize()
Date: Sat, 26 Nov 2016 23:41:53 -0500
Message-ID: <20161127044155.23022-2-tytso@mit.edu>
References: <20161127044155.23022-1-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        jaegeuk@kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60644 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753286AbcK0EmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 26 Nov 2016 23:42:12 -0500
In-Reply-To: <20161127044155.23022-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The fscrypt_initalize() function isn't used outside fs/crypto, so
there's no point making it be an exported symbol.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/crypto/crypto.c          | 1 -
 fs/crypto/fscrypt_private.h | 3 +++
 include/linux/fscrypto.h    | 1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index b6029785714c..56f98f45cece 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -540,7 +540,6 @@ int fscrypt_initialize(void)
 	mutex_unlock(&fscrypt_init_mutex);
 	return res;
 }
-EXPORT_SYMBOL(fscrypt_initialize);
 
 /**
  * fscrypt_init() - Set up for fs encryption.
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7c31108728e4..bb92f0c0961b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -13,6 +13,9 @@
 
 #include <linux/fscrypto.h>
 
+/* crypto.c */
+int fscrypt_initialize(void);
+
 /* keyinfo.c */
 extern int fscrypt_get_crypt_info(struct inode *);
 
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index 2f8894f0696c..ce2ebdee6a89 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -244,7 +244,6 @@ static inline void fscrypt_set_d_op(struct dentry *dentry)
 #if IS_ENABLED(CONFIG_FS_ENCRYPTION)
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
-int fscrypt_initialize(void);
 
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
 extern void fscrypt_release_ctx(struct fscrypt_ctx *);
-- 
2.11.0.rc0.7.gbe5a750

