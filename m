From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/22] ext4 crypto: add encryption key management facilities
Date: Thu,  2 Apr 2015 18:10:46 -0400
Message-ID: <1428012659-12709-10-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <muslukhovi@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47973 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbbDBWMe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:34 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: I0cb5711a628554d3b05cefd15740d8346115cbaa
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Ildar Muslukhov <muslukhovi@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Makefile      |   2 +-
 fs/ext4/crypto_key.c  | 167 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h        |  25 ++++++++
 fs/ext4/ext4_crypto.h |   3 +
 4 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 fs/ext4/crypto_key.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 1b1c561..4e5af21 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,4 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
-ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o
+ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o crypto_key.o
diff --git a/fs/ext4/crypto_key.c b/fs/ext4/crypto_key.c
new file mode 100644
index 0000000..3620e16
--- /dev/null
+++ b/fs/ext4/crypto_key.c
@@ -0,0 +1,167 @@
+/*
+ * linux/fs/ext4/crypto_key.c
+ *
+ * This contains encryption key functions for ext4
+ *
+ * Written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar, 2015.
+ *
+ * This has not yet undergone a rigorous security audit.
+ */
+
+#include <keys/encrypted-type.h>
+#include <keys/user-type.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <uapi/linux/keyctl.h>
+
+#include "ext4.h"
+#include "xattr.h"
+
+struct derive_crypt_result {
+	struct completion completion;
+	int rc;
+};
+
+static void derive_crypt_complete(struct crypto_async_request *req, int rc)
+{
+	struct derive_crypt_result *dcr = req->data;
+
+	if (rc == -EINPROGRESS)
+		return;
+
+	dcr->rc = rc;
+	complete(&dcr->completion);
+}
+
+/**
+ * ext4_derive_key_aes() - Derive a key using AES-128-ECB
+ * @deriving_key: Encryption key used for derivatio.
+ * @source_key:   Source key to which to apply derivation.
+ * @derived_key:  Derived key.
+ *
+ * Return: Zero on success; non-zero otherwise.
+ */
+static int ext4_derive_key_aes(char deriving_key[EXT4_AES_128_ECB_KEY_SIZE],
+			       char source_key[EXT4_AES_256_XTS_KEY_SIZE],
+			       char derived_key[EXT4_AES_256_XTS_KEY_SIZE])
+{
+	int res = 0;
+	struct ablkcipher_request *req = NULL;
+	struct derive_crypt_result dcr;
+	struct scatterlist src_sg, dst_sg;
+	struct crypto_ablkcipher *tfm = crypto_alloc_ablkcipher("ecb(aes)", 0,
+								0);
+
+	if (IS_ERR(tfm)) {
+		res = PTR_ERR(tfm);
+		tfm = NULL;
+		goto out;
+	}
+	crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	req = ablkcipher_request_alloc(tfm, GFP_NOFS);
+	if (!req) {
+		res = -ENOMEM;
+		goto out;
+	}
+	ablkcipher_request_set_callback(req,
+			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+			derive_crypt_complete, &dcr);
+	res = crypto_ablkcipher_setkey(tfm, deriving_key,
+				       EXT4_AES_128_ECB_KEY_SIZE);
+	if (res < 0)
+		goto out;
+	sg_init_one(&src_sg, source_key, EXT4_AES_256_XTS_KEY_SIZE);
+	sg_init_one(&dst_sg, derived_key, EXT4_AES_256_XTS_KEY_SIZE);
+	ablkcipher_request_set_crypt(req, &src_sg, &dst_sg,
+				     EXT4_AES_256_XTS_KEY_SIZE, NULL);
+	res = crypto_ablkcipher_encrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		struct derive_crypt_result *dcr = req->base.data;
+
+		wait_for_completion(&dcr->completion);
+		res = dcr->rc;
+	}
+
+out:
+	if (req)
+		ablkcipher_request_free(req);
+	if (tfm)
+		crypto_free_ablkcipher(tfm);
+	return res;
+}
+
+/**
+ * ext4_generate_encryption_key() - generates an encryption key
+ * @inode: The inode to generate the encryption key for.
+ */
+int ext4_generate_encryption_key(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_encryption_key *crypt_key = &ei->i_encryption_key;
+	char full_key_descriptor[EXT4_KEY_DESC_PREFIX_SIZE +
+				 (EXT4_KEY_DESCRIPTOR_SIZE * 2) + 1];
+	struct key *keyring_key = NULL;
+	struct ext4_encryption_key *master_key;
+	struct ext4_encryption_context ctx;
+	struct user_key_payload *ukp;
+	int res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
+				 EXT4_XATTR_NAME_ENCRYPTION_CONTEXT,
+				 &ctx, sizeof(ctx));
+
+	if (res != sizeof(ctx)) {
+		if (res > 0)
+			res = -EINVAL;
+		goto out;
+	}
+	res = 0;
+
+	memcpy(full_key_descriptor, EXT4_KEY_DESC_PREFIX,
+	       EXT4_KEY_DESC_PREFIX_SIZE);
+	ext4_to_hex(&full_key_descriptor[EXT4_KEY_DESC_PREFIX_SIZE],
+		    ctx.master_key_descriptor, EXT4_KEY_DESCRIPTOR_SIZE);
+	full_key_descriptor[EXT4_KEY_DESC_PREFIX_SIZE +
+			    (2 * EXT4_KEY_DESCRIPTOR_SIZE)] = '\0';
+	keyring_key = request_key(&key_type_logon, full_key_descriptor, NULL);
+	if (IS_ERR(keyring_key)) {
+		res = PTR_ERR(keyring_key);
+		keyring_key = NULL;
+		goto out;
+	}
+	BUG_ON(keyring_key->type != &key_type_logon);
+	ukp = ((struct user_key_payload *)keyring_key->payload.data);
+	if (ukp->datalen != sizeof(struct ext4_encryption_key)) {
+		res = -EINVAL;
+		goto out;
+	}
+	master_key = (struct ext4_encryption_key *)ukp->data;
+
+	if (S_ISREG(inode->i_mode))
+		crypt_key->mode = ctx.contents_encryption_mode;
+	else if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
+		crypt_key->mode = ctx.filenames_encryption_mode;
+	else {
+		printk(KERN_ERR "ext4 crypto: Unsupported inode type.\n");
+		BUG();
+	}
+	crypt_key->size = ext4_encryption_key_size(crypt_key->mode);
+	BUG_ON(!crypt_key->size);
+	BUILD_BUG_ON(EXT4_AES_128_ECB_KEY_SIZE !=
+		     EXT4_KEY_DERIVATION_NONCE_SIZE);
+	BUG_ON(master_key->size != EXT4_AES_256_XTS_KEY_SIZE);
+	BUG_ON(crypt_key->size < EXT4_AES_256_CBC_KEY_SIZE);
+	res = ext4_derive_key_aes(ctx.nonce, master_key->raw, crypt_key->raw);
+out:
+	if (keyring_key)
+		key_put(keyring_key);
+	if (res < 0)
+		crypt_key->mode = EXT4_ENCRYPTION_MODE_INVALID;
+	return res;
+}
+
+int ext4_has_encryption_key(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_encryption_key *crypt_key = &ei->i_encryption_key;
+
+	return (crypt_key->mode != EXT4_ENCRYPTION_MODE_INVALID);
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f7ee6c0..ecb7be83 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1475,6 +1475,18 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_SB(sb)	(sb)
 #endif
 
+/*
+ * Returns true if the inode is inode is encrypted
+ */
+static inline int ext4_encrypted_inode(struct inode *inode)
+{
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	return ext4_test_inode_flag(inode, EXT4_INODE_ENCRYPT);
+#else
+	return 0;
+#endif
+}
+
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
 
 /*
@@ -2037,6 +2049,19 @@ static inline int ext4_sb_has_crypto(struct super_block *sb)
 }
 #endif
 
+/* crypto_key.c */
+int ext4_generate_encryption_key(struct inode *inode);
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+int ext4_has_encryption_key(struct inode *inode);
+#else
+static inline int ext4_has_encryption_key(struct inode *inode)
+{
+	return 0;
+}
+#endif
+
+
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 				  struct file *,
diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
index fb73935..3bff49c 100644
--- a/fs/ext4/ext4_crypto.h
+++ b/fs/ext4/ext4_crypto.h
@@ -59,6 +59,9 @@ int ext4_process_policy(const struct ext4_encryption_policy *policy,
 #define EXT4_AES_256_CBC_KEY_SIZE 32
 #define EXT4_MAX_KEY_SIZE 64
 
+#define EXT4_KEY_DESC_PREFIX "ext4:"
+#define EXT4_KEY_DESC_PREFIX_SIZE 5
+
 struct ext4_encryption_key {
 	uint32_t mode;
 	char raw[EXT4_MAX_KEY_SIZE];
-- 
2.3.0

