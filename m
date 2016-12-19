From: Richard Weinberger <richard@nod.at>
Subject: [PATCH v2] fscrypt: Factor out bio specific functions
Date: Mon, 19 Dec 2016 12:25:32 +0100
Message-ID: <20161219112532.18863-1-richard@nod.at>
References: <20161219103929.GA16197@infradead.org>
Cc: linux-kernel@vger.kernel.org, jaegeuk@kernel.org, tytso@mit.edu,
        hch@infradead.org, arnd@arndb.de, dedekind1@gmail.com,
        linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-ext4@vger.kernel.org, ebiggers@google.com,
        rdunlap@infradead.org, david@sigma-star.at,
        Richard Weinberger <richard@nod.at>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161219103929.GA16197@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

That way we can get rid of the direct dependency on CONFIG_BLOCK.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Fixes: d475a507457b ("ubifs: Add skeleton for fscrypto")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
Changes since v1:
 - Moved fscrypt_zeroout_range() also to bio.c

---
 fs/crypto/Kconfig           |   1 -
 fs/crypto/Makefile          |   1 +
 fs/crypto/bio.c             | 145 ++++++++++++++++++++++++++++++++++++++++
 fs/crypto/crypto.c          | 157 +++++---------------------------------------
 fs/crypto/fscrypt_private.h |  16 ++++-
 include/linux/fscrypto.h    |  11 ++--
 6 files changed, 184 insertions(+), 147 deletions(-)
 create mode 100644 fs/crypto/bio.c

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index f514978f6688..08b46e6e3995 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -1,6 +1,5 @@
 config FS_ENCRYPTION
 	tristate "FS Encryption (Per-file encryption)"
-	depends on BLOCK
 	select CRYPTO
 	select CRYPTO_AES
 	select CRYPTO_CBC
diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index f17684c48739..9f6607f17b53 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_FS_ENCRYPTION)	+= fscrypto.o
 
 fscrypto-y := crypto.o fname.o policy.o keyinfo.o
