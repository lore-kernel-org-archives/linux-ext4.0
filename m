From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 2/5] ext4: Adds EXT4 encryption facilities
Date: Wed, 23 Jul 2014 14:23:25 -0700
Message-ID: <1406150608-19351-3-git-send-email-mhalcrow@google.com>
References: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Cc: zohar@linux.vnet.ibm.com, mhalcrow@google.com,
	herbert@gondor.apana.org.au, pavel@ucw.cz, hch@infradead.org,
	lczerner@redhat.com, tytso@mit.edu, tyhicks@canonical.com,
	serge.hallyn@canonical.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1406150608-19351-1-git-send-email-mhalcrow@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Adds EXT4 encryption facilities.

On encrypt, we will re-assign the buffer_heads to point to a bounce
page rather than the control_page (which is the original page to write
that contains the plaintext). The block I/O occurs against the bounce
page. On write completion, we re-assign the buffer_heads to the
original plaintext page.

On decrypt, we will attach a read completion callback to the bio
struct. This read completion will decrypt the read contents in-place
prior to setting the page up-to-date.

The current encryption mode, AES-256-XTS, represents the first of 5
encryption modes on the roadmap. Future in-plan modes are
HMAC-SHA1+RANDOM_NONCE (integrity only), AES-256-XTS+HMAC-SHA1,
AES-256-XTS+RANDOM_TWEAK+HMAC-SHA1, and AES-256-GCM. These all depend
on a future per-block metadata feature in EXT4.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
---
 fs/ext4/Makefile |   9 +-
 fs/ext4/crypto.c | 624 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |  49 +++++
 fs/ext4/super.c  |  34 ++-
 fs/ext4/xattr.h  |   1 +
 5 files changed, 711 insertions(+), 6 deletions(-)
 create mode 100644 fs/ext4/crypto.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 0310fec..de4de1c 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -4,10 +4,11 @@
 
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
-ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
-		ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		ext4_jbd2.o migrate.o mballoc.o block_validity.o move_extent.o \
-		mmp.o indirect.o extents_status.o xattr.o xattr_user.o \
+ext4-y := balloc.o bitmap.o crypto.o dir.o file.o fsync.o ialloc.o	\
+		inode.o page-io.o ioctl.o namei.o super.o symlink.o	\
+		hash.o resize.o extents.o ext4_jbd2.o migrate.o		\
+		mballoc.o block_validity.o move_extent.o mmp.o		\
+		indirect.o extents_status.o xattr.o xattr_user.o	\
 		xattr_trusted.o inline.o
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
new file mode 100644
index 0000000..6fbb4fa
--- /dev/null
+++ b/fs/ext4/crypto.c
@@ -0,0 +1,624 @@
+/*
+ * linux/fs/ext4/crypto.c
+ *
+ * This contains encryption functions for ext4
+ *
+ * Written by Michael Halcrow, 2014.
+ *
+ * This has not yet undergone a rigorous security audit. The usage of
+ * AES-XTS should conform to recommendations in NIST Special
+ * Publication 800-38E under the stated adversarial model.
+ *
+ * This intends to protect only file data content confidentiality
+ * against a single point-in-time permanent offline compromise of
+ * block device. If the adversary can access the changing ciphertext
+ * at various points in time, this is susceptible to attacks.
+ *
+ * The roadmap includes adding support for encryption modes with
+ * integrity in order to achieve IND-CCA2 security.
+ *
+ * The key management is a minimally functional placeholder for a more
+ * sophisticated mechanism down the road.
+ */
+
+#include <keys/user-type.h>
+#include <keys/encrypted-type.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/key.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock_types.h>
+
+#include "ext4.h"
+#include "xattr.h"
+
+/* Encryption added and removed here! (L: */
+
+mempool_t *ext4_bounce_page_pool = NULL;
+
+LIST_HEAD(ext4_free_crypto_ctxs);
+DEFINE_SPINLOCK(ext4_crypto_ctx_lock);
+
+/* TODO(mhalcrow): Remove for release */
+atomic_t ext4_dbg_pages = ATOMIC_INIT(0);
+atomic_t ext4_dbg_ctxs = ATOMIC_INIT(0);
+
+/**
+ * ext4_release_crypto_ctx() - Releases an encryption context
+ * @ctx: The encryption context to release.
+ *
+ * If the encryption context was allocated from the pre-allocated
+ * pool, returns it to that pool. Else, frees it.
+ *
+ * If there's a bounce page in the context, frees that.
+ */
+void ext4_release_crypto_ctx(ext4_crypto_ctx_t *ctx)
+{
+	unsigned long flags;
+	if (ctx->bounce_page) {
+		if (ctx->flags & EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL) {
+			__free_page(ctx->bounce_page);
+			atomic_dec(&ext4_dbg_pages);
+		} else {
+			mempool_free(ctx->bounce_page, ext4_bounce_page_pool);
+		}
+		ctx->bounce_page = NULL;
+	}
+	if (ctx->flags & EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL) {
+		if (ctx->tfm)
+			crypto_free_ablkcipher(ctx->tfm);
+		kfree(ctx);
+		atomic_dec(&ext4_dbg_ctxs);
+	} else {
+		spin_lock_irqsave(&ext4_crypto_ctx_lock, flags);
+		list_add(&ctx->free_list, &ext4_free_crypto_ctxs);
+		spin_unlock_irqrestore(&ext4_crypto_ctx_lock, flags);
+	}
+}
+
+/**
+ * __alloc_and_init_crypto_ctx() - Allocates/initializes an encryption context
+ * @mask: The allocation mask.
+ *
+ * Return: An allocated and initialized encryption context on
+ * success. An error value or NULL otherwise.
+ */
+static ext4_crypto_ctx_t *__alloc_and_init_crypto_ctx(u32 mask)
+{
+	ext4_crypto_ctx_t *ctx = kzalloc(sizeof(ext4_crypto_ctx_t), mask);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+	atomic_inc(&ext4_dbg_ctxs);
+	return ctx;
+}
+
+/**
+ * ext4_get_crypto_ctx() - Gets an encryption context
+ * @with_page:       If true, allocates and attaches a bounce page
+ * @aes_256_xts_key: The 64-byte encryption key for AES-XTS.
+ *
+ * Allocates and initializes an encryption context.
+ *
+ * Return: An allocated and initialized encryption context on success;
+ * error value or NULL otherwise.
+ */
+ext4_crypto_ctx_t *ext4_get_crypto_ctx(
+	bool with_page, u8 aes_256_xts_key[EXT4_AES_256_XTS_KEY_SIZE])
+{
+	ext4_crypto_ctx_t *ctx = NULL;
+	int res = 0;
+	unsigned long flags;
+
+	/* We first try getting the ctx from a free list because in
+	 * the common case the ctx will have an allocated and
+	 * initialized crypto ablkcipher, so it's probably a
+	 * worthwhile optimization. For the bounce page, we first try
+	 * getting it from the kernel allocator because that's just
+	 * about as fast as getting it from a list and because a cache
+	 * of free pages should generally be a "last resort" option
+	 * for a filesystem to be able to do its job. */
+	spin_lock_irqsave(&ext4_crypto_ctx_lock, flags);
+	ctx = list_first_entry_or_null(&ext4_free_crypto_ctxs,
+				       ext4_crypto_ctx_t, free_list);
+	if (ctx)
+		list_del(&ctx->free_list);
+	spin_unlock_irqrestore(&ext4_crypto_ctx_lock, flags);
+	if (!ctx) {
+		ctx = __alloc_and_init_crypto_ctx(GFP_NOFS);
+		if (IS_ERR(ctx)) {
+			res = PTR_ERR(ctx);
+			goto out;
+		}
+		ctx->flags |= EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL;
+	} else {
+		ctx->flags &= ~EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL;
+	}
+
+	/* Allocate a new Crypto API context if we don't already have
+	 * one. */
+	if (!ctx->tfm) {
+		ctx->tfm = crypto_alloc_ablkcipher("xts(aes)", 0, 0);
+		if (IS_ERR(ctx->tfm)) {
+			res = PTR_ERR(ctx->tfm);
+			ctx->tfm = NULL;
+			goto out;
+		}
+	}
+
+	/* Initialize the encryption engine with the secret symmetric
+	 * key. */
+	crypto_ablkcipher_set_flags(ctx->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	res = crypto_ablkcipher_setkey(ctx->tfm, aes_256_xts_key,
+				       EXT4_AES_256_XTS_KEY_SIZE);
+	if (res)
+		goto out;
+
+	/* There shouldn't be a bounce page attached to the crypto
+	 * context at this point. */
+	BUG_ON(ctx->bounce_page);
+	if (!with_page)
+		goto out;
+
+	/* The encryption operation will require a bounce page. */
+	ctx->bounce_page = alloc_page(GFP_NOFS);
+	if (!ctx->bounce_page) {
+		/* This is a potential bottleneck, but at least we'll
+		 * have forward progress. */
+		ctx->bounce_page = mempool_alloc(ext4_bounce_page_pool,
+						 GFP_NOFS);
+		if (WARN_ON_ONCE(!ctx->bounce_page)) {
+			ctx->bounce_page = mempool_alloc(ext4_bounce_page_pool,
+							 GFP_NOFS | __GFP_WAIT);
+		}
+		ctx->flags &= ~EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
+	} else {
+		atomic_inc(&ext4_dbg_pages);
+		ctx->flags |= EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL;
+	}
+out:
+	if (res) {
+		if (!IS_ERR_OR_NULL(ctx))
+			ext4_release_crypto_ctx(ctx);
+		ctx = ERR_PTR(res);
+	}
+	return ctx;
+}
+
+struct workqueue_struct *mpage_read_workqueue;
+
+/**
+ * ext4_delete_crypto_ctxs() - Deletes/frees all encryption contexts
+ */
+static void ext4_delete_crypto_ctxs(void)
+{
+	ext4_crypto_ctx_t *pos, *n;
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
+			crypto_free_ablkcipher(pos->tfm);
+		kfree(pos);
+	}
+}
+
+/**
+ * ext4_allocate_crypto_ctxs() -  Allocates a pool of encryption contexts
+ * @num_to_allocate: The number of encryption contexts to allocate.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+static int __init ext4_allocate_crypto_ctxs(size_t num_to_allocate)
+{
+	ext4_crypto_ctx_t *ctx = NULL;
+
+	while (num_to_allocate > 0) {
+		ctx = __alloc_and_init_crypto_ctx(GFP_KERNEL);
+		if (IS_ERR(ctx))
+			break;
+		list_add(&ctx->free_list, &ext4_free_crypto_ctxs);
+		num_to_allocate--;
+	}
+	if (IS_ERR(ctx))
+		ext4_delete_crypto_ctxs();
+	return PTR_ERR_OR_ZERO(ctx);
+}
+
+/**
+ * ext4_delete_crypto() - Frees all allocated encryption objects
+ */
+void ext4_delete_crypto(void)
+{
+	ext4_delete_crypto_ctxs();
+	mempool_destroy(ext4_bounce_page_pool);
+	destroy_workqueue(mpage_read_workqueue);
+}
+
+/**
+ * ext4_allocate_crypto() - Allocates encryption objects for later use
+ * @num_crypto_pages: The number of bounce pages to allocate for encryption.
+ * @num_crypto_ctxs:  The number of encryption contexts to allocate.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+int __init ext4_allocate_crypto(size_t num_crypto_pages, size_t num_crypto_ctxs)
+{
+	int res = 0;
+	mpage_read_workqueue = alloc_workqueue("ext4_crypto", WQ_HIGHPRI, 0);
+	if (!mpage_read_workqueue) {
+		res = -ENOMEM;
+		goto fail;
+	}
+	res = ext4_allocate_crypto_ctxs(num_crypto_ctxs);
+	if (res)
+		goto fail;
+	ext4_bounce_page_pool = mempool_create_page_pool(num_crypto_pages, 0);
+	if (!ext4_bounce_page_pool)
+		goto fail;
+	return 0;
+fail:
+	ext4_delete_crypto();
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
+				    struct page *page)
+{
+	/* Only do this for XTS tweak values. For other modes (CBC,
+	 * GCM, etc.), you most like will need to do something
+	 * different. */
+	BUILD_BUG_ON(EXT4_XTS_TWEAK_SIZE < sizeof(page->index));
+	memcpy(xts_tweak, &page->index, sizeof(page->index));
+	memset(&xts_tweak[sizeof(page->index)], 0,
+	       EXT4_XTS_TWEAK_SIZE - sizeof(page->index));
+}
+
+/**
+ * set_bh_to_page() - Re-assigns the pages for a set of buffer heads
+ * @head: The head of the buffer list to reassign.
+ * @page: The page to which to re-assign the buffer heads.
+ */
+void set_bh_to_page(struct buffer_head *head, struct page *page)
+{
+	struct buffer_head *bh = head;
+	do {
+		set_bh_page(bh, page, bh_offset(bh));
+		if (PageDirty(page))
+			set_buffer_dirty(bh);
+		if (!bh->b_this_page)
+			bh->b_this_page = head;
+	} while ((bh = bh->b_this_page) != head);
+}
+
+typedef struct ext4_crypt_result {
+	struct completion completion;
+	int res;
+} ext4_crypt_result_t;
+
+static void ext4_crypt_complete(struct crypto_async_request *req, int res)
+{
+	ext4_crypt_result_t *ecr = req->data;
+	if (res == -EINPROGRESS)
+		return;
+	ecr->res = res;
+	complete(&ecr->completion);
+}
+
+/**
+ * ext4_encrypt() - Encrypts a page
+ * @ctx:            The encryption context.
+ * @plaintext_page: The page to encrypt. Must be locked.
+ *
+ * Allocates a ciphertext page and encrypts plaintext_page into it
+ * using the ctx encryption context.
+ *
+ * Called on the page write path.
+ *
+ * Return: An allocated page with the encrypted content on
+ * success. Else, an error value or NULL.
+ */
+struct page *ext4_encrypt(ext4_crypto_ctx_t *ctx, struct page *plaintext_page)
+{
+	struct page *ciphertext_page = ctx->bounce_page;
+	u8 xts_tweak[EXT4_XTS_TWEAK_SIZE];
+	struct ablkcipher_request *req = NULL;
+	struct ext4_crypt_result ecr;
+	struct scatterlist dst, src;
+	int res = 0;
+	BUG_ON(!ciphertext_page);
+	req = ablkcipher_request_alloc(ctx->tfm, GFP_NOFS);
+	if (!req) {
+		printk_ratelimited(KERN_ERR
+				   "%s: crypto_request_alloc() failed\n",
+				   __func__);
+		ciphertext_page = ERR_PTR(-ENOMEM);
+		goto out;
+	}
+	ablkcipher_request_set_callback(req,
+			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+			ext4_crypt_complete, &ecr);
+	ext4_xts_tweak_for_page(xts_tweak, plaintext_page);
+	sg_init_table(&dst, 1);
+	sg_init_table(&src, 1);
+	sg_set_page(&dst, ciphertext_page, PAGE_CACHE_SIZE, 0);
+	sg_set_page(&src, plaintext_page, PAGE_CACHE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
+				     xts_tweak);
+	res = crypto_ablkcipher_encrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		reinit_completion(&ecr.completion);
+	}
+	ablkcipher_request_free(req);
+	if (res) {
+		printk_ratelimited(KERN_ERR "%s: crypto_ablkcipher_encrypt() "
+				   "returned %d\n", __func__, res);
+		ciphertext_page = ERR_PTR(res);
+		goto out;
+	}
+	SetPageDirty(ciphertext_page);
+	SetPagePrivate(ciphertext_page);
+	ctx->control_page = plaintext_page;
+	set_page_private(ciphertext_page, (unsigned long)ctx);
+	set_bh_to_page(page_buffers(plaintext_page), ciphertext_page);
+out:
+	return ciphertext_page;
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
+int ext4_decrypt(ext4_crypto_ctx_t *ctx, struct page* page)
+{
+	u8 xts_tweak[EXT4_XTS_TWEAK_SIZE];
+	struct ablkcipher_request *req = NULL;
+	struct ext4_crypt_result ecr;
+	struct scatterlist dst, src;
+	int res = 0;
+	BUG_ON(!ctx->tfm);
+	req = ablkcipher_request_alloc(ctx->tfm, GFP_NOFS);
+	if (!req) {
+		res = -ENOMEM;
+		goto out;
+	}
+	ablkcipher_request_set_callback(req,
+			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+			ext4_crypt_complete, &ecr);
+	ext4_xts_tweak_for_page(xts_tweak, page);
+	sg_init_table(&dst, 1);
+	sg_init_table(&src, 1);
+	sg_set_page(&dst, page, PAGE_CACHE_SIZE, 0);
+	sg_set_page(&src, page, PAGE_CACHE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
+				     xts_tweak);
+	res = crypto_ablkcipher_decrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		reinit_completion(&ecr.completion);
+	}
+	ablkcipher_request_free(req);
+out:
+	if (res)
+		printk_ratelimited(KERN_ERR "%s: res = [%d]\n", __func__, res);
+	return res;
+}
+
+/**
+ * __get_wrapping_key() - Gets the wrapping key from the user session keyring
+ * @wrapping_key: Buffer into which this writes the wrapping key.
+ * @sbi:          The EXT4 superblock info struct.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+static int __get_wrapping_key(char wrapping_key[EXT4_DEFAULT_WRAPPING_KEY_SIZE],
+			      struct ext4_sb_info *sbi)
+{
+	struct key *create_key;
+	struct encrypted_key_payload *payload;
+	struct ecryptfs_auth_tok *auth_tok;
+	create_key = request_key(&key_type_user, sbi->s_crypto_key_sig, NULL);
+	if (WARN_ON_ONCE(IS_ERR(create_key)))
+		return -ENOENT;
+	payload = (struct encrypted_key_payload *)create_key->payload.data;
+	if (WARN_ON_ONCE(create_key->datalen !=
+			 sizeof(struct ecryptfs_auth_tok))) {
+		return -EINVAL;
+	}
+	auth_tok = (struct ecryptfs_auth_tok *)(&(payload)->payload_data);
+	if (WARN_ON_ONCE(!(auth_tok->token.password.flags &
+			   ECRYPTFS_SESSION_KEY_ENCRYPTION_KEY_SET))) {
+		return -EINVAL;
+	}
+	memcpy(wrapping_key,
+	       auth_tok->token.password.session_key_encryption_key,
+	       EXT4_DEFAULT_WRAPPING_KEY_SIZE);
+	return 0;
+}
+
+/**
+ * ext4_unwrap_key() - Unwraps the encryption key for the inode.
+ * @crypto_key:         The buffer into which this writes the unwrapped key.
+ * @wrapped_crypto_key: The wrapped encryption key.
+ * @inode:              The inode for the encryption key.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+static int ext4_unwrap_key(char *crypto_key, char *wrapped_crypto_key,
+			   struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct scatterlist dst, src;
+	struct blkcipher_desc desc = {
+		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
+	};
+	char wrapping_key[EXT4_DEFAULT_WRAPPING_KEY_SIZE];
+	int res = 0;
+	desc.tfm = crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm))
+		return PTR_ERR(desc.tfm);
+	if (!desc.tfm)
+		return -ENOMEM;
+	crypto_blkcipher_set_flags(desc.tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	res = __get_wrapping_key(wrapping_key, sbi);
+	if (res)
+		goto out;
+	res = crypto_blkcipher_setkey(desc.tfm, wrapping_key,
+				      EXT4_DEFAULT_WRAPPING_KEY_SIZE);
+	memset(wrapping_key, 0, EXT4_DEFAULT_WRAPPING_KEY_SIZE);
+	if (res)
+		goto out;
+	sg_init_table(&dst, 1);
+	sg_init_table(&src, 1);
+	sg_set_buf(&dst, crypto_key, EXT4_NOAUTH_DATA_KEY_SIZE);
+	sg_set_buf(&src, wrapped_crypto_key, EXT4_NOAUTH_DATA_KEY_SIZE);
+	res = crypto_blkcipher_decrypt(&desc, &dst, &src,
+				       EXT4_NOAUTH_DATA_KEY_SIZE);
+out:
+	crypto_free_blkcipher(desc.tfm);
+	return res;
+}
+
+/**
+ * ext4_wrap_key() - Wraps the encryption key for the inode.
+ * @wrapped_crypto_key: The buffer into which this writes the wrapped key.
+ * @crypto_key:         The encryption key.
+ * @inode:              The inode for the encryption key.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+static int ext4_wrap_key(char *wrapped_crypto_key, char *crypto_key,
+			 struct inode *inode)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct scatterlist dst, src;
+	struct blkcipher_desc desc = {
+		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
+	};
+	char wrapping_key[EXT4_DEFAULT_WRAPPING_KEY_SIZE];
+	int res = 0;
+	desc.tfm = crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm))
+		return PTR_ERR(desc.tfm);
+	if (!desc.tfm)
+		return -ENOMEM;
+	crypto_blkcipher_set_flags(desc.tfm, CRYPTO_TFM_REQ_WEAK_KEY);
+	res = __get_wrapping_key(wrapping_key, sbi);
+	if (res)
+		goto out;
+	res = crypto_blkcipher_setkey(desc.tfm, wrapping_key,
+				      EXT4_DEFAULT_WRAPPING_KEY_SIZE);
+	memset(wrapping_key, 0, EXT4_DEFAULT_WRAPPING_KEY_SIZE);
+	if (res)
+		goto out;
+	sg_init_table(&dst, 1);
+	sg_init_table(&src, 1);
+	sg_set_buf(&dst, wrapped_crypto_key, EXT4_NOAUTH_DATA_KEY_SIZE);
+	sg_set_buf(&src, crypto_key, EXT4_NOAUTH_DATA_KEY_SIZE);
+	res = crypto_blkcipher_encrypt(&desc, &dst, &src,
+				       EXT4_NOAUTH_DATA_KEY_SIZE);
+out:
+	crypto_free_blkcipher(desc.tfm);
+	return res;
+}
+
+/**
+ * ext4_set_crypto_key() - Generates and sets the encryption key for the inode
+ * @inode:              The inode for the encryption key.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+int ext4_set_crypto_key(struct inode *inode)
+{
+	/* TODO(mhalcrow): Prerelease protector set. A real in-plan
+	 * one should be in what gets merged into mainline. */
+	char protector_set[EXT4_PRERELEASE_PROTECTOR_SET_SIZE];
+	char *wrapped_crypto_key =
+		&protector_set[EXT4_PROTECTOR_SET_VERSION_SIZE];
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int res = 0;
+
+	get_random_bytes(ei->i_crypto_key, EXT4_NOAUTH_DATA_KEY_SIZE);
+	res = ext4_wrap_key(wrapped_crypto_key, ei->i_crypto_key, inode);
+	if (res)
+		goto out;
+	ei->i_encrypt = true;
+	protector_set[0] = EXT4_PRERELEASE_PROTECTOR_SET_VERSION;
+	res = ext4_xattr_set(inode, EXT4_XATTR_INDEX_CRYPTO_PROTECTORS, "",
+			     protector_set, sizeof(protector_set), 0);
+out:
+	if (res)
+		printk_ratelimited(KERN_ERR "%s: res = [%d]\n", __func__, res);
+	return res;
+}
+
+/**
+ * ext4_get_crypto_key() - Gets the encryption key for the inode.
+ * @inode:              The inode for the encryption key.
+ *
+ * Return: Zero on success, non-zero otherwise.
+ */
+int ext4_get_crypto_key(struct inode *inode)
+{
+	/* TODO(mhalcrow): Prerelease protector set. A real in-plan
+	 * one should be in what gets merged into mainline. */
+	char protector_set[EXT4_PRERELEASE_PROTECTOR_SET_SIZE];
+	char *wrapped_crypto_key =
+		&protector_set[EXT4_PROTECTOR_SET_VERSION_SIZE];
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int res;
+
+	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_CRYPTO_PROTECTORS, "",
+			     NULL, 0);
+	if (res != sizeof(protector_set)) {
+		res = -ENODATA;
+		goto out;
+	}
+	res = ext4_xattr_get(inode, EXT4_XATTR_INDEX_CRYPTO_PROTECTORS, "",
+			     protector_set, res);
+	if (res != sizeof(protector_set)) {
+		res = -EINVAL;
+		goto out;
+	}
+	if (protector_set[0] != EXT4_PRERELEASE_PROTECTOR_SET_VERSION) {
+		printk_ratelimited(KERN_ERR "%s: Expected protector set "
+				   "version [%d]; got [%d]\n",
+				   __func__,
+				   EXT4_PRERELEASE_PROTECTOR_SET_VERSION,
+				   protector_set[0]);
+		res = -EINVAL;
+		goto out;
+	}
+	res = ext4_unwrap_key(ei->i_crypto_key, wrapped_crypto_key, inode);
+	if (!res)
+		ei->i_encrypt = true;
+out:
+	return res;
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 321760d..7508261 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -32,6 +32,7 @@
 #include <linux/ratelimit.h>
 #include <crypto/hash.h>
 #include <linux/falloc.h>
