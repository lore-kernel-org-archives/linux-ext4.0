From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/22] ext4 crypto: add ext4 encryption facilities
Date: Thu,  2 Apr 2015 18:10:45 -0400
Message-ID: <1428012659-12709-9-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47971 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbbDBWMe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:34 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

On encrypt, we will re-assign the buffer_heads to point to a bounce
page rather than the control_page (which is the original page to write
that contains the plaintext). The block I/O occurs against the bounce
page.  On write completion, we re-assign the buffer_heads to the
original plaintext page.

On decrypt, we will attach a read completion callback to the bio
struct. This read completion will decrypt the read contents in-place
prior to setting the page up-to-date.

The current encryption mode, AES-256-XTS, lacks cryptographic
integrity. AES-256-GCM is in-plan, but we will need to devise a
mechanism for handling the integrity data.

Change-Id: I5ed4c913d49971d7f7e9b10bb4e694df86f960d7
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Makefile        |   2 +-
 fs/ext4/crypto.c        | 601 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/crypto_policy.c |  21 +-
 fs/ext4/ext4.h          |  39 ++++
 fs/ext4/ext4_crypto.h   |  43 ++++
 fs/ext4/super.c         |  11 +
 6 files changed, 714 insertions(+), 3 deletions(-)
 create mode 100644 fs/ext4/crypto.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 3886ee4..1b1c561 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,4 +12,4 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
-ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o
+ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
new file mode 100644
index 0000000..5b62bb1
--- /dev/null
+++ b/fs/ext4/crypto.c
@@ -0,0 +1,601 @@
+/*
+ * linux/fs/ext4/crypto.c
+ *
+ * This contains encryption functions for ext4
+ *
+ * Written by Michael Halcrow, 2014.
+ *
+ * Filename encryption additions
+ *	Uday Savagaonkar, 2014
+ * Encryption policy handling additions
+ *	Ildar Muslukhov, 2014
+ *
+ * This has not yet undergone a rigorous security audit.
+ *
+ * The usage of AES-XTS should conform to recommendations in NIST
+ * Special Publication 800-38E. The usage of AES-GCM should conform to
+ * the recommendations in NIST Special Publication 800-38D. Further
+ * guidance for block-oriented storage is in IEEE P1619/D16. The key
+ * derivation code implements an HKDF (see RFC 5869).
+ */
+
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <keys/user-type.h>
+#include <keys/encrypted-type.h>
+#include <linux/crypto.h>
+#include <linux/ecryptfs.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/key.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock_types.h>
+
+#include "ext4.h"
+#include "xattr.h"
+
+/* Encryption added and removed here! (L: */
+
+static unsigned int num_prealloc_crypto_pages = 32;
+static unsigned int num_prealloc_crypto_ctxs = 128;
+
+module_param(num_prealloc_crypto_pages, uint, 0444);
+MODULE_PARM_DESC(num_prealloc_crypto_pages,
+		 "Number of crypto pages to preallocate");
+module_param(num_prealloc_crypto_ctxs, uint, 0444);
+MODULE_PARM_DESC(num_prealloc_crypto_ctxs,
+		 "Number of crypto contexts to preallocate");
+
+static mempool_t *ext4_bounce_page_pool;
+
+static LIST_HEAD(ext4_free_crypto_ctxs);
+static DEFINE_SPINLOCK(ext4_crypto_ctx_lock);
+
+/**
+ * ext4_release_crypto_ctx() - Releases an encryption context
+ * @ctx: The encryption context to release.
+ *
+ * If the encryption context was allocated from the pre-allocated pool, returns
+ * it to that pool. Else, frees it.
+ *
+ * If there's a bounce page in the context, this frees that.
+ */
+void ext4_release_crypto_ctx(struct ext4_crypto_ctx *ctx)
+{
+	unsigned long flags;
+
+	if (ctx->bounce_page) {
+		if (ctx->flags & EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL)
+			__free_page(ctx->bounce_page);
+		else
+			mempool_free(ctx->bounce_page, ext4_bounce_page_pool);
+		ctx->bounce_page = NULL;
+	}
+	ctx->control_page = NULL;
+	if (ctx->flags & EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL) {
+		if (ctx->tfm)
+			crypto_free_tfm(ctx->tfm);
+		kfree(ctx);
+	} else {
+		spin_lock_irqsave(&ext4_crypto_ctx_lock, flags);
+		list_add(&ctx->free_list, &ext4_free_crypto_ctxs);
+		spin_unlock_irqrestore(&ext4_crypto_ctx_lock, flags);
+	}
+}
+
+/**
+ * ext4_alloc_and_init_crypto_ctx() - Allocates and inits an encryption context
+ * @mask: The allocation mask.
+ *
+ * Return: An allocated and initialized encryption context on success. An error
+ * value or NULL otherwise.
+ */
+static struct ext4_crypto_ctx *ext4_alloc_and_init_crypto_ctx(gfp_t mask)
+{
+	struct ext4_crypto_ctx *ctx = kzalloc(sizeof(struct ext4_crypto_ctx),
+					      mask);
+
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+	return ctx;
+}
+
+/**
+ * ext4_get_crypto_ctx() - Gets an encryption context
+ * @inode:       The inode for which we are doing the crypto
+ *
+ * Allocates and initializes an encryption context.
+ *
+ * Return: An allocated and initialized encryption context on success; error
+ * value or NULL otherwise.
+ */
+struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct inode *inode)
+{
+	struct ext4_crypto_ctx *ctx = NULL;
+	int res = 0;
+	unsigned long flags;
+	struct ext4_encryption_key *key = &EXT4_I(inode)->i_encryption_key;
+
+	/* We first try getting the ctx from a free list because in the common
+	 * case the ctx will have an allocated and initialized crypto tfm, so
+	 * it's probably a worthwhile optimization. For the bounce page, we
+	 * first try getting it from the kernel allocator because that's just
+	 * about as fast as getting it from a list and because a cache of free
+	 * pages should generally be a "last resort" option for a filesystem to
+	 * be able to do its job. */
+	spin_lock_irqsave(&ext4_crypto_ctx_lock, flags);
+	ctx = list_first_entry_or_null(&ext4_free_crypto_ctxs,
+				       struct ext4_crypto_ctx, free_list);
+	if (ctx)
+		list_del(&ctx->free_list);
+	spin_unlock_irqrestore(&ext4_crypto_ctx_lock, flags);
+	if (!ctx) {
+		ctx = ext4_alloc_and_init_crypto_ctx(GFP_NOFS);
+		if (IS_ERR(ctx)) {
+			res = PTR_ERR(ctx);
+			goto out;
+		}
+		ctx->flags |= EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL;
+	} else {
+		ctx->flags &= ~EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL;
+	}
+
+	/* Allocate a new Crypto API context if we don't already have one or if
+	 * it isn't the right mode. */
+	BUG_ON(key->mode == EXT4_ENCRYPTION_MODE_INVALID);
+	if (ctx->tfm && (ctx->mode != key->mode)) {
+		crypto_free_tfm(ctx->tfm);
+		ctx->tfm = NULL;
+		ctx->mode = EXT4_ENCRYPTION_MODE_INVALID;
+	}
+	if (!ctx->tfm) {
+		switch (key->mode) {
+		case EXT4_ENCRYPTION_MODE_AES_256_XTS:
+			ctx->tfm = crypto_ablkcipher_tfm(
+				crypto_alloc_ablkcipher("xts(aes)", 0, 0));
+			break;
+		case EXT4_ENCRYPTION_MODE_AES_256_GCM:
+			/* TODO(mhalcrow): AEAD w/ gcm(aes);
+			 * crypto_aead_setauthsize() */
+			ctx->tfm = ERR_PTR(-ENOTSUPP);
+			break;
+		default:
+			BUG();
+		}
+		if (IS_ERR_OR_NULL(ctx->tfm)) {
+			res = PTR_ERR(ctx->tfm);
+			ctx->tfm = NULL;
+			goto out;
+		}
+		ctx->mode = key->mode;
+	}
+	BUG_ON(key->size != ext4_encryption_key_size(key->mode));
+
+	/* There shouldn't be a bounce page attached to the crypto
+	 * context at this point. */
+	BUG_ON(ctx->bounce_page);
+
+out:
+	if (res) {
+		if (!IS_ERR_OR_NULL(ctx))
+			ext4_release_crypto_ctx(ctx);
+		ctx = ERR_PTR(res);
+	}
+	return ctx;
+}
+
+struct workqueue_struct *ext4_read_workqueue;
+static DEFINE_MUTEX(crypto_init);
+
+/**
+ * ext4_exit_crypto() - Shutdown the ext4 encryption system
+ */
+void ext4_exit_crypto(void)
+{
+	struct ext4_crypto_ctx *pos, *n;
+
+	list_for_each_entry_safe(pos, n, &ext4_free_crypto_ctxs, free_list) {
+		if (pos->bounce_page) {
+			if (pos->flags &
+			    EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL) {
+				__free_page(pos->bounce_page);
+			} else {
+				mempool_free(pos->bounce_page,
+					     ext4_bounce_page_pool);
+			}
+		}
+		if (pos->tfm)
+			crypto_free_tfm(pos->tfm);
+		kfree(pos);
+	}
+	INIT_LIST_HEAD(&ext4_free_crypto_ctxs);
+	if (ext4_bounce_page_pool)
+		mempool_destroy(ext4_bounce_page_pool);
+	ext4_bounce_page_pool = NULL;
+	if (ext4_read_workqueue)
+		destroy_workqueue(ext4_read_workqueue);
+	ext4_read_workqueue = NULL;
+}
+
+/**
+ * ext4_init_crypto() - Set up for ext4 encryption.
+ *
+ * We call this when we mount a file system which has the encryption
+ * feature enabled, since it results in memory getting allocated that
+ * won't be used unless we are using encryption.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+int ext4_init_crypto(void)
+{
+	int i, res = 0;
+
+	mutex_lock(&crypto_init);
+	if (ext4_read_workqueue)
+		goto already_initialized;
+	ext4_read_workqueue = alloc_workqueue("ext4_crypto", WQ_HIGHPRI, 0);
+	if (!ext4_read_workqueue) {
+		res = -ENOMEM;
+		goto fail;
+	}
+
+	for (i = 0; i < num_prealloc_crypto_ctxs; i++) {
+		struct ext4_crypto_ctx *ctx;
+
+		ctx = ext4_alloc_and_init_crypto_ctx(GFP_KERNEL);
+		if (IS_ERR(ctx)) {
+			res = PTR_ERR(ctx);
+			goto fail;
+		}
+		list_add(&ctx->free_list, &ext4_free_crypto_ctxs);
+	}
+
+	ext4_bounce_page_pool =
+		mempool_create_page_pool(num_prealloc_crypto_pages, 0);
+	if (!ext4_bounce_page_pool)
+		goto fail;
+already_initialized:
+	mutex_unlock(&crypto_init);
+	return 0;
+fail:
+	ext4_exit_crypto();
+	mutex_unlock(&crypto_init);
+	return res;
+}
+
+/**
+ * ext4_xts_tweak_for_page() - Generates an XTS tweak for a page
+ * @xts_tweak: Buffer into which this writes the XTS tweak.
+ * @page:      The page for which this generates a tweak.
+ *
+ * Generates an XTS tweak value for the given page.
+ */
+static void ext4_xts_tweak_for_page(u8 xts_tweak[EXT4_XTS_TWEAK_SIZE],
+				    const struct page *page)
+{
+	/* Only do this for XTS tweak values. For other modes (CBC,
+	 * GCM, etc.), you most likely will need to do something
+	 * different. */
+	BUILD_BUG_ON(EXT4_XTS_TWEAK_SIZE < sizeof(page->index));
+	memcpy(xts_tweak, &page->index, sizeof(page->index));
+	memset(&xts_tweak[sizeof(page->index)], 0,
+	       EXT4_XTS_TWEAK_SIZE - sizeof(page->index));
+}
+
+void ext4_restore_control_page(struct page *data_page)
+{
+	struct ext4_crypto_ctx *ctx =
+		(struct ext4_crypto_ctx *)page_private(data_page);
+
+	set_page_private(data_page, (unsigned long)NULL);
+	ClearPagePrivate(data_page);
+	unlock_page(data_page);
+	ext4_release_crypto_ctx(ctx);
+}
+
+struct ext4_crypt_result {
+	struct completion completion;
+	int res;
+};
+
+/**
+ * ext4_crypt_complete() - The completion callback for page encryption
+ * @req: The asynchronous encryption request context
+ * @res: The result of the encryption operation
+ */
+static void ext4_crypt_complete(struct crypto_async_request *req, int res)
+{
+	struct ext4_crypt_result *ecr = req->data;
+
+	if (res == -EINPROGRESS)
+		return;
+	ecr->res = res;
+	complete(&ecr->completion);
+}
+
+/**
+ * ext4_prep_pages_for_write() - Prepares pages for write
+ * @ciphertext_page: Ciphertext page that will actually be written.
+ * @plaintext_page:  Plaintext page that acts as a control page.
+ * @ctx:             Encryption context for the pages.
+ */
+static void ext4_prep_pages_for_write(struct page *ciphertext_page,
+				      struct page *plaintext_page,
+				      struct ext4_crypto_ctx *ctx)
+{
+	SetPageDirty(ciphertext_page);
+	SetPagePrivate(ciphertext_page);
+	ctx->control_page = plaintext_page;
+	set_page_private(ciphertext_page, (unsigned long)ctx);
+	lock_page(ciphertext_page);
+}
+
+/**
+ * ext4_xts_encrypt() - Encrypts a page using AES-256-XTS
+ * @ctx:            The encryption context.
+ * @plaintext_page: The page to encrypt. Must be locked.
+ *
+ * Allocates a ciphertext page and encrypts plaintext_page into it using the ctx
+ * encryption context. Uses AES-256-XTS.
+ *
+ * Called on the page write path.
+ *
+ * Return: An allocated page with the encrypted content on success. Else, an
+ * error value or NULL.
+ */
+static struct page *ext4_xts_encrypt(struct ext4_crypto_ctx *ctx,
+				     struct page *plaintext_page)
+{
+	struct page *ciphertext_page = ctx->bounce_page;
+	u8 xts_tweak[EXT4_XTS_TWEAK_SIZE];
+	struct ablkcipher_request *req = NULL;
+	struct ext4_crypt_result ecr;
+	struct scatterlist dst, src;
+	struct ext4_inode_info *ei = EXT4_I(plaintext_page->mapping->host);
+	struct crypto_ablkcipher *atfm = __crypto_ablkcipher_cast(ctx->tfm);
+	int res = 0;
+
+	BUG_ON(!ciphertext_page);
+	BUG_ON(!ctx->tfm);
+	BUG_ON(ei->i_encryption_key.mode != EXT4_ENCRYPTION_MODE_AES_256_XTS);
+	crypto_ablkcipher_clear_flags(atfm, ~0);
+	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+
+	/* Since in AES-256-XTS mode we only perform one cryptographic operation
+	 * on each block and there are no constraints about how many blocks a
+	 * single key can encrypt, we directly use the inode master key */
+	res = crypto_ablkcipher_setkey(atfm, ei->i_encryption_key.raw,
+				       ei->i_encryption_key.size);
+	req = ablkcipher_request_alloc(atfm, GFP_NOFS);
+	if (!req) {
+		printk_ratelimited(KERN_ERR
+				   "%s: crypto_request_alloc() failed\n",
+				   __func__);
+		ciphertext_page = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	ablkcipher_request_set_callback(
+		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_crypt_complete, &ecr);
+	ext4_xts_tweak_for_page(xts_tweak, plaintext_page);
+	sg_init_table(&dst, 1);
+	sg_set_page(&dst, ciphertext_page, PAGE_CACHE_SIZE, 0);
+	sg_init_table(&src, 1);
+	sg_set_page(&src, plaintext_page, PAGE_CACHE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
+				     xts_tweak);
+	res = crypto_ablkcipher_encrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+	}
+	ablkcipher_request_free(req);
+	if (res) {
+		printk_ratelimited(
+			KERN_ERR
+			"%s: crypto_ablkcipher_encrypt() returned %d\n",
+			__func__, res);
+		ciphertext_page = ERR_PTR(res);
+		goto out;
+	}
+out:
+	return ciphertext_page;
+}
+
+/**
+ * ext4_encrypt() - Encrypts a page
+ * @ctx:            The encryption context.
+ * @plaintext_page: The page to encrypt. Must be locked.
+ *
+ * Allocates a ciphertext page and encrypts plaintext_page into it using the ctx
+ * encryption context.
+ *
+ * Called on the page write path.
+ *
+ * Return: An allocated page with the encrypted content on success. Else, an
+ * error value or NULL.
+ */
+struct page *ext4_encrypt(struct inode *inode,
+			  struct page *plaintext_page)
+{
+	struct ext4_crypto_ctx *ctx;
+	struct page *ciphertext_page = NULL;
+
+	BUG_ON(!PageLocked(plaintext_page));
+
+	ctx = ext4_get_crypto_ctx(inode);
+	if (IS_ERR(ctx))
+		return (struct page *) ctx;
+
+	/* The encryption operation will require a bounce page. */
+	ctx->bounce_page = alloc_page(GFP_NOFS);
+	if (!ctx->bounce_page) {
+		/* This is a potential bottleneck, but at least we'll have
+		 * forward progress. */
+		ctx->bounce_page = mempool_alloc(ext4_bounce_page_pool,
+						 GFP_NOFS);
+		if (WARN_ON_ONCE(!ctx->bounce_page)) {
+			ctx->bounce_page = mempool_alloc(ext4_bounce_page_pool,
+							 GFP_NOFS | __GFP_WAIT);
+		}
+		ctx->flags &= ~EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
+	} else {
+		ctx->flags |= EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
+	}
+
+	switch (ctx->mode) {
+	case EXT4_ENCRYPTION_MODE_AES_256_XTS:
+		ciphertext_page = ext4_xts_encrypt(ctx, plaintext_page);
+		break;
+	case EXT4_ENCRYPTION_MODE_AES_256_GCM:
+		/* TODO(mhalcrow): We'll need buffers for the
+		 * generated IV and/or auth tag for this mode and the
+		 * ones below */
+		ciphertext_page = ERR_PTR(-ENOTSUPP);
+		break;
+	default:
+		BUG();
+	}
+	if (IS_ERR_OR_NULL(ciphertext_page))
+		ext4_release_crypto_ctx(ctx);
+	else
+		ext4_prep_pages_for_write(ciphertext_page, plaintext_page, ctx);
+	return ciphertext_page;
+}
+
+/**
+ * ext4_xts_decrypt() - Decrypts a page using AES-256-XTS
+ * @ctx:  The encryption context.
+ * @page: The page to decrypt. Must be locked.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+static int ext4_xts_decrypt(struct ext4_crypto_ctx *ctx, struct page *page)
+{
+	u8 xts_tweak[EXT4_XTS_TWEAK_SIZE];
+	struct ablkcipher_request *req = NULL;
+	struct ext4_crypt_result ecr;
+	struct scatterlist sg;
+	struct ext4_inode_info *ei = EXT4_I(page->mapping->host);
+	struct crypto_ablkcipher *atfm = __crypto_ablkcipher_cast(ctx->tfm);
+	int res = 0;
+
+	BUG_ON(!ctx->tfm);
+	BUG_ON(ei->i_encryption_key.mode != EXT4_ENCRYPTION_MODE_AES_256_XTS);
+	crypto_ablkcipher_clear_flags(atfm, ~0);
+	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+
+	/* Since in AES-256-XTS mode we only perform one cryptographic operation
+	 * on each block and there are no constraints about how many blocks a
+	 * single key can encrypt, we directly use the inode master key */
+	res = crypto_ablkcipher_setkey(atfm, ei->i_encryption_key.raw,
+				       ei->i_encryption_key.size);
+	req = ablkcipher_request_alloc(atfm, GFP_NOFS);
+	if (!req) {
+		res = -ENOMEM;
+		goto out;
+	}
+	ablkcipher_request_set_callback(
+		req, CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_crypt_complete, &ecr);
+	ext4_xts_tweak_for_page(xts_tweak, page);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, page, PAGE_CACHE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, &sg, &sg, PAGE_CACHE_SIZE, xts_tweak);
+	res = crypto_ablkcipher_decrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+	}
+	ablkcipher_request_free(req);
+out:
+	if (res)
+		printk_ratelimited(KERN_ERR "%s: res = %d\n", __func__, res);
+	return res;
+}
+
+/**
+ * ext4_decrypt() - Decrypts a page in-place
+ * @ctx:  The encryption context.
+ * @page: The page to decrypt. Must be locked.
+ *
+ * Decrypts page in-place using the ctx encryption context.
+ *
+ * Called from the read completion callback.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+int ext4_decrypt(struct ext4_crypto_ctx *ctx, struct page *page)
+{
+	int res = 0;
+
+	BUG_ON(!PageLocked(page));
+
+	switch (ctx->mode) {
+	case EXT4_ENCRYPTION_MODE_AES_256_XTS:
+		res = ext4_xts_decrypt(ctx, page);
+		break;
+	case EXT4_ENCRYPTION_MODE_AES_256_GCM:
+		res = -ENOTSUPP;
+		break;
+	default:
+		BUG();
+	}
+	return res;
+}
+
+/*
+ * Convenience function which takes care of allocating and
+ * deallocating the encryption context
+ */
+int ext4_decrypt_one(struct inode *inode, struct page *page)
+{
+	int ret;
+
+	struct ext4_crypto_ctx *ctx = ext4_get_crypto_ctx(inode);
+	if (!ctx)
+		return -ENOMEM;
+	ret = ext4_decrypt(ctx, page);
+	ext4_release_crypto_ctx(ctx);
+	return ret;
+}
+
+/**
+ * ext4_validate_encryption_mode() - Validates the encryption key mode
+ * @mode: The key mode to validate.
+ *
+ * Return: The validated key mode. EXT4_ENCRYPTION_MODE_INVALID if invalid.
+ */
+uint32_t ext4_validate_encryption_mode(uint32_t mode)
+{
+	switch (mode) {
+	case EXT4_ENCRYPTION_MODE_AES_256_XTS:
+		return mode;
+	case EXT4_ENCRYPTION_MODE_AES_256_CBC:
+		return mode;
+	default:
+		break;
+	}
+	return EXT4_ENCRYPTION_MODE_INVALID;
+}
+
+/**
+ * ext4_validate_encryption_key_size() - Validate the encryption key size
+ * @mode: The key mode.
+ * @size: The key size to validate.
+ *
+ * Return: The validated key size for @mode. Zero if invalid.
+ */
+uint32_t ext4_validate_encryption_key_size(uint32_t mode, uint32_t size)
+{
+	if (size == ext4_encryption_key_size(mode))
+		return size;
+	return 0;
+}
diff --git a/fs/ext4/crypto_policy.c b/fs/ext4/crypto_policy.c
index 5cb4e74..3ff4c75 100644
--- a/fs/ext4/crypto_policy.c
+++ b/fs/ext4/crypto_policy.c
@@ -71,14 +71,31 @@ static int ext4_create_encryption_context_from_policy(
 	ctx.format = EXT4_ENCRYPTION_CONTEXT_FORMAT_V0;
 	memcpy(ctx.master_key_descriptor, policy->master_key_descriptor,
 	       EXT4_KEY_DESCRIPTOR_SIZE);
-	ctx.contents_encryption_mode = policy->contents_encryption_mode;
-	ctx.filenames_encryption_mode = policy->filenames_encryption_mode;
+	ctx.contents_encryption_mode = ext4_validate_encryption_mode(
+		policy->contents_encryption_mode);
+	if (ctx.contents_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID) {
+		printk(KERN_WARNING
+		       "%s: Invalid contents encryption mode %d\n", __func__,
+			policy->contents_encryption_mode);
+		res = -EINVAL;
+		goto out;
+	}
+	ctx.filenames_encryption_mode = ext4_validate_encryption_mode(
+		policy->filenames_encryption_mode);
+	if (ctx.filenames_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID) {
+		printk(KERN_WARNING
+		       "%s: Invalid filenames encryption mode %d\n", __func__,
+			policy->filenames_encryption_mode);
+		res = -EINVAL;
+		goto out;
+	}
 	BUILD_BUG_ON(sizeof(ctx.nonce) != EXT4_KEY_DERIVATION_NONCE_SIZE);
 	get_random_bytes(ctx.nonce, EXT4_KEY_DERIVATION_NONCE_SIZE);
 
 	res = ext4_xattr_set(inode, EXT4_XATTR_INDEX_ENCRYPTION,
 			     EXT4_XATTR_NAME_ENCRYPTION_CONTEXT, &ctx,
 			     sizeof(ctx), 0);
+out:
 	if (!res)
 		ext4_set_inode_flag(inode, EXT4_INODE_ENCRYPT);
 	return res;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2d7fcb6..f7ee6c0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -948,6 +948,11 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	/* Encryption params */
+	struct ext4_encryption_key i_encryption_key;
+#endif
 };
 
 /*
@@ -1349,6 +1354,12 @@ struct ext4_sb_info {
 	struct ratelimit_state s_err_ratelimit_state;
 	struct ratelimit_state s_warning_ratelimit_state;
 	struct ratelimit_state s_msg_ratelimit_state;
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	/* Encryption */
+	uint32_t s_file_encryption_mode;
+	uint32_t s_dir_encryption_mode;
+#endif
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1998,6 +2009,34 @@ extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 					      struct ext4_group_desc *gdp);
 ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 
