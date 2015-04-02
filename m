From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 13/22] ext4 crypto: implement the ext4 decryption read path
Date: Thu,  2 Apr 2015 18:10:50 -0400
Message-ID: <1428012659-12709-14-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47975 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbbDBWMe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:34 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: Ie9c043a132a01da60d1617662cd30307639f5599
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/file.c     | 22 +++++++++++++++----
 fs/ext4/inode.c    | 10 +++++++++
 fs/ext4/readpage.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8131be8..4cacc30 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -28,6 +28,7 @@
 #include <linux/pagevec.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
+#include "ext4_crypto.h"
 #include "xattr.h"
 #include "acl.h"
 
@@ -200,9 +201,15 @@ static const struct vm_operations_struct ext4_file_vm_ops = {
 
 static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	int res = 0;
+	struct inode *inode = file->f_mapping->host;
+
+	if (ext4_encrypted_inode(inode))
+		res = ext4_generate_encryption_key(inode);
 	file_accessed(file);
-	vma->vm_ops = &ext4_file_vm_ops;
-	return 0;
+	if (!res)
+		vma->vm_ops = &ext4_file_vm_ops;
+	return res;
 }
 
 static int ext4_file_open(struct inode * inode, struct file * filp)
@@ -212,6 +219,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	struct vfsmount *mnt = filp->f_path.mnt;
 	struct path path;
 	char buf[64], *cp;
+	int ret;
 
 	if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
 		     !(sb->s_flags & MS_RDONLY))) {
@@ -250,11 +258,17 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	 * writing and the journal is present
 	 */
 	if (filp->f_mode & FMODE_WRITE) {
-		int ret = ext4_inode_attach_jinode(inode);
+		ret = ext4_inode_attach_jinode(inode);
 		if (ret < 0)
 			return ret;
 	}
-	return dquot_file_open(inode, filp);
+	ret = dquot_file_open(inode, filp);
+	if (!ret && ext4_encrypted_inode(inode)) {
+		ret = ext4_generate_encryption_key(inode);
+		if (ret)
+			ret = -EACCES;
+	}
+	return ret;
 }
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dcc836c..b033405 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -39,6 +39,7 @@
 #include <linux/ratelimit.h>
 #include <linux/aio.h>
 #include <linux/bitops.h>
+#include <linux/prefetch.h>
 
 #include "ext4_jbd2.h"
 #include "ext4_crypto.h"
@@ -3363,6 +3364,15 @@ static int ext4_block_zero_page_range(handle_t *handle,
 		/* Uhhuh. Read error. Complain and punt. */
 		if (!buffer_uptodate(bh))
 			goto unlock;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+		if (S_ISREG(inode->i_mode) &&
+		    ext4_encrypted_inode(inode)) {
+			/* We expect the key to be set. */
+			BUG_ON(!ext4_has_encryption_key(inode));
+			BUG_ON(blocksize != PAGE_CACHE_SIZE);
+			WARN_ON_ONCE(ext4_decrypt_one(inode, page));
+		}
+#endif
 	}
 	if (ext4_should_journal_data(inode)) {
 		BUFFER_TRACE(bh, "get write access");
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 9ca4dfc..8978b1d 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -43,6 +43,35 @@
 
 #include "ext4.h"
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+/*
+ * Call ext4_decrypt on every single page, reusing the encryption
+ * context.
+ */
+static void completion_pages(struct work_struct *work)
+{
+	struct ext4_crypto_ctx *ctx =
+		container_of(work, struct ext4_crypto_ctx, work);
+	struct bio	*bio	= ctx->bio;
+	struct bio_vec	*bv;
+	int		i;
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
+#endif
+
 /*
  * I/O completion handler for multipage BIOs.
  *
@@ -60,6 +89,20 @@ static void mpage_end_io(struct bio *bio, int err)
 	struct bio_vec *bv;
 	int i;
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (bio->bi_private) {
+		struct ext4_crypto_ctx *ctx = bio->bi_private;
+
+		if (err)
+			ext4_release_crypto_ctx(ctx);
+		else {
+			INIT_WORK(&ctx->work, completion_pages);
+			ctx->bio = bio;
+			queue_work(ext4_read_workqueue, &ctx->work);
+			return;
+		}
+	}
+#endif
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
 
@@ -94,9 +137,15 @@ int ext4_mpage_readpages(struct address_space *mapping,
 	unsigned page_block;
 	struct block_device *bdev = inode->i_sb->s_bdev;
 	int length;
+	int do_decryption = 0;
 	unsigned relative_block = 0;
 	struct ext4_map_blocks map;
 
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode))
+		do_decryption = 1;
+#endif
+
 	map.m_pblk = 0;
 	map.m_lblk = 0;
 	map.m_len = 0;
@@ -220,13 +269,24 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio = NULL;
 		}
 		if (bio == NULL) {
+			struct ext4_crypto_ctx *ctx = NULL;
+
+			if (do_decryption) {
+				ctx = ext4_get_crypto_ctx(inode);
+				if (IS_ERR(ctx))
+					goto set_error_page;
+			}
 			bio = bio_alloc(GFP_KERNEL,
 				min_t(int, nr_pages, bio_get_nr_vecs(bdev)));
-			if (!bio)
+			if (!bio) {
+				if (ctx)
+					ext4_release_crypto_ctx(ctx);
 				goto set_error_page;
+			}
 			bio->bi_bdev = bdev;
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
+			bio->bi_private = ctx;
 		}
 
 		length = first_hole << blkbits;
-- 
2.3.0