+#include <linux/ecryptfs.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -808,6 +809,19 @@ do {									       \
 
 #endif /* defined(__KERNEL__) || defined(__linux__) */
 
+/* Encryption parameters */
+#define EXT4_AES_256_ECB_KEY_SIZE 32
+#define EXT4_DEFAULT_WRAPPING_KEY_SIZE EXT4_AES_256_ECB_KEY_SIZE
+#define EXT4_AES_256_XTS_KEY_SIZE 64
+#define EXT4_XTS_TWEAK_SIZE 16
+#define EXT4_NOAUTH_DATA_KEY_SIZE EXT4_AES_256_XTS_KEY_SIZE
+/* TODO(mhalcrow): The key management code isn't what's in plan at the
+ * moment. */
+#define EXT4_PRERELEASE_PROTECTOR_SET_VERSION (char)0xFF
+#define EXT4_PROTECTOR_SET_VERSION_SIZE 1
+#define EXT4_PRERELEASE_PROTECTOR_SET_SIZE (EXT4_PROTECTOR_SET_VERSION_SIZE + \
+					    EXT4_NOAUTH_DATA_KEY_SIZE)
+
 #include "extents_status.h"
 
 /*
@@ -942,6 +956,10 @@ struct ext4_inode_info {
 
 	/* Precomputed uuid+inum+igen checksum for seeding inode checksums */
 	__u32 i_csum_seed;