+fscrypto-$(CONFIG_BLOCK) += bio.o
diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
new file mode 100644
index 000000000000..a409a84f1bca
--- /dev/null
+++ b/fs/crypto/bio.c
@@ -0,0 +1,145 @@
+/*
+ * This contains encryption functions for per-file encryption.
+ *
+ * Copyright (C) 2015, Google, Inc.
+ * Copyright (C) 2015, Motorola Mobility
+ *
+ * Written by Michael Halcrow, 2014.
+ *
+ * Filename encryption additions
+ *	Uday Savagaonkar, 2014
+ * Encryption policy handling additions
+ *	Ildar Muslukhov, 2014
+ * Add fscrypt_pullback_bio_page()
+ *	Jaegeuk Kim, 2015.
+ *
+ * This has not yet undergone a rigorous security audit.
+ *
+ * The usage of AES-XTS should conform to recommendations in NIST
+ * Special Publication 800-38E and IEEE P1619/D16.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/module.h>
+#include <linux/bio.h>
+#include <linux/namei.h>
+#include "fscrypt_private.h"
+
+/*
+ * Call fscrypt_decrypt_page on every single page, reusing the encryption
+ * context.
+ */
+static void completion_pages(struct work_struct *work)
+{
+	struct fscrypt_ctx *ctx =
+		container_of(work, struct fscrypt_ctx, r.work);
+	struct bio *bio = ctx->r.bio;
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		struct page *page = bv->bv_page;
+		int ret = fscrypt_decrypt_page(page->mapping->host, page,
+				PAGE_SIZE, 0, page->index);
+
+		if (ret) {
+			WARN_ON_ONCE(1);
+			SetPageError(page);
+		} else {
+			SetPageUptodate(page);
+		}
+		unlock_page(page);
+	}
+	fscrypt_release_ctx(ctx);
+	bio_put(bio);
+}
+
+void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio)
+{
+	INIT_WORK(&ctx->r.work, completion_pages);
+	ctx->r.bio = bio;
+	queue_work(fscrypt_read_workqueue, &ctx->r.work);
+}
+EXPORT_SYMBOL(fscrypt_decrypt_bio_pages);
+
+void fscrypt_pullback_bio_page(struct page **page, bool restore)
+{
+	struct fscrypt_ctx *ctx;
+	struct page *bounce_page;
+
+	/* The bounce data pages are unmapped. */
+	if ((*page)->mapping)
+		return;
+
+	/* The bounce data page is unmapped. */
+	bounce_page = *page;
+	ctx = (struct fscrypt_ctx *)page_private(bounce_page);
+
+	/* restore control page */
+	*page = ctx->w.control_page;
+
+	if (restore)
+		fscrypt_restore_control_page(bounce_page);
+}
+EXPORT_SYMBOL(fscrypt_pullback_bio_page);
+
+int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
+				sector_t pblk, unsigned int len)
+{
+	struct fscrypt_ctx *ctx;
+	struct page *ciphertext_page = NULL;
+	struct bio *bio;
+	int ret, err = 0;
+
+	BUG_ON(inode->i_sb->s_blocksize != PAGE_SIZE);
+
+	ctx = fscrypt_get_ctx(inode, GFP_NOFS);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	ciphertext_page = fscrypt_alloc_bounce_page(ctx, GFP_NOWAIT);
+	if (IS_ERR(ciphertext_page)) {
+		err = PTR_ERR(ciphertext_page);
+		goto errout;
+	}
+
+	while (len--) {
+		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk,
+					     ZERO_PAGE(0), ciphertext_page,
+					     PAGE_SIZE, 0, GFP_NOFS);
+		if (err)
+			goto errout;
+
+		bio = bio_alloc(GFP_NOWAIT, 1);
+		if (!bio) {
+			err = -ENOMEM;
+			goto errout;
+		}
+		bio->bi_bdev = inode->i_sb->s_bdev;
+		bio->bi_iter.bi_sector =
+			pblk << (inode->i_sb->s_blocksize_bits - 9);
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+		ret = bio_add_page(bio, ciphertext_page,
+					inode->i_sb->s_blocksize, 0);
+		if (ret != inode->i_sb->s_blocksize) {
+			/* should never happen! */
+			WARN_ON(1);
+			bio_put(bio);
+			err = -EIO;
+			goto errout;
+		}
+		err = submit_bio_wait(bio);
+		if ((err == 0) && bio->bi_error)
+			err = -EIO;
+		bio_put(bio);
+		if (err)
+			goto errout;
+		lblk++;
+		pblk++;
+	}
+	err = 0;
+errout:
+	fscrypt_release_ctx(ctx);
+	return err;
+}
+EXPORT_SYMBOL(fscrypt_zeroout_range);
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index ac8e4f6a3773..02a7a9286449 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
-#include <linux/bio.h>
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include "fscrypt_private.h"
@@ -44,7 +43,7 @@ static mempool_t *fscrypt_bounce_page_pool = NULL;
 static LIST_HEAD(fscrypt_free_ctxs);
 static DEFINE_SPINLOCK(fscrypt_ctx_lock);
 
-static struct workqueue_struct *fscrypt_read_workqueue;
+struct workqueue_struct *fscrypt_read_workqueue;
 static DEFINE_MUTEX(fscrypt_init_mutex);
 
 static struct kmem_cache *fscrypt_ctx_cachep;
@@ -141,16 +140,10 @@ static void page_crypt_complete(struct crypto_async_request *req, int res)
 	complete(&ecr->completion);
 }
 
