Return-Path: <SRS0=i6rR=SL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E897C10F0E
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 23:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E84092133D
	for <linux-ext4@archiver.kernel.org>; Tue,  9 Apr 2019 23:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554853003;
	bh=V+h0PBTbPysDDvQ+w4skEEJuCZkey/KR9dK5ry5y+EY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UF2R8OXBNsGwxip4ZGQdIYOc6BV28N1SlyiTR5LXquZWH6ZUWvcDmn58wLbzttGbo
	 QQqVO6a7QGeIu60VHtEY+PY3ZSUqKR1BzGmQKQuYzuPJ7yyr7v+rv52n3KA5qjbAhS
	 bkFUUEEg1UBKI19rMGvRcYxTU4uZSRyJUpSOkKao=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDIXgm (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 9 Apr 2019 19:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfDIXgm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 9 Apr 2019 19:36:42 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84CAD20850;
        Tue,  9 Apr 2019 23:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554853000;
        bh=V+h0PBTbPysDDvQ+w4skEEJuCZkey/KR9dK5ry5y+EY=;
        h=From:To:Cc:Subject:Date:From;
        b=uWujgFd9D/mA1hmILSSa8RkBzbBnrkKOGkqGkWNEhtO1dW20QQTMPB7BpBoubOiXo
         db/FYRx70dWPgYIHXcbGgan8OPSPGszaERa5gwiCPZl/Wa9ziRiW6ZbmM7I6ooaPbz
         CdEK78ZnDvZjGbxXKRETbVPvVfyQxfsyMURpDLuY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] fscrypt: cache decrypted symlink target in ->i_link
Date:   Tue,  9 Apr 2019 16:35:44 -0700
Message-Id: <20190409233544.156665-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Path lookups that traverse encrypted symlink(s) are very slow because
each encrypted symlink needs to be decrypted each time it's followed.

Make encrypted symlinks faster by caching the decrypted symlink target
in ->i_link.  The first call to ->get_link() sets it; later calls simply
return it.  ->symlink() also sets it when the symlink is created.

When the inode's ->i_crypt_info is freed, ->i_link is freed too.

Note: RCU-delayed freeing of ->i_link is not yet implemented.
Therefore, for now even when ->i_link is set, path lookups must continue
to drop out of RCU-walk mode when following an encrypted symlink.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 39 ++++++++++++++++++++++++++++++++-------
 fs/crypto/keyinfo.c     |  4 ++++
 fs/ext4/symlink.c       |  4 ++++
 fs/f2fs/namei.c         |  4 ++++
 include/linux/fscrypt.h | 23 +++++++++++++++++++++++
 5 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 56debb1fcf5eb..e6b09de51221f 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -179,11 +179,9 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 	sd->len = cpu_to_le16(ciphertext_len);
 
 	err = fname_encrypt(inode, &iname, sd->encrypted_path, ciphertext_len);
-	if (err) {
-		if (!disk_link->name)
-			kfree(sd);
-		return err;
-	}
+	if (err)
+		goto err_free_sd;
+
 	/*
 	 * Null-terminating the ciphertext doesn't make sense, but we still
 	 * count the null terminator in the length, so we might as well
@@ -191,9 +189,20 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 	 */
 	sd->encrypted_path[ciphertext_len] = '\0';
 
+	/* Cache the plaintext symlink target for later use by ->get_link(). */
+	err = -ENOMEM;
+	inode->i_link = kmemdup(target, len + 1, GFP_NOFS);
+	if (!inode->i_link)
+		goto err_free_sd;
+
 	if (!disk_link->name)
 		disk_link->name = (unsigned char *)sd;
 	return 0;
+
+err_free_sd:
+	if (!disk_link->name)
+		kfree(sd);
+	return err;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_encrypt_symlink);
 
@@ -202,7 +211,7 @@ EXPORT_SYMBOL_GPL(__fscrypt_encrypt_symlink);
  * @inode: the symlink inode
  * @caddr: the on-disk contents of the symlink
  * @max_size: size of @caddr buffer
- * @done: if successful, will be set up to free the returned target
+ * @done: if successful, will be set up to free the returned target if needed
  *
  * If the symlink's encryption key is available, we decrypt its target.
  * Otherwise, we encode its target for presentation.
