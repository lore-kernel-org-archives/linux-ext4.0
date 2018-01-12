From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 6/8] ext4: encrypt blocks whose size is less than page size
Date: Fri, 12 Jan 2018 19:41:27 +0530
Message-ID: <20180112141129.27507-7-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933944AbeALOKq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 12 Jan 2018 09:10:46 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0CE9pND010667
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:45 -0500
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fewx0jts5-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Fri, 12 Jan 2018 09:10:44 -0500
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 12 Jan 2018 07:10:44 -0700
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds code to encrypt all file blocks mapped by page.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/crypto/crypto.c              | 80 ++++++++++++++++++++++++++---------------
 fs/ext4/page-io.c               | 58 ++++++++++++++++++++----------
 include/linux/fscrypt_notsupp.h | 15 ++++----
 include/linux/fscrypt_supp.h    | 11 ++++--
 4 files changed, 108 insertions(+), 56 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 732a786..52ad5cf 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -226,15 +226,16 @@ struct page *fscrypt_alloc_bounce_page(struct fscrypt_ctx *ctx,
  * Return: A page with the encrypted content on success. Else, an
  * error value or NULL.
  */
-struct page *fscrypt_encrypt_page(const struct inode *inode,
-				struct page *page,
-				unsigned int len,
-				unsigned int offs,
-				u64 lblk_num, gfp_t gfp_flags)
-
+int fscrypt_encrypt_page(const struct inode *inode,
+			struct page *page,
+			unsigned int len,
+			unsigned int offs,
+			u64 lblk_num,
+			struct fscrypt_ctx **ctx,
+			struct page **ciphertext_page,
+			gfp_t gfp_flags)
 {
-	struct fscrypt_ctx *ctx;
-	struct page *ciphertext_page = page;
+	int mark_pg_private = 0;
 	int err;
 
 	BUG_ON(len % FS_CRYPTO_BLOCK_SIZE != 0);
@@ -242,41 +243,64 @@ struct page *fscrypt_encrypt_page(const struct inode *inode,
 	if (inode->i_sb->s_cop->flags & FS_CFLG_OWN_PAGES) {
 		/* with inplace-encryption we just encrypt the page */
 		err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num, page,
-					     ciphertext_page, len, offs,
+					     page, len, offs,
 					     gfp_flags);
 		if (err)
-			return ERR_PTR(err);
+			return err;
 
-		return ciphertext_page;
+		*ciphertext_page = page;
+
+		return 0;
 	}
 
 	BUG_ON(!PageLocked(page));
 
-	ctx = fscrypt_get_ctx(inode, gfp_flags);
-	if (IS_ERR(ctx))
-		return (struct page *)ctx;
+	if (!*ctx) {
+		BUG_ON(*ciphertext_page);
+		*ctx = fscrypt_get_ctx(inode, gfp_flags);
+		if (IS_ERR(*ctx))
+			return PTR_ERR(*ctx);
+
+		(*ctx)->w.control_page = page;
+	} else {
+		BUG_ON(!*ciphertext_page);
+	}
+
+	if (!*ciphertext_page) {
+		/* The encryption operation will require a bounce page. */
+		*ciphertext_page = fscrypt_alloc_bounce_page(*ctx, gfp_flags);
+		if (IS_ERR(*ciphertext_page)) {
+			err = PTR_ERR(*ciphertext_page);
+			*ciphertext_page = NULL;
+			goto errout;
+		}
+		mark_pg_private = 1;
+	}
 
-	/* The encryption operation will require a bounce page. */
-	ciphertext_page = fscrypt_alloc_bounce_page(ctx, gfp_flags);
-	if (IS_ERR(ciphertext_page))
-		goto errout;
 
-	ctx->w.control_page = page;
 	err = fscrypt_do_page_crypto(inode, FS_ENCRYPT, lblk_num,
-				     page, ciphertext_page, len, offs,
+				     page, *ciphertext_page, len, offs,
 				     gfp_flags);
-	if (err) {
-		ciphertext_page = ERR_PTR(err);
+	if (err)
 		goto errout;
+
+	if (mark_pg_private) {
+		SetPagePrivate(*ciphertext_page);
+		set_page_private(*ciphertext_page, (unsigned long)(*ctx));
+		lock_page(*ciphertext_page);
 	}
-	SetPagePrivate(ciphertext_page);
-	set_page_private(ciphertext_page, (unsigned long)ctx);
-	lock_page(ciphertext_page);
-	return ciphertext_page;
+
+	return 0;
 
 errout:
-	fscrypt_release_ctx(ctx);
-	return ciphertext_page;
+	if (*ciphertext_page && PagePrivate(*ciphertext_page)) {
+		set_page_private(*ciphertext_page, (unsigned long)NULL);
+		ClearPagePrivate(*ciphertext_page);
+		unlock_page(*ciphertext_page);
+	}
+
+	fscrypt_release_ctx(*ctx);
+	return err;
 }
 EXPORT_SYMBOL(fscrypt_encrypt_page);
 
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db75901..9828d77 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -415,7 +415,7 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 			struct writeback_control *wbc,
 			bool keep_towrite)
 {
-	struct page *data_page = NULL;
+	struct page *ciphertext_page = NULL;
 	struct inode *inode = page->mapping->host;
 	unsigned block_start;
 	struct buffer_head *bh, *head;
@@ -475,36 +475,56 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 		nr_to_submit++;
 	} while ((bh = bh->b_this_page) != head);
 
-	bh = head = page_buffers(page);
 
 	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode) &&
 	    nr_to_submit) {
+		struct fscrypt_ctx *ctx;
+		u64 blk_nr;
 		gfp_t gfp_flags = GFP_NOFS;
 
-	retry_encrypt:
-		data_page = fscrypt_encrypt_page(inode, page, PAGE_SIZE, 0,
-						page->index, gfp_flags);
-		if (IS_ERR(data_page)) {
-			ret = PTR_ERR(data_page);
-			if (ret == -ENOMEM && wbc->sync_mode == WB_SYNC_ALL) {
-				if (io->io_bio) {
-					ext4_io_submit(io);
-					congestion_wait(BLK_RW_ASYNC, HZ/50);
+		bh = head = page_buffers(page);
+		blk_nr = page->index << (PAGE_SHIFT - inode->i_blkbits);
+		ctx = NULL;
+		ciphertext_page = NULL;
+
+		do {
+			if (!buffer_async_write(bh))
+				continue;
+		retry_encrypt:
+			ret = fscrypt_encrypt_page(inode, page, bh->b_size,
+						bh_offset(bh),
+						blk_nr, &ctx,
+						&ciphertext_page,
+						gfp_flags);
+			if (ret) {
+				if (ret == -ENOMEM
+					&& wbc->sync_mode == WB_SYNC_ALL) {
+					if (io->io_bio) {
+						ext4_io_submit(io);
+						congestion_wait(BLK_RW_ASYNC,
+								HZ/50);
+					}
+					gfp_flags |= __GFP_NOFAIL;
+					bh = head = page_buffers(page);
+					blk_nr = page->index
+						<< (PAGE_SHIFT - inode->i_blkbits);
+					ctx = NULL;
+					ciphertext_page = NULL;
+					goto retry_encrypt;
 				}
-				gfp_flags |= __GFP_NOFAIL;
-				goto retry_encrypt;
+				ciphertext_page = NULL;
+				goto out;
 			}
-			data_page = NULL;
-			goto out;
-		}
+		} while (++blk_nr, (bh = bh->b_this_page) != head);
 	}
 
+	bh = head = page_buffers(page);
 	/* Now submit buffers to write */
 	do {
 		if (!buffer_async_write(bh))
 			continue;
 		ret = io_submit_add_bh(io, inode,
-				       data_page ? data_page : page, bh);
+				       ciphertext_page ? ciphertext_page : page, bh);
 		if (ret) {
 			/*
 			 * We only get here on ENOMEM.  Not much else
@@ -520,8 +540,8 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	/* Error stopped previous loop? Clean up buffers... */
 	if (ret) {
 	out:
-		if (data_page)
-			fscrypt_restore_control_page(data_page);
+		if (ciphertext_page && !nr_submitted)
+			fscrypt_restore_control_page(ciphertext_page);
 		printk_ratelimited(KERN_ERR "%s: ret = %d\n", __func__, ret);
 		redirty_page_for_writepage(wbc, page);
 		do {
diff --git a/include/linux/fscrypt_notsupp.h b/include/linux/fscrypt_notsupp.h
index 63e5880..019ddce 100644
--- a/include/linux/fscrypt_notsupp.h
+++ b/include/linux/fscrypt_notsupp.h
@@ -26,13 +26,16 @@ static inline void fscrypt_release_ctx(struct fscrypt_ctx *ctx)
 	return;
 }
 
-static inline struct page *fscrypt_encrypt_page(const struct inode *inode,
-						struct page *page,
-						unsigned int len,
-						unsigned int offs,
-						u64 lblk_num, gfp_t gfp_flags)
+static inline int fscrypt_encrypt_page(const struct inode *inode,
+			struct page *page,
+			unsigned int len,
+			unsigned int offs,
+			u64 lblk_num,
+			struct fscrypt_ctx **ctx,
+			struct page **ciphertext_page,
+			gfp_t gfp_flags)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return -EOPNOTSUPP;
 }
 
 static inline int fscrypt_decrypt_page(const struct inode *inode,
diff --git a/include/linux/fscrypt_supp.h b/include/linux/fscrypt_supp.h
index cf9e9fc..983d06f 100644
--- a/include/linux/fscrypt_supp.h
+++ b/include/linux/fscrypt_supp.h
@@ -15,9 +15,14 @@
 extern struct kmem_cache *fscrypt_info_cachep;
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
 extern void fscrypt_release_ctx(struct fscrypt_ctx *);
-extern struct page *fscrypt_encrypt_page(const struct inode *, struct page *,
-						unsigned int, unsigned int,
-						u64, gfp_t);
+extern int fscrypt_encrypt_page(const struct inode *inode,
+				struct page *page,
+				unsigned int len,
+				unsigned int offs,
+				u64 lblk_num,
+				struct fscrypt_ctx **ctx,
+				struct page **ciphertext_page,
+				gfp_t gfp_flags);
 extern int fscrypt_decrypt_page(const struct inode *, struct page *, unsigned int,
 				unsigned int, u64);
 extern void fscrypt_restore_control_page(struct page *);
-- 
2.9.5
