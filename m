From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/3] ext4 crypto: move io_completion work into crypto.c
Date: Tue, 12 May 2015 14:19:14 -0700
Message-ID: <1431465556-36626-1-git-send-email-jaegeuk@kernel.org>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38416 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbbELVUK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2015 17:20:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In order to use this completion work across the filesystems, it'd be better to
relocate them into crypto.c.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/ext4/crypto.c   | 38 ++++++++++++++++++++++++++++++++++++--
 fs/ext4/ext4.h     |  2 +-
 fs/ext4/readpage.c | 35 +----------------------------------
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 1484b58..04c620f 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -55,6 +55,9 @@ static mempool_t *ext4_bounce_page_pool;
 static LIST_HEAD(ext4_free_crypto_ctxs);
 static DEFINE_SPINLOCK(ext4_crypto_ctx_lock);
 
+static struct workqueue_struct *ext4_read_workqueue;
+static DEFINE_MUTEX(crypto_init);
+
 static struct kmem_cache *ext4_crypto_ctx_cachep;
 struct kmem_cache *ext4_crypt_info_cachep;
 
@@ -175,8 +178,39 @@ out:
 	return ctx;
 }
 
-struct workqueue_struct *ext4_read_workqueue;
-static DEFINE_MUTEX(crypto_init);
+/*
+ * Call ext4_decrypt on every single page, reusing the encryption
+ * context.
+ */
+static void completion_pages(struct work_struct *work)
+{
+	struct ext4_crypto_ctx *ctx =
+		container_of(work, struct ext4_crypto_ctx, r.work);
+	struct bio *bio = ctx->r.bio;
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		struct page *page = bv->bv_page;
+
+		int ret = ext4_decrypt(ctx, page);
+		if (ret) {
+			WARN_ON_ONCE(1);
+			SetPageError(page);
+		} else
+			SetPageUptodate(page);
+		unlock_page(page);
+	}
+	ext4_release_crypto_ctx(ctx);
+	bio_put(bio);
+}
+
+void ext4_end_io_crypto_work(struct ext4_crypto_ctx *ctx, struct bio *bio)
+{
+	INIT_WORK(&ctx->r.work, completion_pages);
+	ctx->r.bio = bio;
+	queue_work(ext4_read_workqueue, &ctx->r.work);
+}
 
 /**
  * ext4_exit_crypto() - Shutdown the ext4 encryption system
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 550fe95..505bc66 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2062,7 +2062,7 @@ int ext4_get_policy(struct inode *inode,
 extern struct kmem_cache *ext4_crypt_info_cachep;
 bool ext4_valid_contents_enc_mode(uint32_t mode);
 uint32_t ext4_validate_encryption_key_size(uint32_t mode, uint32_t size);
-extern struct workqueue_struct *ext4_read_workqueue;
+void ext4_end_io_crypto_work(struct ext4_crypto_ctx *ctx, struct bio *bio);
 struct ext4_crypto_ctx *ext4_get_crypto_ctx(struct inode *inode);
 void ext4_release_crypto_ctx(struct ext4_crypto_ctx *ctx);
 void ext4_restore_control_page(struct page *data_page);
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index ec3ef93..a7b074e 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -46,37 +46,6 @@
 
 #include "ext4.h"
 
-/*
- * Call ext4_decrypt on every single page, reusing the encryption
- * context.
- */
-static void completion_pages(struct work_struct *work)
-{
-#ifdef CONFIG_EXT4_FS_ENCRYPTION
-	struct ext4_crypto_ctx *ctx =
-		container_of(work, struct ext4_crypto_ctx, r.work);
-	struct bio	*bio	= ctx->r.bio;
-	struct bio_vec	*bv;
-	int		i;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
-
-		int ret = ext4_decrypt(ctx, page);
-		if (ret) {
-			WARN_ON_ONCE(1);
-			SetPageError(page);
-		} else
-			SetPageUptodate(page);
-		unlock_page(page);
-	}
-	ext4_release_crypto_ctx(ctx);
-	bio_put(bio);
-#else
-	BUG();
-#endif
-}
