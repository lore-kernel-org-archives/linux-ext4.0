From: Michael Halcrow <mhalcrow@google.com>
Subject: [PATCH 5/5] ext4: Implements real encryption in the EXT4 write and read paths
Date: Wed, 23 Jul 2014 14:23:28 -0700
Message-ID: <1406150608-19351-6-git-send-email-mhalcrow@google.com>
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

Implements real encryption in the EXT4 write and read paths.

Signed-off-by: Michael Halcrow <mhalcrow@google.com>
---
 fs/ext4/crypto.c | 65 +++++++++++++++++++++++---------------------------------
 fs/ext4/inode.c  |  9 +++++++-
 2 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 435f33f..a17b23b 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -353,9 +353,10 @@ struct page *ext4_encrypt(ext4_crypto_ctx_t *ctx, struct page *plaintext_page)
 		ciphertext_page = ERR_PTR(-ENOMEM);
 		goto out;
 	}
-	ablkcipher_request_set_callback(req,
-			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			ext4_crypt_complete, &ecr);
+	ablkcipher_request_set_callback(
+		req,
+		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_crypt_complete, &ecr);
 	ext4_xts_tweak_for_page(xts_tweak, plaintext_page);
 	sg_init_table(&dst, 1);
 	sg_init_table(&src, 1);
@@ -363,20 +364,20 @@ struct page *ext4_encrypt(ext4_crypto_ctx_t *ctx, struct page *plaintext_page)
 	sg_set_page(&src, plaintext_page, PAGE_CACHE_SIZE, 0);
 	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
 				     xts_tweak);
+	res = crypto_ablkcipher_encrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		reinit_completion(&ecr.completion);
+	}
 	ablkcipher_request_free(req);
-/* =======
- * TODO(mhalcrow): Removed real crypto so intermediate patch
- * for write path is still fully functional. */
-	{
-		/* TODO(mhalcrow): Temporary for testing */
-		char *ciphertext_virt, *plaintext_virt;
-		ciphertext_virt = kmap(ciphertext_page);
-		plaintext_virt = kmap(plaintext_page);
-		memcpy(ciphertext_virt, plaintext_virt, PAGE_CACHE_SIZE);
-		kunmap(plaintext_page);
-		kunmap(ciphertext_page);
+	if (res) {
+		printk_ratelimited(KERN_ERR "%s: crypto_ablkcipher_encrypt() "
+				   "returned %d\n", __func__, res);
+		ciphertext_page = ERR_PTR(res);
+		goto out;
 	}
-/* ======= */
 	SetPageDirty(ciphertext_page);
 	SetPagePrivate(ciphertext_page);
 	ctx->control_page = plaintext_page;
@@ -410,9 +411,10 @@ int ext4_decrypt(ext4_crypto_ctx_t *ctx, struct page* page)
 		res = -ENOMEM;
 		goto out;
 	}
-	ablkcipher_request_set_callback(req,
-			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			ext4_crypt_complete, &ecr);
+	ablkcipher_request_set_callback(
+		req,
+		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
+		ext4_crypt_complete, &ecr);
 	ext4_xts_tweak_for_page(xts_tweak, page);
 	sg_init_table(&dst, 1);
 	sg_init_table(&src, 1);
@@ -420,28 +422,13 @@ int ext4_decrypt(ext4_crypto_ctx_t *ctx, struct page* page)
 	sg_set_page(&src, page, PAGE_CACHE_SIZE, 0);
 	ablkcipher_request_set_crypt(req, &src, &dst, PAGE_CACHE_SIZE,
 				     xts_tweak);
-/* =======
- * TODO(mhalcrow): Removed real crypto so intermediate patch for read
- * path is still fully functional. For now just doing something that
- * might expose a race condition. */
-	{
-		char *page_virt;
-		char tmp;
-                int i;
-		page_virt = kmap(page);
-		for (i = 0; i < PAGE_CACHE_SIZE / 2; ++i) {
-			tmp = page_virt[i];
-			page_virt[i] = page_virt[PAGE_CACHE_SIZE - i - 1];
-			page_virt[PAGE_CACHE_SIZE - i - 1] = tmp;
-		}
-		for (i = 0; i < PAGE_CACHE_SIZE / 2; ++i) {
-			tmp = page_virt[i];
-			page_virt[i] = page_virt[PAGE_CACHE_SIZE - i - 1];
-			page_virt[PAGE_CACHE_SIZE - i - 1] = tmp;
-		}
-		kunmap(page);
+	res = crypto_ablkcipher_decrypt(req);
+	if (res == -EINPROGRESS || res == -EBUSY) {
+		BUG_ON(req->base.data != &ecr);
+		wait_for_completion(&ecr.completion);
+		res = ecr.res;
+		reinit_completion(&ecr.completion);
 	}
-/* ======= */
 	ablkcipher_request_free(req);
 out:
 	if (res)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6bf57d3..a0e80b7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2848,6 +2848,8 @@ static void ext4_completion_work(struct work_struct *work)
 	ext4_crypto_ctx_t *ctx = container_of(work, ext4_crypto_ctx_t, work);
 	struct page *page = ctx->control_page;
 	WARN_ON_ONCE(ext4_decrypt(ctx, page));
+	atomic_dec(&ctx->dbg_refcnt);
+	BUG_ON(atomic_read(&ctx->dbg_refcnt) != 0);
 	ext4_release_crypto_ctx(ctx);
 	SetPageUptodate(page);
 	unlock_page(page);
@@ -2859,6 +2861,8 @@ static int ext4_complete_cb(struct bio *bio, int res)
 	struct page *page = ctx->control_page;
 	BUG_ON(atomic_read(&ctx->dbg_refcnt) != 1);
 	if (res) {
+		atomic_dec(&ctx->dbg_refcnt);
+		BUG_ON(atomic_read(&ctx->dbg_refcnt) != 0);
 		ext4_release_crypto_ctx(ctx);
 		unlock_page(page);
 		return res;
@@ -2962,8 +2966,11 @@ static int ext4_read_full_page(struct page *page)
 			BUG_ON(ctx->control_page);
 			ctx->control_page = page;
 			BUG_ON(atomic_read(&ctx->dbg_refcnt) != 1);
-			if (submit_bh_cb(READ, bh, ext4_complete_cb, ctx))
+			if (submit_bh_cb(READ, bh, ext4_complete_cb, ctx)) {
+				atomic_dec(&ctx->dbg_refcnt);
+				BUG_ON(atomic_read(&ctx->dbg_refcnt) != 0);
 				ext4_release_crypto_ctx(ctx);
+			}
 		}
 	}
 	return 0;
-- 
2.0.0.526.g5318336

