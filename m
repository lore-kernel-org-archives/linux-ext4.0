From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 14/22] ext4 crypto: filename encryption facilities
Date: Thu,  2 Apr 2015 18:10:51 -0400
Message-ID: <1428012659-12709-15-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47974 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbbDBWMe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:34 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: Ia924500cc0395bc96b7099962041641eb336276b
Signed-off-by: Uday Savagaonkar <savagaon@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/Makefile       |   3 +-
 fs/ext4/crypto_fname.c | 831 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h         |  41 +++
 fs/ext4/ext4_crypto.h  |  20 ++
 4 files changed, 894 insertions(+), 1 deletion(-)
 create mode 100644 fs/ext4/crypto_fname.c

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 4e5af21..75285ea 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -12,4 +12,5 @@ ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o page-io.o \
 
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
-ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o crypto_key.o
+ext4-$(CONFIG_EXT4_FS_ENCRYPTION)	+= crypto_policy.o crypto.o \
+		crypto_key.o crypto_fname.o
diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
new file mode 100644
index 0000000..771aa8c
--- /dev/null
+++ b/fs/ext4/crypto_fname.c
@@ -0,0 +1,831 @@
+/*
+ * linux/fs/ext4/ext4_fname_crypto.c
+ *
+ * This contains functions for filename crypto management in ext4
+ *
+ * Written by Uday Savagaonkar, 2014.
+ *
+ * This has not yet undergone a rigorous security audit.
+ *
+ */
+
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+#include <keys/encrypted-type.h>
+#include <keys/user-type.h>
+#include <linux/crypto.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/key.h>
+#include <linux/key.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+#include <linux/spinlock_types.h>
+
+#include "ext4.h"
+#include "ext4_crypto.h"
+#include "xattr.h"
+
+/**
+ * copy_bufs_to_page() - copies cstr bufs into a page
+ * @pagebuf: Receives the concatenated contents of the @bufs array.
+ * @bufs:    An array of cstr buffers.
+ * @tlen:    Number of elements in the @bufs array.
+ */
+static void copy_bufs_to_page(char *pagebuf, const struct ext4_str *bufs,
+			      u32 tlen)
+{
+	u32 tcopied = 0, remaining = tlen, bytes_this_iter;
+	int i = 0;
+
+	while (remaining) {
+		bytes_this_iter = (remaining > bufs[i].len ?
+				   bufs[i].len : remaining);
+		memcpy(pagebuf + tcopied, bufs[i].name, bytes_this_iter);
+		tcopied += bytes_this_iter;
+		remaining -= bytes_this_iter;
+		++i;
+	}
+}
+
+struct ext4_dir_crypt_result {
+	struct completion completion;
+	int res;
+};
+
+/**
+ * ext4_dir_crypt_complete() -
+ */
+static void ext4_dir_crypt_complete(struct crypto_async_request *req, int res)
+{
+	struct ext4_dir_crypt_result *ecr = req->data;
+
+	if (res == -EINPROGRESS)
+		return;
+	ecr->res = res;
+	complete(&ecr->completion);
+}
+
+/**
+ * ext4_cbc_encrypt() -
+ */
+static int ext4_cbc_encrypt(struct ext4_fname_crypto_ctx *ctx,
+			    struct ext4_str *oname,
+			    const struct ext4_str *ibufs, u32 ilen)
+{
+	struct ablkcipher_request *req = NULL;
+	struct ext4_dir_crypt_result ecr;
+	struct scatterlist sg[1];
+	struct crypto_ablkcipher *tfm = ctx->ctfm;
+	int res = 0;
+	int ciphertext_len;
+	char iv[EXT4_CRYPTO_BLOCK_SIZE];
+	char *workbuf;
+
+	/* Allocate request */
+	req = ablkcipher_request_alloc(tfm, GFP_NOFS);
+	if (!req) {
+		printk_ratelimited(
+		    KERN_ERR "%s: crypto_request_alloc() failed\n", __func__);
+		return -ENOMEM;
+	}
+	ablkcipher_request_set_callback(req,
+		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_dir_crypt_complete, &ecr);
+
+	ciphertext_len = ext4_fname_crypto_round_up(ilen,
+			EXT4_CRYPTO_BLOCK_SIZE);
+	ciphertext_len = (ciphertext_len > ctx->lim)
+			? ctx->lim : ciphertext_len;
+
+	/* Map the workpage */
+	workbuf = kmap(ctx->workpage);
+
+	/* Copy the input */
+	copy_bufs_to_page(workbuf, ibufs, ilen);
+	if (ilen < ciphertext_len)
+		memset(workbuf+ilen, 0, ciphertext_len-ilen);
+
+	/* Initialize IV */
+	memset(iv, 0, EXT4_CRYPTO_BLOCK_SIZE);
+
+	/* Create encryption request */
+	sg_init_table(sg, 1);
+	sg_set_page(sg, ctx->workpage, PAGE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, sg, sg, ciphertext_len, iv);
+	res = crypto_ablkcipher_encrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		if (res)
+			goto out;
+	}
+	/* Copy the result to output */
+	memcpy(oname->name, workbuf, ciphertext_len);
+	oname->len = ciphertext_len;
+	res = ciphertext_len;
+
+out:
+	kunmap(ctx->workpage);
+	ablkcipher_request_free(req);
+	if (res < 0) {
+		printk_ratelimited(
+		    KERN_ERR "%s: Error (error code %d)\n", __func__, res);
+	}
+	return res;
+}
+
+/**
+ * ext4_cbc_decrypt() -
+ */
+static int ext4_cbc_decrypt(struct ext4_fname_crypto_ctx *ctx,
+			    struct ext4_str *oname,
+			    const struct ext4_str *ibufs, u32 ilen)
+{
+	struct ablkcipher_request *req = NULL;
+	struct ext4_dir_crypt_result ecr;
+	struct scatterlist sg[1];
+	struct crypto_ablkcipher *tfm = ctx->ctfm;
+	int res = 0;
+	char iv[EXT4_CRYPTO_BLOCK_SIZE];
+	char *workbuf;
+
+	if ((ilen&(EXT4_CRYPTO_BLOCK_SIZE-1)) != 0) {
+		printk_ratelimited(
+		    KERN_ERR "%s: ilen is not integer multiple of EXT4_CRYPTO_BLOCK_SIZE\n",
+		    __func__);
+		return -EIO;
+	}
+	/* Allocate request */
+	req = ablkcipher_request_alloc(tfm, GFP_NOFS);
+	if (!req) {
+		printk_ratelimited(
+		    KERN_ERR "%s: crypto_request_alloc() failed\n",  __func__);
+		return -ENOMEM;
+	}
+	ablkcipher_request_set_callback(req,
+		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_dir_crypt_complete, &ecr);
+
+	/* Map the workpage */
+	workbuf = kmap(ctx->workpage);
+
+	/* Copy the input */
+	copy_bufs_to_page(workbuf, ibufs, ilen);
+
+	/* Initialize IV */
+	memset(iv, 0, EXT4_CRYPTO_BLOCK_SIZE);
+
+	/* Create encryption request */
+	sg_init_table(sg, 1);
+	sg_set_page(sg, ctx->workpage, PAGE_SIZE, 0);
+	ablkcipher_request_set_crypt(req, sg, sg, ilen, iv);
+	res = crypto_ablkcipher_decrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		if (res)
+			goto out;
+	}
+	/* Copy the result to output */
+	memcpy(oname->name, workbuf, ilen);
+	oname->len = ilen;
+	res = ilen;
+
+out:
+	kunmap(ctx->workpage);
+	ablkcipher_request_free(req);
+	if (res < 0) {
+		printk_ratelimited(
+		    KERN_ERR "%s: Error in ext4_fname_encrypt (error code %d)\n",
+		    __func__, res);
+	}
+	return res;
+}
+
+/**
+ * ext4_fname_encrypt() -
+ *
+ * This function encrypts the input filename, and returns the length of the
+ * ciphertext. Errors are returned as negative numbers.  We trust the caller to
+ * allocate sufficient memory to oname string.
+ */
+static int ext4_fname_encrypt(struct ext4_fname_crypto_ctx *ctx,
+			      const struct qstr *iname,
+			      struct ext4_str *oname)
+{
+	struct ext4_str tmp_in[2], tmp_out[1];
+	u32 ciphertext_len, first_output_len, first_input_len,
+		num_reused_bytes, input_trailing_bytes, output_trailing_bytes;
+	int res;
+
+	if (iname->len <= 0 || iname->len > ctx->lim)
+		return -EIO;
+
+	ciphertext_len = ext4_fname_crypto_round_up(iname->len,
+		EXT4_CRYPTO_BLOCK_SIZE);
+	ciphertext_len = (ciphertext_len > ctx->lim)
+		? ctx->lim : ciphertext_len;
+
+	/* Figure out whether special handling in the last block is
+	 * needed because the output size is limited to non-integer multiple
+	 * of EXT4_CRYPTO_BLOCK_SIZE */
+	output_trailing_bytes = ciphertext_len & (EXT4_CRYPTO_BLOCK_SIZE-1);
+	first_output_len = ciphertext_len ^ output_trailing_bytes;
+	first_input_len = (first_output_len < iname->len)
+				? first_output_len : iname->len;
+	num_reused_bytes = EXT4_CRYPTO_BLOCK_SIZE - output_trailing_bytes;
+	input_trailing_bytes = iname->len - first_input_len;
+
+	tmp_in[0].name = (unsigned char *) iname->name;
+	tmp_in[0].len = first_input_len;
+	tmp_out[0].name = oname->name;
+
+	res = ext4_cbc_encrypt(ctx, tmp_out, tmp_in, first_input_len);
+	if (res < 0 || output_trailing_bytes == 0) {
+		oname->len = res;
+		return res;
+	}
+	BUG_ON(first_output_len != first_input_len);
+	BUG_ON(input_trailing_bytes <= 0 || output_trailing_bytes <= 0);
+	BUG_ON(input_trailing_bytes >= EXT4_CRYPTO_BLOCK_SIZE
+			|| output_trailing_bytes >= EXT4_CRYPTO_BLOCK_SIZE);
+
+	tmp_in[0].name = oname->name + first_output_len-num_reused_bytes;
+	tmp_in[0].len = num_reused_bytes;
+	tmp_in[1].name = (unsigned char *) iname->name + first_input_len;
+	tmp_in[1].len = input_trailing_bytes;
+	tmp_out[0].name = oname->name + first_output_len-num_reused_bytes;
+	res = ext4_cbc_encrypt(ctx, tmp_out, tmp_in,
+			       num_reused_bytes + input_trailing_bytes);
+	if (res < 0)
+		return res;
+
+	oname->len = ciphertext_len;
+	return ciphertext_len;
+}
+/*
+ * ext4_fname_decrypt()
+ *	This function decrypts the input filename, and returns
+ *	the length of the plaintext.
+ *	Errors are returned as negative numbers.
+ *	We trust the caller to allocate sufficient memory to oname string.
+ */
+static int ext4_fname_decrypt(struct ext4_fname_crypto_ctx *ctx,
+			      const struct ext4_str *iname,
+			      struct ext4_str *oname)
+{
+	struct ext4_str tmp_in[2], tmp_out[1];
+	char *tmp_blk = ctx->tmp_buf;
+	u32 input_trailing_bytes, second_input_len, num_reused_bytes;
+	int res;
+
+	if (iname->len <= 0 || iname->len > ctx->lim)
+		return -EIO;
+
+	input_trailing_bytes = iname->len & (EXT4_CRYPTO_BLOCK_SIZE-1);
+	num_reused_bytes = EXT4_CRYPTO_BLOCK_SIZE - input_trailing_bytes;
+	second_input_len = iname->len ^ input_trailing_bytes;
+	/* We allow odd inputs only if we are running into limit */
+	if (input_trailing_bytes != 0 && iname->len != ctx->lim)
+		return -EIO;
+
+	if (input_trailing_bytes != 0) {
+		/* Perform the last-block dance */
+		tmp_in[0].name =
+			iname->name+iname->len - EXT4_CRYPTO_BLOCK_SIZE;
+		tmp_in[0].len = EXT4_CRYPTO_BLOCK_SIZE;
+		tmp_out[0].name = tmp_blk;
+		res = ext4_cbc_decrypt(ctx, tmp_out, tmp_in,
+				       EXT4_CRYPTO_BLOCK_SIZE);
+		if (res < 0)
+			return res;
+		tmp_in[0].name = iname->name;
+		tmp_in[0].len = iname->len-EXT4_CRYPTO_BLOCK_SIZE;
+		tmp_in[1].name = tmp_blk;
+		tmp_in[1].len = num_reused_bytes;
+	} else {
+		tmp_in[0].name = iname->name;
+		tmp_in[0].len = iname->len;
+	}
+
+	tmp_out[0].name = oname->name;
+
+	res = ext4_cbc_decrypt(ctx, tmp_out, tmp_in, second_input_len);
+	if (res < 0)
+		return res;
+	if (input_trailing_bytes != 0) {
+		/* Copy the trailing bytes */
+		memcpy(oname->name+second_input_len, tmp_blk+num_reused_bytes,
+				input_trailing_bytes);
+	}
+	oname->len = strnlen(oname->name, iname->len);
+	return oname->len;
+}
+
+/**
+ * ext4_fname_encode_digest() -
+ *
+ * Encodes the input digest using characters from the set [a-zA-Z0-9_+].
+ * The encoded string is roughly 4/3 times the size of the input string.
+ */
+int ext4_fname_encode_digest(char *dst, char *src, u32 len)
+{
+	static const char *lookup_table =
+		"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_+";
+	u32 current_chunk, num_chunks, i;
+	char tmp_buf[3];
+	u32 c0, c1, c2, c3;
+
+	current_chunk = 0;
+	num_chunks = len/3;
+	for (i = 0; i < num_chunks; i++) {
+		c0 = src[3*i] & 0x3f;
+		c1 = (((src[3*i]>>6)&0x3) | ((src[3*i+1] & 0xf)<<2)) & 0x3f;
+		c2 = (((src[3*i+1]>>4)&0xf) | ((src[3*i+2] & 0x3)<<4)) & 0x3f;
+		c3 = (src[3*i+2]>>2) & 0x3f;
+		dst[4*i] = lookup_table[c0];
+		dst[4*i+1] = lookup_table[c1];
+		dst[4*i+2] = lookup_table[c2];
+		dst[4*i+3] = lookup_table[c3];
+	}
+	if (i*3 < len) {
+		memset(tmp_buf, 0, 3);
+		memcpy(tmp_buf, &src[3*i], len-3*i);
+		c0 = tmp_buf[0] & 0x3f;
+		c1 = (((tmp_buf[0]>>6)&0x3) | ((tmp_buf[1] & 0xf)<<2)) & 0x3f;
+		c2 = (((tmp_buf[1]>>4)&0xf) | ((tmp_buf[2] & 0x3)<<4)) & 0x3f;
+		c3 = (tmp_buf[2]>>2) & 0x3f;
+		dst[4*i] = lookup_table[c0];
+		dst[4*i+1] = lookup_table[c1];
+		dst[4*i+2] = lookup_table[c2];
+		dst[4*i+3] = lookup_table[c3];
+	}
+	return 4*(i+1);
+}
+
+/**
+ * ext4_fname_hash() -
+ *
+ * This function computes the hash of the input filename, and sets the output
+ * buffer to the *encoded* digest.  It returns the length of the digest as its
+ * return value.  Errors are returned as negative numbers.  We trust the caller
+ * to allocate sufficient memory to oname string.
+ */
+static int ext4_fname_hash(struct ext4_fname_crypto_ctx *ctx,
+			   const struct ext4_str *iname,
+			   struct ext4_str *oname)
+{
+	struct scatterlist sg;
+	struct hash_desc desc = {
+		.tfm = (struct crypto_hash *)ctx->htfm,
+		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
+	};
+	int res = 0;
+
+	if (iname->len <= EXT4_FNAME_CRYPTO_DIGEST_SIZE) {
+		res = ext4_fname_encode_digest(oname->name, iname->name,
+					       iname->len);
+		oname->len = res;
+		return res;
+	}
+
+	sg_init_one(&sg, iname->name, iname->len);
+	res = crypto_hash_init(&desc);
+	if (res) {
+		printk(KERN_ERR
+		       "%s: Error initializing crypto hash; res = [%d]\n",
+		       __func__, res);
+		goto out;
+	}
+	res = crypto_hash_update(&desc, &sg, iname->len);
+	if (res) {
+		printk(KERN_ERR
+		       "%s: Error updating crypto hash; res = [%d]\n",
+		       __func__, res);
+		goto out;
+	}
+	res = crypto_hash_final(&desc,
+		&oname->name[EXT4_FNAME_CRYPTO_DIGEST_SIZE]);
+	if (res) {
+		printk(KERN_ERR
+		       "%s: Error finalizing crypto hash; res = [%d]\n",
+		       __func__, res);
+		goto out;
+	}
+	/* Encode the digest as a printable string--this will increase the
+	 * size of the digest */
+	oname->name[0] = 'I';
+	res = ext4_fname_encode_digest(oname->name+1,
+		&oname->name[EXT4_FNAME_CRYPTO_DIGEST_SIZE],
+		EXT4_FNAME_CRYPTO_DIGEST_SIZE) + 1;
+	oname->len = res;
+out:
+	return res;
+}
+
+/**
+ * ext4_free_fname_crypto_ctx() -
+ *
+ * Frees up a crypto context.
+ */
+void ext4_free_fname_crypto_ctx(struct ext4_fname_crypto_ctx *ctx)
+{
+	if (ctx == NULL || IS_ERR(ctx))
+		return;
+
+	if (ctx->ctfm && !IS_ERR(ctx->ctfm))
+		crypto_free_ablkcipher(ctx->ctfm);
+	if (ctx->htfm && !IS_ERR(ctx->htfm))
+		crypto_free_hash(ctx->htfm);
+	if (ctx->workpage && !IS_ERR(ctx->workpage))
+		__free_page(ctx->workpage);
+	kfree(ctx);
+}
+
+/**
+ * ext4_put_fname_crypto_ctx() -
+ *
+ * Return: The crypto context onto free list. If the free list is above a
+ * threshold, completely frees up the context, and returns the memory.
+ *
+ * TODO: Currently we directly free the crypto context. Eventually we should
+ * add code it to return to free list. Such an approach will increase
+ * efficiency of directory lookup.
+ */
+void ext4_put_fname_crypto_ctx(struct ext4_fname_crypto_ctx **ctx)
+{
+	if (*ctx == NULL || IS_ERR(*ctx))
+		return;
+	ext4_free_fname_crypto_ctx(*ctx);
+	*ctx = NULL;
+}
+
+/**
+ * ext4_search_fname_crypto_ctx() -
+ */
+static struct ext4_fname_crypto_ctx *ext4_search_fname_crypto_ctx(
+		const struct ext4_encryption_key *key)
+{
+	return NULL;
+}
+
+/**
+ * ext4_alloc_fname_crypto_ctx() -
+ */
+struct ext4_fname_crypto_ctx *ext4_alloc_fname_crypto_ctx(
+	const struct ext4_encryption_key *key)
+{
+	struct ext4_fname_crypto_ctx *ctx;
+
+	ctx = kmalloc(sizeof(struct ext4_fname_crypto_ctx), GFP_NOFS);
+	if (ctx == NULL)
+		return ERR_PTR(-ENOMEM);
+	if (key->mode == EXT4_ENCRYPTION_MODE_INVALID) {
+		/* This will automatically set key mode to invalid
+		 * As enum for ENCRYPTION_MODE_INVALID is zero */
+		memset(&ctx->key, 0, sizeof(ctx->key));
+	} else {
+		memcpy(&ctx->key, key, sizeof(struct ext4_encryption_key));
+	}
+	ctx->has_valid_key = (EXT4_ENCRYPTION_MODE_INVALID == key->mode)
+		? 0 : 1;
+	ctx->ctfm_key_is_ready = 0;
+	ctx->ctfm = NULL;
+	ctx->htfm = NULL;
+	ctx->workpage = NULL;
+	return ctx;
+}
+
+/**
+ * ext4_get_fname_crypto_ctx() -
+ *
+ * Allocates a free crypto context and initializes it to hold
+ * the crypto material for the inode.
+ *
+ * Return: NULL if not encrypted. Error value on error. Valid pointer otherwise.
+ */
+struct ext4_fname_crypto_ctx *ext4_get_fname_crypto_ctx(
+	struct inode *inode, u32 max_ciphertext_len)
+{
+	struct ext4_fname_crypto_ctx *ctx;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int res;
+
+	/* Check if the crypto policy is set on the inode */
+	res = ext4_encrypted_inode(inode);
+	if (res == 0)
+		return NULL;
+
+	if (!ext4_has_encryption_key(inode))
+		ext4_generate_encryption_key(inode);
+
+	/* Get a crypto context based on the key.
+	 * A new context is allocated if no context matches the requested key.
+	 */
+	ctx = ext4_search_fname_crypto_ctx(&(ei->i_encryption_key));
+	if (ctx == NULL)
+		ctx = ext4_alloc_fname_crypto_ctx(&(ei->i_encryption_key));
+	if (IS_ERR(ctx))
+		return ctx;
+
+	if (ctx->has_valid_key) {
+		/* As a first cut, we will allocate new tfm in every call.
+		 * later, we will keep the tfm around, in case the key gets
+		 * re-used */
+		if (ctx->ctfm == NULL) {
+			ctx->ctfm = crypto_alloc_ablkcipher("cbc(aes)",
+					0, 0);
+		}
+		if (IS_ERR(ctx->ctfm)) {
+			res = PTR_ERR(ctx->ctfm);
+			printk(
+			    KERN_DEBUG "%s: error (%d) allocating crypto tfm\n",
+			    __func__, res);
+			ctx->ctfm = NULL;
+			ext4_put_fname_crypto_ctx(&ctx);
+			return ERR_PTR(res);
+		}
+		if (ctx->ctfm == NULL) {
+			printk(
+			    KERN_DEBUG "%s: could not allocate crypto tfm\n",
+			    __func__);
+			ext4_put_fname_crypto_ctx(&ctx);
+			return ERR_PTR(-ENOMEM);
+		}
+		if (ctx->workpage == NULL)
+			ctx->workpage = alloc_page(GFP_NOFS);
+		if (IS_ERR(ctx->workpage)) {
+			res = PTR_ERR(ctx->workpage);
+			printk(
+			    KERN_DEBUG "%s: error (%d) allocating work page\n",
+			    __func__, res);
+			ctx->workpage = NULL;
+			ext4_put_fname_crypto_ctx(&ctx);
+			return ERR_PTR(res);
+		}
+		if (ctx->workpage == NULL) {
+			printk(
+			    KERN_DEBUG "%s: could not allocate work page\n",
+			    __func__);
+			ext4_put_fname_crypto_ctx(&ctx);
+			return ERR_PTR(-ENOMEM);
+		}
+		ctx->lim = max_ciphertext_len;
+		BUG_ON(ctx->key.mode != EXT4_ENCRYPTION_MODE_AES_256_CBC);
+		crypto_ablkcipher_clear_flags(ctx->ctfm, ~0);
+		crypto_tfm_set_flags(crypto_ablkcipher_tfm(ctx->ctfm),
+			CRYPTO_TFM_REQ_WEAK_KEY);
+
+		/* If we are lucky, we will get a context that is already
+		 * set up with the right key. Else, we will have to
+		 * set the key */
+		if (!ctx->ctfm_key_is_ready) {
+			/* Since our crypto objectives for filename encryption
+			 * are pretty weak,
+			 * we directly use the inode master key */
+			res = crypto_ablkcipher_setkey(ctx->ctfm,
+					ctx->key.raw, ctx->key.size);
+			if (res) {
+				ext4_put_fname_crypto_ctx(&ctx);
+				return ERR_PTR(-EIO);
+			}
+			ctx->ctfm_key_is_ready = 1;
+		} else {
+			/* In the current implementation, key should never be
+			 * marked "ready" for a context that has just been
+			 * allocated. So we should never reach here */
+			 BUG();
+		}
+	}
+	if (ctx->htfm == NULL)
+		ctx->htfm = crypto_alloc_hash("sha256", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(ctx->htfm)) {
+		res = PTR_ERR(ctx->htfm);
+		printk(KERN_DEBUG "%s: error (%d) allocating hash tfm\n",
+			__func__, res);
+		ctx->htfm = NULL;
+		ext4_put_fname_crypto_ctx(&ctx);
+		return ERR_PTR(res);
+	}
+	if (ctx->htfm == NULL) {
+		printk(KERN_DEBUG "%s: could not allocate hash tfm\n",
+				__func__);
+		ext4_put_fname_crypto_ctx(&ctx);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return ctx;
+}
+
+/**
+ * ext4_fname_crypto_round_up() -
+ *
+ * Return: The next multiple of block size
+ */
+u32 ext4_fname_crypto_round_up(u32 size, u32 blksize)
+{
+	return ((size+blksize-1)/blksize)*blksize;
+}
+
+/**
+ * ext4_fname_crypto_namelen_on_disk() -
+ */
+int ext4_fname_crypto_namelen_on_disk(struct ext4_fname_crypto_ctx *ctx,
+				      u32 namelen)
+{
+	u32 ciphertext_len;
+
+	if (ctx == NULL)
+		return -EIO;
+	if (!(ctx->has_valid_key))
+		return -EACCES;
+	ciphertext_len = ext4_fname_crypto_round_up(namelen,
+						    EXT4_CRYPTO_BLOCK_SIZE);
+	ciphertext_len = (ciphertext_len > ctx->lim)
+		? ctx->lim : ciphertext_len;
+	return (int) ciphertext_len;
+}
+
+/**
+ * ext4_fname_crypto_alloc_obuff() -
+ *
+ * Allocates an output buffer that is sufficient for the crypto operation
+ * specified by the context and the direction.
+ */
+int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
+				   unsigned char **obuf, u32 *olen, u32 ilen)
+{
+	if (!ctx)
+		return -EIO;
+	*olen = ext4_fname_crypto_round_up(ilen, EXT4_CRYPTO_BLOCK_SIZE);
+	if (*olen < EXT4_FNAME_CRYPTO_DIGEST_SIZE*2)
+		*olen = EXT4_FNAME_CRYPTO_DIGEST_SIZE*2;
+	/* Allocated buffer can hold one more character to null-terminate the
+	 * string */
+	*obuf = kmalloc(*olen, GFP_NOFS);
+	if (!(*obuf))
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * ext4_fname_crypto_free_buffer() -
+ *
+ * Frees the buffer allocated for crypto operation.
+ * NOTE: This function is called from a loop defined in
+ * ext4_fname_crypto_free_buffer() macro.
+ */
+void ext4_fname_crypto_free_buffer(void **buf)
+{
+	if (*buf == NULL || IS_ERR(buf))
+		return;
+	kfree(*buf);
+	*buf = NULL;
+}
+
+/**
+ * ext4_fname_disk_to_usr() - converts a filename from disk space to user space
+ */
+int _ext4_fname_disk_to_usr(struct ext4_fname_crypto_ctx *ctx,
+			   const struct ext4_str *iname,
+			   struct ext4_str *oname)
+{
+	if (ctx == NULL)
+		return -EIO;
+	if (iname->len < 3) {
+		/*Check for . and .. */
+		if (iname->name[0] == '.' && iname->name[iname->len-1] == '.') {
+			oname->name[0] = '.';
+			oname->name[iname->len-1] = '.';
+			oname->len = iname->len;
+			return oname->len;
+		}
+	}
+	if (ctx->has_valid_key)
+		return ext4_fname_decrypt(ctx, iname, oname);
+	else
+		return ext4_fname_hash(ctx, iname, oname);
+}
+
+int ext4_fname_disk_to_usr(struct ext4_fname_crypto_ctx *ctx,
+			   const struct ext4_dir_entry_2 * de,
+			   struct ext4_str *oname)
+{
+	struct ext4_str iname = {.name = (unsigned char *) de->name,
+				 .len = de->name_len };
+
+	return _ext4_fname_disk_to_usr(ctx, &iname, oname);
+}
+
+
+/**
+ * ext4_fname_usr_to_disk() - converts a filename from user space to disk space
+ */
+int ext4_fname_usr_to_disk(struct ext4_fname_crypto_ctx *ctx,
+			   const struct qstr *iname,
+			   struct ext4_str *oname)
+{
+	int res;
+
+	if (ctx == NULL)
+		return -EIO;
+	if (iname->len < 3) {
+		/*Check for . and .. */
+		if (iname->name[0] == '.' &&
+				iname->name[iname->len-1] == '.') {
+			oname->name[0] = '.';
+			oname->name[iname->len-1] = '.';
+			oname->len = iname->len;
+			return oname->len;
+		}
+	}
+	if (ctx->has_valid_key) {
+		res = ext4_fname_encrypt(ctx, iname, oname);
+		return res;
+	}
+	/* Without a proper key, a user is not allowed to modify the filenames
+	 * in a directory. Consequently, a user space name cannot be mapped to
+	 * a disk-space name */
+	return -EACCES;
+}
+
+/*
+ * Calculate the htree hash from a filename from user space
+ */
+int ext4_fname_usr_to_hash(struct ext4_fname_crypto_ctx *ctx,
+			    const struct qstr *iname,
+			    struct dx_hash_info *hinfo)
+{
+	struct ext4_str tmp, tmp2;
+	int ret = 0;
+
+	if (!ctx || !ctx->has_valid_key ||
+	    ((iname->name[0] == '.') &&
+	     ((iname->len == 1) ||
+	      ((iname->name[1] == '.') && (iname->len == 2))))) {
+		ext4fs_dirhash(iname->name, iname->len, hinfo);
+		return 0;
+	}
+
+	/* First encrypt the plaintext name */
+	ret = ext4_fname_crypto_alloc_buffer(ctx, &tmp.name,
+					     &tmp.len, iname->len);
+	if (ret < 0)
+		return ret;
+
+	ret = ext4_fname_encrypt(ctx, iname, &tmp);
+	if (ret < 0)
+		goto out;
+
+	tmp2.len = (4 * ((EXT4_FNAME_CRYPTO_DIGEST_SIZE + 2) / 3)) + 1;
+	tmp2.name = kmalloc(tmp2.len + 1, GFP_KERNEL);
+	if (tmp2.name == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = ext4_fname_hash(ctx, &tmp, &tmp2);
+	if (ret > 0)
+		ext4fs_dirhash(tmp2.name, tmp2.len, hinfo);
+	ext4_fname_crypto_free_buffer((void **)&tmp2.name);
+out:
+	ext4_fname_crypto_free_buffer((void **)&tmp.name);
+	return ret;
+}
+
+/**
+ * ext4_fname_disk_to_htree() - converts a filename from disk space to htree-access string
+ */
+int ext4_fname_disk_to_hash(struct ext4_fname_crypto_ctx *ctx,
+			    const struct ext4_dir_entry_2 * de,
+			    struct dx_hash_info *hinfo)
+{
+	struct ext4_str iname = {.name = (unsigned char *) de->name,
+				 .len = de->name_len};
+	struct ext4_str tmp;
+	int ret;
+
+	if (!ctx || !ctx->has_valid_key ||
+	    ((iname.name[0] == '.') &&
+	     ((iname.len == 1) ||
+	      ((iname.name[1] == '.') && (iname.len == 2))))) {
+		ext4fs_dirhash(iname.name, iname.len, hinfo);
+		return 0;
+	}
+
+	tmp.len = (4 * ((EXT4_FNAME_CRYPTO_DIGEST_SIZE + 2) / 3)) + 1;
+	tmp.name = kmalloc(tmp.len + 1, GFP_KERNEL);
+	if (tmp.name == NULL)
+		return -ENOMEM;
+
+	ret = ext4_fname_hash(ctx, &iname, &tmp);
+	if (ret > 0)
+		ext4fs_dirhash(tmp.name, tmp.len, hinfo);
+	ext4_fname_crypto_free_buffer((void **)&tmp.name);
+	return ret;
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ecb7be83..fe1a807 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2049,6 +2049,47 @@ static inline int ext4_sb_has_crypto(struct super_block *sb)
 }
 #endif
 
+/* crypto_fname.c */
+u32 ext4_fname_crypto_round_up(u32 size, u32 blksize);
+int ext4_fname_crypto_alloc_buffer(struct ext4_fname_crypto_ctx *ctx,
+				   unsigned char **obuf,
+				   u32 *olen, u32 ilen);
+int _ext4_fname_disk_to_usr(struct ext4_fname_crypto_ctx *ctx,
+			    const struct ext4_str *iname,
+			    struct ext4_str *oname);
+int ext4_fname_disk_to_usr(struct ext4_fname_crypto_ctx *ctx,
+			   const struct ext4_dir_entry_2 * de,
+			   struct ext4_str *oname);
+int ext4_fname_usr_to_disk(struct ext4_fname_crypto_ctx *ctx,
+			   const struct qstr *iname,
+			   struct ext4_str *oname);
+int ext4_fname_usr_to_hash(struct ext4_fname_crypto_ctx *ctx,
+			   const struct qstr *iname,
+			   struct dx_hash_info *hinfo);
+int ext4_fname_disk_to_hash(struct ext4_fname_crypto_ctx *ctx,
+			    const struct ext4_dir_entry_2 * de,
+			    struct dx_hash_info *hinfo);
+int ext4_fname_crypto_namelen_on_disk(struct ext4_fname_crypto_ctx *ctx,
+				      u32 namelen);
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+void ext4_put_fname_crypto_ctx(struct ext4_fname_crypto_ctx **ctx);
+struct ext4_fname_crypto_ctx *ext4_get_fname_crypto_ctx(struct inode *inode,
+							u32 max_len);
+void ext4_fname_crypto_free_buffer(void **buf);
+#else
+static inline
+void ext4_put_fname_crypto_ctx(struct ext4_fname_crypto_ctx **ctx) { }
+static inline
+struct ext4_fname_crypto_ctx *ext4_get_fname_crypto_ctx(struct inode *inode,
+							u32 max_len)
+{
+	return NULL;
+}
+static inline void ext4_fname_crypto_free_buffer(void **buf) { }
+#endif
+
+
 /* crypto_key.c */
 int ext4_generate_encryption_key(struct inode *inode);
 
diff --git a/fs/ext4/ext4_crypto.h b/fs/ext4/ext4_crypto.h
index 3bff49c..68e95d8 100644
--- a/fs/ext4/ext4_crypto.h
+++ b/fs/ext4/ext4_crypto.h
@@ -97,4 +97,24 @@ static inline int ext4_encryption_key_size(int mode)
 	return 0;
 }
 
+#define EXT4_FNAME_NUM_SCATTER_ENTRIES	4
+#define EXT4_CRYPTO_BLOCK_SIZE		16
+#define EXT4_FNAME_CRYPTO_DIGEST_SIZE	32
+
+struct ext4_str {
+	unsigned char *name;
+	u32 len;
+};
+
+struct ext4_fname_crypto_ctx {
+	u32 lim;
+	char tmp_buf[EXT4_CRYPTO_BLOCK_SIZE];
+	struct crypto_ablkcipher *ctfm;
+	struct crypto_hash *htfm;
+	struct page *workpage;
+	struct ext4_encryption_key key;
+	unsigned has_valid_key : 1;
+	unsigned ctfm_key_is_ready : 1;
+};
+
 #endif	/* _EXT4_CRYPTO_H */
-- 
2.3.0