@@ -217,12 +226,18 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 {
 	const struct fscrypt_symlink_data *sd;
 	struct fscrypt_str cstr, pstr;
+	bool has_key;
 	int err;
 
 	/* This is for encrypted symlinks only */
 	if (WARN_ON(!IS_ENCRYPTED(inode)))
 		return ERR_PTR(-EINVAL);
 
+	/* If the decrypted target is already cached, just return it. */
+	pstr.name = (char *)fscrypt_get_cached_symlink(inode);
+	if (pstr.name)
+		return pstr.name;
+
 	/*
 	 * Try to set up the symlink's encryption key, but we can continue
 	 * regardless of whether the key is available or not.
@@ -230,6 +245,7 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	err = fscrypt_get_encryption_info(inode);
 	if (err)
 		return ERR_PTR(err);
+	has_key = fscrypt_has_encryption_key(inode);
 
 	/*
 	 * For historical reasons, encrypted symlink targets are prefixed with
@@ -261,7 +277,16 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 		goto err_kfree;
 
 	pstr.name[pstr.len] = '\0';
-	set_delayed_call(done, kfree_link, pstr.name);
+
+	/*
+	 * Cache decrypted symlink targets in i_link for later use.  Don't cache
+	 * symlink targets encoded without the key, since those become outdated
+	 * once the key is added.  This pairs with fscrypt_get_cached_symlink().
+	 */
+	if (!has_key ||
+	    cmpxchg_release(&inode->i_link, NULL, pstr.name) != NULL)
+		set_delayed_call(done, kfree_link, pstr.name);
+
 	return pstr.name;
 
 err_kfree:
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index d1f0f8369d510..bf9b0bffd81bc 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -586,6 +586,10 @@ EXPORT_SYMBOL(fscrypt_get_encryption_info);
 
 void fscrypt_put_encryption_info(struct inode *inode)
 {
+	if (IS_ENCRYPTED(inode) && S_ISLNK(inode->i_mode)) {
+		kfree(inode->i_link);
+		inode->i_link = NULL;
+	}
 	put_crypt_info(inode->i_crypt_info);
 	inode->i_crypt_info = NULL;
 }
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092d..02b49ef4762fd 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -35,6 +35,10 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
+	paddr = fscrypt_get_cached_symlink(inode);
+	if (paddr)
+		return paddr;
+
 	if (ext4_inode_is_fast_symlink(inode)) {
 		caddr = EXT4_I(inode)->i_data;
 		max_size = sizeof(EXT4_I(inode)->i_data);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index f5e34e4670031..2f38df6e26f80 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1212,6 +1212,10 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	if (!dentry)
 		return ERR_PTR(-ECHILD);
 
+	target = fscrypt_get_cached_symlink(inode);
+	if (target)
+		return target;
+
 	page = read_mapping_page(inode->i_mapping, 0, NULL);
 	if (IS_ERR(page))
 		return ERR_CAST(page);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 13c907214a761..f4b816c5a0941 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -231,6 +231,24 @@ extern int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 extern const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 				       unsigned int max_size,
 				       struct delayed_call *done);
+/**
+ * fscrypt_get_cached_symlink - get the cached decrypted symlink target
+ * @inode: inode of an encrypted symlink
+ *
+ * If the decrypted symlink target was already cached, return it.
+ *
+ * This must not be called in RCU-walk mode, since currently the cached symlink
+ * target is freed without waiting for an RCU grace period.
+ *
+ * Return: the symlink target if cached; NULL if uncached;
+ *	   or ERR_PTR(-EOPNOTSUPP) when !CONFIG_FS_ENCRYPTION.
+ */
+static inline const char *fscrypt_get_cached_symlink(const struct inode *inode)
+{
+	/* Pairs with the cmpxchg_release() in fscrypt_get_symlink() */
+	return smp_load_acquire(&inode->i_link);
+}
+
 #else  /* !CONFIG_FS_ENCRYPTION */
 
 static inline bool fscrypt_has_encryption_key(const struct inode *inode)
@@ -446,6 +464,11 @@ static inline const char *fscrypt_get_symlink(struct inode *inode,
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
+
+static inline const char *fscrypt_get_cached_symlink(const struct inode *inode)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif	/* !CONFIG_FS_ENCRYPTION */
 
 /**
-- 
2.21.0.392.gf8f6787159e-goog

