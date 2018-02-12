From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH V2 09/11] fscrypt: Move completion_pages to crypto/readpage.c
Date: Mon, 12 Feb 2018 15:13:45 +0530
Message-ID: <20180212094347.22071-10-chandan@linux.vnet.ibm.com>
References: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, ebiggers3@gmail.com,
        linux-fscrypt@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933321AbeBLJnC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 12 Feb 2018 04:43:02 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1C9ebS6061233
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:43:01 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g30dffxwm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 04:43:01 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-ext4@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 12 Feb 2018 02:43:00 -0700
In-Reply-To: <20180212094347.22071-1-chandan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

completion_pages() processes endio functionality for a bio that is
intended to read file data from the disk. Hence this commit moves this
function to crypto/readpage.c file.

This commit also makes mandatory the callback function argument for
fscrypt_decrypt_bio_blocks().

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/crypto/bio.c      | 48 ++----------------------------------------------
 fs/crypto/readpage.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 265cba3..7188495 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -26,50 +26,6 @@
 #include <linux/namei.h>
 #include "fscrypt_private.h"
 
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
-		struct inode *inode = page->mapping->host;
-		const unsigned long blocksize = inode->i_sb->s_blocksize;
-		const unsigned int blkbits = inode->i_blkbits;
-		u64 page_blk = page->index << (PAGE_SHIFT - blkbits);
-		u64 blk = page_blk + (bv->bv_offset >> blkbits);
-		int nr_blks = bv->bv_len >> blkbits;
-		int ret = 0;
-		int j;
-
-		for (j = 0; j < nr_blks; j++, blk++) {
-			ret = fscrypt_decrypt_block(page->mapping->host,
-						page, blocksize,
-						bv->bv_offset + (j << blkbits),
-						blk);
-			if (ret)
-				break;
-		}
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
 bool fscrypt_bio_encrypted(struct bio *bio)
 {
 	if (bio->bi_vcnt) {
@@ -85,8 +41,8 @@ bool fscrypt_bio_encrypted(struct bio *bio)
 void fscrypt_decrypt_bio_blocks(struct fscrypt_ctx *ctx, struct bio *bio,
 			void (*process_bio)(struct work_struct *))
 {
-	INIT_WORK(&ctx->r.work,
-		process_bio ? process_bio : completion_pages);
+	BUG_ON(!process_bio);
+	INIT_WORK(&ctx->r.work, process_bio);
 	ctx->r.bio = bio;
 	queue_work(fscrypt_read_workqueue, &ctx->r.work);
 }
diff --git a/fs/crypto/readpage.c b/fs/crypto/readpage.c
index 7372173..521c221 100644
--- a/fs/crypto/readpage.c
+++ b/fs/crypto/readpage.c
@@ -29,6 +29,50 @@
 
 #include "fscrypt_private.h"
 
+/*
+ * Call fscrypt_decrypt_block on every single page, reusing the encryption
+ * context.
+ */
+static void fscrypt_complete_pages(struct work_struct *work)
+{
+	struct fscrypt_ctx *ctx =
+		container_of(work, struct fscrypt_ctx, r.work);
+	struct bio *bio = ctx->r.bio;
+	struct bio_vec *bv;
+	int i;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		struct page *page = bv->bv_page;
+		struct inode *inode = page->mapping->host;
+		const unsigned long blocksize = inode->i_sb->s_blocksize;
+		const unsigned int blkbits = inode->i_blkbits;
+		u64 page_blk = page->index << (PAGE_SHIFT - blkbits);
+		u64 blk = page_blk + (bv->bv_offset >> blkbits);
+		int nr_blks = bv->bv_len >> blkbits;
+		int ret = 0;
+		int j;
+
+		for (j = 0; j < nr_blks; j++, blk++) {
+			ret = fscrypt_decrypt_block(page->mapping->host,
+						page, blocksize,
+						bv->bv_offset + (j << blkbits),
+						blk);
+			if (ret)
+				break;
+		}
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
 static void fscrypt_complete_block(struct work_struct *work)
 {
 	struct fscrypt_ctx *ctx =
@@ -108,7 +152,8 @@ static void fscrypt_mpage_end_io(struct bio *bio)
 		if (bio->bi_status) {
 			fscrypt_release_ctx(bio->bi_private);
 		} else {
-			fscrypt_decrypt_bio_blocks(bio->bi_private, bio, NULL);
+			fscrypt_decrypt_bio_blocks(bio->bi_private, bio,
+						fscrypt_complete_pages);
 			return;
 		}
 	}
-- 
2.9.5