+
+	/* Encryption params */
+	bool i_encrypt;
+	char i_crypto_key[EXT4_NOAUTH_DATA_KEY_SIZE];
 };
 
 /*
@@ -1339,6 +1357,10 @@ struct ext4_sb_info {
 	struct ratelimit_state s_err_ratelimit_state;
 	struct ratelimit_state s_warning_ratelimit_state;
 	struct ratelimit_state s_msg_ratelimit_state;
+
+	/* Encryption */
+	bool s_encrypt;
+	char s_crypto_key_sig[ECRYPTFS_SIG_SIZE_HEX + 1];
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -2787,6 +2809,33 @@ static inline void set_bitmap_uptodate(struct buffer_head *bh)
 	set_bit(BH_BITMAP_UPTODATE, &(bh)->b_state);
 }
 
+/* crypto.c */
+#define EXT4_CTX_REQUIRES_FREE_ENCRYPT_FL		0x00000001
+#define EXT4_BOUNCE_PAGE_REQUIRES_FREE_ENCRYPT_FL	0x00000002
+
+typedef struct ext4_crypto_ctx {
+	struct crypto_ablkcipher *tfm;	/* Crypto API context */
+	struct page *bounce_page;	/* Ciphertext page on write path */
+	struct page *control_page;	/* Original page on write path */
+	struct bio *bio;		/* The bio for this context */
+	struct work_struct work;	/* Work queue for read complete path */
+	struct list_head free_list;	/* Free list */
+	int flags;			/* Flags */
+} ext4_crypto_ctx_t;
+extern struct workqueue_struct *mpage_read_workqueue;
+int ext4_allocate_crypto(size_t num_crypto_pages, size_t num_crypto_ctxs);
+void ext4_delete_crypto(void);
+ext4_crypto_ctx_t *ext4_get_crypto_ctx(
+	bool with_page, u8 aes_256_xts_key[EXT4_AES_256_XTS_KEY_SIZE]);
+void ext4_release_crypto_ctx(ext4_crypto_ctx_t *ctx);
+void set_bh_to_page(struct buffer_head *head, struct page *page);
+struct page *ext4_encrypt(ext4_crypto_ctx_t *ctx, struct page* plaintext_page);
+int ext4_decrypt(ext4_crypto_ctx_t *ctx, struct page* page);
+int ext4_get_crypto_key(struct inode *inode);
+int ext4_set_crypto_key(struct inode *inode);
+extern atomic_t ext4_dbg_pages; /* TODO(mhalcrow): Remove for release */
+extern atomic_t ext4_dbg_ctxs; /* TODO(mhalcrow): Remove for release */
+
 /*
  * Disable DIO read nolock optimization, so new dioreaders will be forced
  * to grab i_mutex
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 32b43ad..e818e23 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -904,6 +904,8 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
+	ei->i_encrypt = false;
+	memset(ei->i_crypto_key, 0, EXT4_NOAUTH_DATA_KEY_SIZE);
 
 	return &ei->vfs_inode;
 }
@@ -1168,7 +1170,7 @@ enum {
 	Opt_inode_readahead_blks, Opt_journal_ioprio,
 	Opt_dioread_nolock, Opt_dioread_lock,
 	Opt_discard, Opt_nodiscard, Opt_init_itable, Opt_noinit_itable,
-	Opt_max_dir_size_kb,
+	Opt_max_dir_size_kb, Opt_encrypt_key_sig,
 };
 
 static const match_table_t tokens = {
@@ -1244,6 +1246,7 @@ static const match_table_t tokens = {
 	{Opt_init_itable, "init_itable"},
 	{Opt_noinit_itable, "noinit_itable"},
 	{Opt_max_dir_size_kb, "max_dir_size_kb=%u"},
+	{Opt_encrypt_key_sig, "encrypt_key_sig=%s"},
 	{Opt_removed, "check=none"},	/* mount option from ext2/3 */
 	{Opt_removed, "nocheck"},	/* mount option from ext2/3 */
 	{Opt_removed, "reservation"},	/* mount option from ext2/3 */