+/* crypto.c */
+uint32_t ext4_validate_encryption_mode(uint32_t mode);
+uint32_t ext4_validate_encryption_key_size(uint32_t mode, uint32_t size);
+extern struct workqueue_struct *ext4_read_workqueue;
+struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct inode *inode);
+void ext4_release_crypto_ctx(struct ext4_crypto_ctx *ctx);
+void ext4_restore_control_page(struct page *data_page);
+struct page *ext4_encrypt(struct inode *inode,
+			  struct page *plaintext_page);
+int ext4_decrypt(struct ext4_crypto_ctx *ctx, struct page *page);
+int ext4_decrypt_one(struct inode *inode, struct page *page);
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+int ext4_init_crypto(void);
+void ext4_exit_crypto(void);
+static inline int ext4_sb_has_crypto(struct super_block *sb)
+{
+	return EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_ENCRYPT);
+}
+#else
+static inline int ext4_init_crypto(void) { return 0; }
+static inline void ext4_exit_crypto(void) { }
+static inline int ext4_sb_has_crypto(struct super_block *sb)
+{
+	return 0;
+}
+#endif
+
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 				  struct file *,
diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
index 984ff38..fb73935 100644
--- a/fs/ext4/ext4_crypto.h
+++ b/fs/ext4/ext4_crypto.h
@@ -51,4 +51,47 @@ void ext4_to_hex(char *dst, char *src, size_t src_size);
 int ext4_process_policy(const struct ext4_encryption_policy *policy,
 			struct inode *inode);
 
