From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] crypto: allow to assign gfp_t for __crypto_alloc_tfm
Date: Mon, 18 May 2015 22:46:56 -0700
Message-ID: <1432014416-39326-1-git-send-email-jaegeuk@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, ecryptfs@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Return-path: <ecryptfs-owner@vger.kernel.org>
Sender: ecryptfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a parameter, gfp_t, for __crypto_alloc_tfm.
Now EXT4 and F2FS use the crypto engine to encrypt a page when writing it to the
disk.
That happens during ->writepage and it needs to allocate memory with
GFP_NOFS.

Otherwise, in the f2fs case, kernel reports such the following warning.

RECLAIM_FS-ON-R at:
  [<ffffffff810e44da>] mark_held_locks+0x6a/0x90
  [<ffffffff810e516f>] lockdep_trace_alloc+0xcf/0x120
  [<ffffffff8121c573>] __kmalloc+0x53/0x3d0
  [<ffffffff81356df5>] __crypto_alloc_tfm+0x45/0x170
  [<ffffffff8135aff0>] crypto_alloc_ablkcipher+0x60/0xb0
  [<ffffffffa03e5548>] f2fs_get_crypto_ctx+0x118/0x220 [f2fs]
  [<ffffffffa03e589a>] f2fs_encrypt+0x2a/0x160 [f2fs]
  [<ffffffffa03d3eac>] do_write_data_page+0x21c/0x6f0 [f2fs]
  [<ffffffffa03d480b>] f2fs_write_data_page+0x48b/0x5c0 [f2fs]
  [<ffffffffa03cd79a>] __f2fs_writepage+0x1a/0x50 [f2fs]
  [<ffffffff811c7e44>] write_cache_pages+0x274/0x6f0
  [<ffffffffa03cf1ba>] f2fs_write_data_pages+0xea/0x3b0 [f2fs]
  [<ffffffff811c9b61>] do_writepages+0x21/0x50
  [<ffffffff812710e6>] __writeback_single_inode+0x76/0xbf0
  [<ffffffff81271f8a>] writeback_sb_inodes+0x32a/0x720
  [<ffffffff81272571>] wb_writeback+0x121/0x850
  [<ffffffff81273398>] bdi_writeback_workfn+0x148/0x980
  [<ffffffff810a74a2>] process_one_work+0x1e2/0x840
  [<ffffffff810a7c21>] worker_thread+0x121/0x470
  [<ffffffff810ae268>] kthread+0xf8/0x110
  [<ffffffff8180b9a2>] ret_from_fork+0x42/0x70

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 arch/x86/crypto/aesni-intel_glue.c      | 2 +-
 crypto/ablkcipher.c                     | 4 ++--
 crypto/aead.c                           | 2 +-
 crypto/algapi.c                         | 2 +-
 crypto/algif_skcipher.c                 | 2 +-
 crypto/api.c                            | 6 +++---
 crypto/internal.h                       | 2 +-
 crypto/tcrypt.c                         | 2 +-
 crypto/testmgr.c                        | 3 ++-
 drivers/crypto/ccp/ccp-crypto-aes-xts.c | 3 ++-
 drivers/crypto/mxs-dcp.c                | 2 +-
 drivers/crypto/picoxcell_crypto.c       | 3 ++-
 drivers/crypto/qce/ablkcipher.c         | 3 ++-
 drivers/crypto/sahara.c                 | 3 ++-
 drivers/md/dm-crypt.c                   | 3 ++-
 fs/ecryptfs/crypto.c                    | 3 ++-
 fs/ext4/crypto.c                        | 3 ++-
 fs/ext4/crypto_fname.c                  | 2 +-
 fs/f2fs/crypto.c                        | 3 ++-
 fs/f2fs/crypto_fname.c                  | 2 +-
 fs/f2fs/crypto_key.c                    | 2 +-
 include/linux/crypto.h                  | 2 +-
 22 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 112cefa..5a7fe76 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -841,7 +841,7 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 	int ret = -EINVAL;
 	struct aesni_hash_subkey_req_data *req_data;
 
-	ctr_tfm = crypto_alloc_ablkcipher("ctr(aes)", 0, 0);
+	ctr_tfm = crypto_alloc_ablkcipher("ctr(aes)", 0, 0, GFP_KERNEL);
 	if (IS_ERR(ctr_tfm))
 		return PTR_ERR(ctr_tfm);
 
diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index db201bca..3706e4a 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -671,7 +671,7 @@ int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn, const char *name,
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 
 struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask)
+						  u32 type, u32 mask, gfp_t gfp)
 {
 	struct crypto_tfm *tfm;
 	int err;
@@ -688,7 +688,7 @@ struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm(alg, type, mask, gfp);
 		if (!IS_ERR(tfm))
 			return __crypto_ablkcipher_cast(tfm);
 
diff --git a/crypto/aead.c b/crypto/aead.c
index 2222710..b220a0dd 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -542,7 +542,7 @@ struct crypto_aead *crypto_alloc_aead(const char *alg_name, u32 type, u32 mask)
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm(alg, type, mask, GFP_KERNEL);
 		if (!IS_ERR(tfm))
 			return __crypto_aead_cast(tfm);
 
diff --git a/crypto/algapi.c b/crypto/algapi.c
index d2627a3..1a00274 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -660,7 +660,7 @@ struct crypto_tfm *crypto_spawn_tfm(struct crypto_spawn *spawn, u32 type,
 	if (unlikely((alg->cra_flags ^ type) & mask))
 		goto out_put_alg;
 
-	tfm = __crypto_alloc_tfm(alg, type, mask);
+	tfm = __crypto_alloc_tfm(alg, type, mask, GFP_KERNEL);
 	if (IS_ERR(tfm))
 		goto out_put_alg;
 
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 9450752..89730a7 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -751,7 +751,7 @@ static struct proto_ops algif_skcipher_ops = {
 
 static void *skcipher_bind(const char *name, u32 type, u32 mask)
 {
-	return crypto_alloc_ablkcipher(name, type, mask);
+	return crypto_alloc_ablkcipher(name, type, mask, GFP_KERNEL);
 }
 
 static void skcipher_release(void *private)
diff --git a/crypto/api.c b/crypto/api.c
index afe4610..887346b 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -364,14 +364,14 @@ void crypto_shoot_alg(struct crypto_alg *alg)
 EXPORT_SYMBOL_GPL(crypto_shoot_alg);
 
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask)
+				      u32 mask, gfp_t gfp)
 {
 	struct crypto_tfm *tfm = NULL;
 	unsigned int tfm_size;
 	int err = -ENOMEM;
 
 	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
-	tfm = kzalloc(tfm_size, GFP_KERNEL);
+	tfm = kzalloc(tfm_size, gfp);
 	if (tfm == NULL)
 		goto out_err;
 
@@ -435,7 +435,7 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 			goto err;
 		}
 
-		tfm = __crypto_alloc_tfm(alg, type, mask);
+		tfm = __crypto_alloc_tfm(alg, type, mask, GFP_KERNEL);
 		if (!IS_ERR(tfm))
 			return tfm;
 
diff --git a/crypto/internal.h b/crypto/internal.h
index bd39bfc..bd88be7 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -90,7 +90,7 @@ void crypto_remove_spawns(struct crypto_alg *alg, struct list_head *list,
 void crypto_remove_final(struct list_head *list);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
-				      u32 mask);
+				      u32 mask, gfp_t);
 void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend);
 struct crypto_alg *crypto_find_alg(const char *alg_name,
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1a28001..e6986e6 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1097,7 +1097,7 @@ static void test_acipher_speed(const char *algo, int enc, unsigned int secs,
 
 	init_completion(&tresult.completion);
 
-	tfm = crypto_alloc_ablkcipher(algo, 0, 0);
+	tfm = crypto_alloc_ablkcipher(algo, 0, 0, GFP_KERNEL);
 
 	if (IS_ERR(tfm)) {
 		pr_err("failed to load transform for %s: %ld\n", algo,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f9bce3d..076369f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1563,7 +1563,8 @@ static int alg_test_skcipher(const struct alg_test_desc *desc,
 	struct crypto_ablkcipher *tfm;
 	int err = 0;
 
-	tfm = crypto_alloc_ablkcipher(driver, type | CRYPTO_ALG_INTERNAL, mask);
+	tfm = crypto_alloc_ablkcipher(driver, type | CRYPTO_ALG_INTERNAL, mask,
+								GFP_KERNEL);
 	if (IS_ERR(tfm)) {
 		printk(KERN_ERR "alg: skcipher: Failed to load transform for "
 		       "%s: %ld\n", driver, PTR_ERR(tfm));
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 52c7395..54753ee 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -192,7 +192,8 @@ static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 
 	fallback_tfm = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm), 0,
 					       CRYPTO_ALG_ASYNC |
-					       CRYPTO_ALG_NEED_FALLBACK);
+					       CRYPTO_ALG_NEED_FALLBACK,
+					       GFP_KERNEL);
 	if (IS_ERR(fallback_tfm)) {
 		pr_warn("could not load fallback driver %s\n",
 			crypto_tfm_alg_name(tfm));
diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 59ed54e..4cac3a2 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -486,7 +486,7 @@ static int mxs_dcp_aes_fallback_init(struct crypto_tfm *tfm)
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
 	struct crypto_ablkcipher *blk;
 
-	blk = crypto_alloc_ablkcipher(name, 0, flags);
+	blk = crypto_alloc_ablkcipher(name, 0, flags, GFP_KERNEL);
 	if (IS_ERR(blk))
 		return PTR_ERR(blk);
 
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 5da5b98..148458e 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1085,7 +1085,8 @@ static int spacc_ablk_cra_init(struct crypto_tfm *tfm)
 	ctx->generic.engine = engine;
 	if (alg->cra_flags & CRYPTO_ALG_NEED_FALLBACK) {
 		ctx->sw_cipher = crypto_alloc_ablkcipher(alg->cra_name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				GFP_KERNEL);
 		if (IS_ERR(ctx->sw_cipher)) {
 			dev_warn(engine->dev, "failed to allocate fallback for %s\n",
 				 alg->cra_name);
diff --git a/drivers/crypto/qce/ablkcipher.c b/drivers/crypto/qce/ablkcipher.c
index ad592de..e1742d8 100644
--- a/drivers/crypto/qce/ablkcipher.c
+++ b/drivers/crypto/qce/ablkcipher.c
@@ -244,7 +244,8 @@ static int qce_ablkcipher_init(struct crypto_tfm *tfm)
 	ctx->fallback = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm),
 						CRYPTO_ALG_TYPE_ABLKCIPHER,
 						CRYPTO_ALG_ASYNC |
-						CRYPTO_ALG_NEED_FALLBACK);
+						CRYPTO_ALG_NEED_FALLBACK,
+						GFP_KERNEL);
 	if (IS_ERR(ctx->fallback))
 		return PTR_ERR(ctx->fallback);
 
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 6be377f..50a19c1 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -765,7 +765,8 @@ static int sahara_aes_cra_init(struct crypto_tfm *tfm)
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->fallback = crypto_alloc_ablkcipher(name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+				GFP_KERNEL);
 	if (IS_ERR(ctx->fallback)) {
 		pr_err("Error allocating fallback algo %s\n", name);
 		return PTR_ERR(ctx->fallback);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9eeea19..bde80c3 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1438,7 +1438,8 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 		return -ENOMEM;
 
 	for (i = 0; i < cc->tfms_count; i++) {
-		cc->tfms[i] = crypto_alloc_ablkcipher(ciphermode, 0, 0);
+		cc->tfms[i] = crypto_alloc_ablkcipher(ciphermode, 0, 0,
+							GFP_KERNEL);
 		if (IS_ERR(cc->tfms[i])) {
 			err = PTR_ERR(cc->tfms[i]);
 			crypt_free_tfms(cc);
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 97315f2..7d0d9b2 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -623,7 +623,8 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat)
 						    crypt_stat->cipher, "cbc");
 	if (rc)
 		goto out_unlock;
-	crypt_stat->tfm = crypto_alloc_ablkcipher(full_alg_name, 0, 0);
+	crypt_stat->tfm = crypto_alloc_ablkcipher(full_alg_name, 0, 0,
+							GFP_KERNEL);
 	if (IS_ERR(crypt_stat->tfm)) {
 		rc = PTR_ERR(crypt_stat->tfm);
 		crypt_stat->tfm = NULL;
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 8ff1527..28cbe92 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -162,7 +162,8 @@ struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct inode *inode)
 		switch (key->mode) {
 		case EXT4_ENCRYPTION_MODE_AES_256_XTS:
 			ctx->tfm = crypto_ablkcipher_tfm(
-				crypto_alloc_ablkcipher("xts(aes)", 0, 0));
+				crypto_alloc_ablkcipher("xts(aes)", 0, 0,
+							GFP_NOFS));
 			break;
 		case EXT4_ENCRYPTION_MODE_AES_256_GCM:
 			/* TODO(mhalcrow): AEAD w/ gcm(aes);
diff --git a/fs/ext4/crypto_fname.c b/fs/ext4/crypto_fname.c
index fded02f..cdd07c7 100644
--- a/fs/ext4/crypto_fname.c
+++ b/fs/ext4/crypto_fname.c
@@ -372,7 +372,7 @@ struct ext4_fname_crypto_ctx *ext4_get_fname_crypto_ctx(
 		 * re-used */
 		if (ctx->ctfm == NULL) {
 			ctx->ctfm = crypto_alloc_ablkcipher("cts(cbc(aes))",
-					0, 0);
+					0, 0, GFP_KERNEL);
 		}
 		if (IS_ERR(ctx->ctfm)) {
 			res = PTR_ERR(ctx->ctfm);
diff --git a/fs/f2fs/crypto.c b/fs/f2fs/crypto.c
index c6d1122..173727e 100644
--- a/fs/f2fs/crypto.c
+++ b/fs/f2fs/crypto.c
@@ -161,7 +161,8 @@ struct f2fs_crypto_ctx *f2fs_get_crypto_ctx(struct inode *inode)
 		switch (ci->ci_data_mode) {
 		case F2FS_ENCRYPTION_MODE_AES_256_XTS:
 			ctx->tfm = crypto_ablkcipher_tfm(
-				crypto_alloc_ablkcipher("xts(aes)", 0, 0));
+				crypto_alloc_ablkcipher("xts(aes)", 0, 0,
+							GFP_NOFS));
 			break;
 		case F2FS_ENCRYPTION_MODE_AES_256_GCM:
 			/*
diff --git a/fs/f2fs/crypto_fname.c b/fs/f2fs/crypto_fname.c
index 016c4b6..47e8e05 100644
--- a/fs/f2fs/crypto_fname.c
+++ b/fs/f2fs/crypto_fname.c
@@ -275,7 +275,7 @@ int f2fs_setup_fname_crypto(struct inode *inode)
 		return -ENOKEY;
 	}
 
-	ctfm = crypto_alloc_ablkcipher("cts(cbc(aes))", 0, 0);
+	ctfm = crypto_alloc_ablkcipher("cts(cbc(aes))", 0, 0, GFP_KERNEL);
 	if (!ctfm || IS_ERR(ctfm)) {
 		res = ctfm ? PTR_ERR(ctfm) : -ENOMEM;
 		printk(KERN_DEBUG "%s: error (%d) allocating crypto tfm\n",
diff --git a/fs/f2fs/crypto_key.c b/fs/f2fs/crypto_key.c
index a25b164..6be5c9f 100644
--- a/fs/f2fs/crypto_key.c
+++ b/fs/f2fs/crypto_key.c
@@ -48,7 +48,7 @@ static int f2fs_derive_key_aes(char deriving_key[F2FS_AES_128_ECB_KEY_SIZE],
 	DECLARE_F2FS_COMPLETION_RESULT(ecr);
 	struct scatterlist src_sg, dst_sg;
 	struct crypto_ablkcipher *tfm = crypto_alloc_ablkcipher("ecb(aes)", 0,
-								0);
+								0, GFP_KERNEL);
 
 	if (IS_ERR(tfm)) {
 		res = PTR_ERR(tfm);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 10df5d2..b26ac44 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -885,7 +885,7 @@ static inline u32 crypto_skcipher_mask(u32 mask)
  *	   of an error, PTR_ERR() returns the error code.
  */
 struct crypto_ablkcipher *crypto_alloc_ablkcipher(const char *alg_name,
-						  u32 type, u32 mask);
+					  u32 type, u32 mask, gfp_t gfp);
 
 static inline struct crypto_tfm *crypto_ablkcipher_tfm(
 	struct crypto_ablkcipher *tfm)
-- 
2.1.1