@@ -1442,6 +1445,7 @@ static const struct mount_opts {
 	{Opt_jqfmt_vfsv0, QFMT_VFS_V0, MOPT_QFMT},
 	{Opt_jqfmt_vfsv1, QFMT_VFS_V1, MOPT_QFMT},
 	{Opt_max_dir_size_kb, 0, MOPT_GTE0},
+	{Opt_encrypt_key_sig, 0, MOPT_STRING},
 	{Opt_err, 0, 0}
 };
 
@@ -1543,6 +1547,23 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 		sbi->s_li_wait_mult = arg;
 	} else if (token == Opt_max_dir_size_kb) {
 		sbi->s_max_dir_size_kb = arg;
+	} else if (token == Opt_encrypt_key_sig) {
+		char *encrypt_key_sig;
+		encrypt_key_sig = match_strdup(&args[0]);
+		if (!encrypt_key_sig) {
+			ext4_msg(sb, KERN_ERR, "error: could not dup "
+				 "encryption key sig string");
+			return -1;
+		}
+		if (strlen(encrypt_key_sig) != ECRYPTFS_SIG_SIZE_HEX) {
+			ext4_msg(sb, KERN_ERR, "error: encryption key sig "
+				 "string must be length %d",
+				 ECRYPTFS_SIG_SIZE_HEX);
+			return -1;
+		}
+		memcpy(sbi->s_crypto_key_sig, encrypt_key_sig,
+		       ECRYPTFS_SIG_SIZE_HEX);
+		sbi->s_encrypt = true;
 	} else if (token == Opt_stripe) {
 		sbi->s_stripe = arg;
 	} else if (token == Opt_resuid) {
@@ -5507,6 +5528,8 @@ struct mutex ext4__aio_mutex[EXT4_WQ_HASH_SZ];
 static int __init ext4_init_fs(void)
 {
 	int i, err;
+	static size_t num_prealloc_crypto_pages = 32;
+	static size_t num_prealloc_crypto_ctxs = 128;
 
 	ext4_li_info = NULL;
 	mutex_init(&ext4_li_mtx);
@@ -5519,10 +5542,15 @@ static int __init ext4_init_fs(void)
 		init_waitqueue_head(&ext4__ioend_wq[i]);
 	}
 
-	err = ext4_init_es();
+	err = ext4_allocate_crypto(num_prealloc_crypto_pages,
+				   num_prealloc_crypto_ctxs);
 	if (err)
 		return err;
 
+	err = ext4_init_es();
+	if (err)
+		goto out8;
+
 	err = ext4_init_pageio();
 	if (err)
 		goto out7;
@@ -5575,6 +5603,8 @@ out6:
 	ext4_exit_pageio();
 out7:
 	ext4_exit_es();
+out8:
+	ext4_delete_crypto();
 
 	return err;
 }
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 29bedf5..fcbe815 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -23,6 +23,7 @@
 #define EXT4_XATTR_INDEX_SECURITY	        6
 #define EXT4_XATTR_INDEX_SYSTEM			7
 #define EXT4_XATTR_INDEX_RICHACL		8
+#define EXT4_XATTR_INDEX_CRYPTO_PROTECTORS	9
 
 struct ext4_xattr_header {
 	__le32	h_magic;	/* magic number for identification */
-- 
2.0.0.526.g5318336

