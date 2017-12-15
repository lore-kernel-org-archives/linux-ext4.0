From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 01/24] fscrypt: move fscrypt_has_encryption_key() to supp/notsupp headers
Date: Fri, 15 Dec 2017 09:42:02 -0800
Message-ID: <20171215174225.31583-2-ebiggers3@gmail.com>
References: <20171215174225.31583-1-ebiggers3@gmail.com>
Cc: "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Eric Biggers <ebiggers@google.com>
To: linux-fscrypt@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:47013 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755655AbdLORqk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Dec 2017 12:46:40 -0500
In-Reply-To: <20171215174225.31583-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

fscrypt_has_encryption_key() is already split into two versions
depending on whether the filesystem is being built with encryption
support or not.  Move them into the appropriate headers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/fscrypt.h         | 10 ----------
 include/linux/fscrypt_notsupp.h |  5 +++++
 include/linux/fscrypt_supp.h    |  5 +++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 08b4b40c5aa8..d1c891b5bd9c 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -129,11 +129,6 @@ static inline struct page *fscrypt_control_page(struct page *page)
 	return ((struct fscrypt_ctx *)page_private(page))->w.control_page;
 }
 
-static inline bool fscrypt_has_encryption_key(const struct inode *inode)
-{
-	return (inode->i_crypt_info != NULL);
-}
-
 #include <linux/fscrypt_supp.h>
 
 #else /* !__FS_HAS_ENCRYPTION */
@@ -144,11 +139,6 @@ static inline struct page *fscrypt_control_page(struct page *page)
 	return ERR_PTR(-EINVAL);
 }
 
-static inline bool fscrypt_has_encryption_key(const struct inode *inode)
-{
-	return 0;
-}
-
 #include <linux/fscrypt_notsupp.h>
 #endif /* __FS_HAS_ENCRYPTION */
 
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 63e58808519a..52e330285457 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -14,6 +14,11 @@
 #ifndef _LINUX_FSCRYPT_NOTSUPP_H
 #define _LINUX_FSCRYPT_NOTSUPP_H
 
+static inline bool fscrypt_has_encryption_key(const struct inode *inode)
+{
+	return false;
+}
+
 /* crypto.c */
 static inline struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *inode,
 						  gfp_t gfp_flags)
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index cf9e9fc02f0a..79bb8beae018 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -11,6 +11,11 @@
 #ifndef _LINUX_FSCRYPT_SUPP_H
 #define _LINUX_FSCRYPT_SUPP_H
 
+static inline bool fscrypt_has_encryption_key(const struct inode *inode)
+{
+	return (inode->i_crypt_info != NULL);
+}
+
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
-- 
2.15.1