-typedef enum {
-	FS_DECRYPT = 0,
-	FS_ENCRYPT,
-} fscrypt_direction_t;
-
-static int do_page_crypto(const struct inode *inode,
-			fscrypt_direction_t rw, u64 lblk_num,
-			struct page *src_page, struct page *dest_page,
-			unsigned int len, unsigned int offs,
-			gfp_t gfp_flags)
+int fscrypt_do_page_crypto(const struct inode *inode, fscrypt_direction_t rw,
+			   u64 lblk_num, struct page *src_page,
+			   struct page *dest_page, unsigned int len,
+			   unsigned int offs, gfp_t gfp_flags)
 {
 	struct {
 		__le64 index;
@@ -205,7 +198,8 @@ static int do_page_crypto(const struct inode *inode,
 	return 0;
 }
 
-static struct page *alloc_bounce_page(struct fscrypt_ctx *ctx, gfp_t gfp_flags)
+struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
+				       gfp_t gfp_flags)
 {
 	ctx->w.bounce_page = mempool_alloc(fscrypt_bounce_page_pool, gfp_flags);
 	if (ctx->w.bounce_page == NULL)
@@ -260,9 +254,9 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 
 	if (inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES) {
 		/* with inplace-encryption we just encrypt the page */
-		err = do_page_crypto(inode, FS_ENCRYPT, lblk_num,
-					page, ciphertext_page,
-					len, offs, gfp_flags);
+		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num, page,
+					     ciphertext_page, len, offs,
+					     gfp_flags);
 		if (err)
 			return ERR_PTR(err);
 
@@ -276,14 +270,14 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 		return (struct page *)ctx;
 
 	/* The encryption operation will require a bounce page. */
-	ciphertext_page = alloc_bounce_page(ctx, gfp_flags);
+	ciphertext_page = fscrypt_alloc_bounce_page(ctx, gfp_flags);
 	if (IS_ERR(ciphertext_page))
 		goto errout;
 
 	ctx->w.control_page = page;
-	err = do_page_crypto(inode, FS_ENCRYPT, lblk_num,
-					page, ciphertext_page,
-					len, offs, gfp_flags);
+	err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num,
+				     page, ciphertext_page, len, offs,
+				     gfp_flags);
 	if (err) {
 		ciphertext_page = ERR_PTR(err);
 		goto errout;
@@ -320,72 +314,11 @@ int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 	if (!(inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES))
 		BUG_ON(!PageLocked(page));
 
-	return do_page_crypto(inode, FS_DECRYPT, lblk_num, page, page, len,
-			offs, GFP_NOFS);
+	return fscrypt_do_page_crypto(inode, FS_DECRYPT, lblk_num, page, page,
+				      len, offs, GFP_NOFS);
 }
 EXPORT_SYMBOL(fscrypt_decrypt_page);
 
-int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
-				sector_t pblk, unsigned int len)
-{
-	struct fscrypt_ctx *ctx;
-	struct page *ciphertext_page = NULL;
-	struct bio *bio;
-	int ret, err = 0;
-
-	BUG_ON(inode->i_sb->s_blocksize != PAGE_SIZE);
-
-	ctx = fscrypt_get_ctx(inode, GFP_NOFS);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	ciphertext_page = alloc_bounce_page(ctx, GFP_NOWAIT);
-	if (IS_ERR(ciphertext_page)) {
-		err = PTR_ERR(ciphertext_page);
-		goto errout;
-	}
-
-	while (len--) {
-		err = do_page_crypto(inode, FS_ENCRYPT, lblk,
-					ZERO_PAGE(0), ciphertext_page,
-					PAGE_SIZE, 0, GFP_NOFS);
-		if (err)
-			goto errout;
-
-		bio = bio_alloc(GFP_NOWAIT, 1);
-		if (!bio) {
-			err = -ENOMEM;
-			goto errout;
-		}
-		bio->bi_bdev = inode->i_sb->s_bdev;
-		bio->bi_iter.bi_sector =
-			pblk << (inode->i_sb->s_blocksize_bits - 9);
-		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
-		ret = bio_add_page(bio, ciphertext_page,
-					inode->i_sb->s_blocksize, 0);
-		if (ret != inode->i_sb->s_blocksize) {
-			/* should never happen! */
-			WARN_ON(1);
-			bio_put(bio);
-			err = -EIO;
-			goto errout;
-		}
-		err = submit_bio_wait(bio);
-		if ((err == 0) && bio->bi_error)
-			err = -EIO;
-		bio_put(bio);
-		if (err)
-			goto errout;
-		lblk++;
-		pblk++;
-	}
-	err = 0;
-errout:
-	fscrypt_release_ctx(ctx);
-	return err;
-}
-EXPORT_SYMBOL(fscrypt_zeroout_range);
-
 /*
  * Validate dentries for encrypted directories to make sure we aren't
  * potentially caching stale data after a key has been added or
@@ -442,64 +375,6 @@ const struct dentry_operations fscrypt_d_ops = {
 };
 EXPORT_SYMBOL(fscrypt_d_ops);
 
-/*
- * Call fscrypt_decrypt_page on every single page, reusing the encryption
- * context.
- */
-static void completion_pages(struct work_struct *work)
-{
-	struct fscrypt_ctx *ctx =
-		container_of(work, struct fscrypt_ctx, r.work);
-	struct bio *bio = ctx->r.bio;
-	struct bio_vec *bv;
-	int i;
-
-	bio_for_each_segment_all(bv, bio, i) {
-		struct page *page = bv->bv_page;
-		int ret = fscrypt_decrypt_page(page->mapping->host, page,
-				PAGE_SIZE, 0, page->index);
-
-		if (ret) {
-			WARN_ON_ONCE(1);
-			SetPageError(page);
-		} else {
-			SetPageUptodate(page);
-		}
-		unlock_page(page);
-	}
-	fscrypt_release_ctx(ctx);
-	bio_put(bio);
-}
-
-void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *ctx, struct bio *bio)
-{
-	INIT_WORK(&ctx->r.work, completion_pages);
-	ctx->r.bio = bio;
-	queue_work(fscrypt_read_workqueue, &ctx->r.work);
-}
-EXPORT_SYMBOL(fscrypt_decrypt_bio_pages);
-
-void fscrypt_pullback_bio_page(struct page **page, bool restore)
-{
-	struct fscrypt_ctx *ctx;
-	struct page *bounce_page;
-
-	/* The bounce data pages are unmapped. */
-	if ((*page)->mapping)
-		return;
-
-	/* The bounce data page is unmapped. */
-	bounce_page = *page;
-	ctx = (struct fscrypt_ctx *)page_private(bounce_page);
-
-	/* restore control page */
-	*page = ctx->w.control_page;
-
-	if (restore)
-		fscrypt_restore_control_page(bounce_page);
-}
-EXPORT_SYMBOL(fscrypt_pullback_bio_page);
-
 void fscrypt_restore_control_page(struct page *page)
 {
 	struct fscrypt_ctx *ctx;
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index aeab032d7d35..7bff7b4c7498 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -71,6 +71,11 @@ struct fscrypt_info {
 	u8 ci_master_key[FS_KEY_DESCRIPTOR_SIZE];
 };
 
+typedef enum {
+	FS_DECRYPT = 0,
+	FS_ENCRYPT,
+} fscrypt_direction_t;
+
 #define FS_CTX_REQUIRES_FREE_ENCRYPT_FL		0x00000001
 #define FS_CTX_HAS_BOUNCE_BUFFER_FL		0x00000002
 
@@ -85,7 +90,16 @@ struct fscrypt_completion_result {
 
 
 /* crypto.c */
-int fscrypt_initialize(unsigned int cop_flags);
+extern int fscrypt_initialize(unsigned int cop_flags);
+extern struct workqueue_struct *fscrypt_read_workqueue;
+extern int fscrypt_do_page_crypto(const struct inode *inode,
+				  fscrypt_direction_t rw, u64 lblk_num,
+				  struct page *src_page,
+				  struct page *dest_page,
+				  unsigned int len, unsigned int offs,
+				  gfp_t gfp_flags);
+extern struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
+					      gfp_t gfp_flags);
 
 /* keyinfo.c */
 extern int fscrypt_get_crypt_info(struct inode *);
diff --git a/include/linux/fscrypto.h b/include/linux/fscrypto.h
index c074b670aa99..2a2815702095 100644
--- a/include/linux/fscrypto.h
+++ b/include/linux/fscrypto.h
@@ -174,11 +174,8 @@ extern struct page *fscrypt_encrypt_page(const struct inode *, struct page *,
 						u64, gfp_t);
 extern int fscrypt_decrypt_page(const struct inode *, struct page *, unsigned int,
 				unsigned int, u64);
-extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
-extern void fscrypt_pullback_bio_page(struct page **, bool);
 extern void fscrypt_restore_control_page(struct page *);
-extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
-						unsigned int);
+
 /* policy.c */
 extern int fscrypt_ioctl_set_policy(struct file *, const void __user *);
 extern int fscrypt_ioctl_get_policy(struct file *, void __user *);
@@ -201,6 +198,12 @@ extern int fscrypt_fname_disk_to_usr(struct inode *, u32, u32,
 			const struct fscrypt_str *, struct fscrypt_str *);
 extern int fscrypt_fname_usr_to_disk(struct inode *, const struct qstr *,
 			struct fscrypt_str *);
+
+/* bio.c */
+extern void fscrypt_decrypt_bio_pages(struct fscrypt_ctx *, struct bio *);
+extern void fscrypt_pullback_bio_page(struct page **, bool);
+extern int fscrypt_zeroout_range(const struct inode *, pgoff_t, sector_t,
+				 unsigned int);
 #endif
 
 /* crypto.c */
-- 
2.10.2