+/* Encryption parameters */
+#define EXT4_AES_256_XTS_KEY_SIZE 64
+#define EXT4_XTS_TWEAK_SIZE 16
+#define EXT4_AES_128_ECB_KEY_SIZE 16
+#define EXT4_AES_256_GCM_KEY_SIZE 32
+#define EXT4_AES_256_CBC_KEY_SIZE 32
+#define EXT4_MAX_KEY_SIZE 64
+
+struct ext4_encryption_key {
+	uint32_t mode;
+	char raw[EXT4_MAX_KEY_SIZE];
+	uint32_t size;
+};
+
+#define EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL             0x00000001
+#define EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL     0x00000002
+
+struct ext4_crypto_ctx {
+	struct crypto_tfm *tfm;         /* Crypto API context */
+	struct page *bounce_page;       /* Ciphertext page on write path */
+	struct page *control_page;      /* Original page on write path */
+	struct bio *bio;                /* The bio for this context */
+	struct work_struct work;        /* Work queue for read complete path */
+	struct list_head free_list;     /* Free list */
+	int flags;                      /* Flags */
+	int mode;                       /* Encryption mode for tfm */
+};
+
+static inline int ext4_encryption_key_size(int mode)
+{
+	switch (mode) {
+	case EXT4_ENCRYPTION_MODE_AES_256_XTS:
+		return EXT4_AES_256_XTS_KEY_SIZE;
+	case EXT4_ENCRYPTION_MODE_AES_256_GCM:
+		return EXT4_AES_256_GCM_KEY_SIZE;
+	case EXT4_ENCRYPTION_MODE_AES_256_CBC:
+		return EXT4_AES_256_CBC_KEY_SIZE;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
 #endif	/* _EXT4_CRYPTO_H */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 74c5f53..3dcafe9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -893,6 +893,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	ei->i_encryption_key.mode = EXT4_ENCRYPTION_MODE_INVALID;
+#endif
 
 	return &ei->vfs_inode;
 }
@@ -3439,6 +3442,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_bdev->bd_part)
 		sbi->s_sectors_written_start =
 			part_stat_read(sb->s_bdev->bd_part, sectors[1]);
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	/* Modes of operations for file and directory encryption. */
+	sbi->s_file_encryption_mode = EXT4_ENCRYPTION_MODE_AES_256_XTS;
+	sbi->s_dir_encryption_mode = EXT4_ENCRYPTION_MODE_INVALID;
+#endif
 
 	/* Cleanup superblock name */
 	for (cp = sb->s_id; (cp = strchr(cp, '/'));)
@@ -4052,6 +4060,9 @@ no_journal:
 		goto failed_mount4;
 	}
 
+	if (ext4_sb_has_crypto(sb))
+		ext4_init_crypto();
+
 	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
-- 
2.3.0

