From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: optimize ext4_end_io memory usage
Date: Mon,  1 Apr 2013 09:17:48 +0400
Message-ID: <1364793468-1302-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:33075 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab3DAFR4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 01:17:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_end_io->pages array has is used only for buffered writes and usless
in case of DIO. This patch allow us to save 1K for each DIO request.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    4 ++--
 fs/ext4/inode.c   |    3 +--
 fs/ext4/page-io.c |   39 ++++++++++++++++++++++++++++++++-------
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 73f3e60..4c803af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -219,7 +219,7 @@ typedef struct ext4_io_end {
 	struct kiocb		*iocb;		/* iocb struct for AIO */
 	int			result;		/* error value for AIO */
 	int			num_io_pages;   /* for writepages() */
-	struct ext4_io_page	*pages[MAX_IO_PAGES]; /* for writepages() */
+	struct ext4_io_page	**pages; 	/* for writepages() */
 } ext4_io_end_t;
 
 struct ext4_io_submit {
@@ -2622,7 +2622,7 @@ extern void ext4_add_complete_io(ext4_io_end_t *io_end);
 extern void ext4_exit_pageio(void);
 extern void ext4_ioend_shutdown(struct inode *);
 extern void ext4_free_io_end(ext4_io_end_t *io);
-extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
+extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, int directio, gfp_t flags);
 extern void ext4_end_io_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
 extern int ext4_bio_write_page(struct ext4_io_submit *io,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f455ac0..840a23e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3162,12 +3162,11 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	iocb->private = NULL;
 	ext4_inode_aio_set(inode, NULL);
 	if (!is_sync_kiocb(iocb)) {
-		ext4_io_end_t *io_end = ext4_init_io_end(inode, GFP_NOFS);
+		ext4_io_end_t *io_end = ext4_init_io_end(inode, 1, GFP_NOFS);
 		if (!io_end) {
 			ret = -ENOMEM;
 			goto retake_lock;
 		}
-		io_end->flag |= EXT4_IO_END_DIRECT;
 		iocb->private = io_end;
 		/*
 		 * we save the io structure for current async direct
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 047a6de..1b8ec50 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -29,16 +29,26 @@
 #include "xattr.h"
 #include "acl.h"
 
-static struct kmem_cache *io_page_cachep, *io_end_cachep;
+static struct kmem_cache *io_page_cachep, *io_pgvec_cachep, *io_end_cachep;
 
 int __init ext4_init_pageio(void)
 {
 	io_page_cachep = KMEM_CACHE(ext4_io_page, SLAB_RECLAIM_ACCOUNT);
 	if (io_page_cachep == NULL)
 		return -ENOMEM;
+
+	io_pgvec_cachep = kmem_cache_create("ext4_io_pgvec",
+					    sizeof(struct ext4_io_page*)
+					    * MAX_IO_PAGES,
+					    0, (SLAB_RECLAIM_ACCOUNT), NULL);
+	if (io_pgvec_cachep == NULL) {
+		kmem_cache_destroy(io_page_cachep);
+		return -ENOMEM;
+	}
 	io_end_cachep = KMEM_CACHE(ext4_io_end, SLAB_RECLAIM_ACCOUNT);
 	if (io_end_cachep == NULL) {
 		kmem_cache_destroy(io_page_cachep);
+		kmem_cache_destroy(io_pgvec_cachep);
 		return -ENOMEM;
 	}
 	return 0;
@@ -47,6 +57,7 @@ int __init ext4_init_pageio(void)
 void ext4_exit_pageio(void)
 {
 	kmem_cache_destroy(io_end_cachep);
+	kmem_cache_destroy(io_pgvec_cachep);
 	kmem_cache_destroy(io_page_cachep);
 }
 
@@ -83,12 +94,15 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	BUG_ON(!io);
 	BUG_ON(!list_empty(&io->list));
 	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
+	BUG_ON(io->num_io_pages && !io->pages);
 
 	for (i = 0; i < io->num_io_pages; i++)
 		put_io_page(io->pages[i]);
 	io->num_io_pages = 0;
 	if (atomic_dec_and_test(&EXT4_I(io->inode)->i_ioend_count))
 		wake_up_all(ext4_ioend_wq(io->inode));
+	if (io->pages)
+		kmem_cache_free(io_pgvec_cachep, io->pages);
 	kmem_cache_free(io_end_cachep, io);
 }
 
@@ -212,14 +226,25 @@ int ext4_flush_unwritten_io(struct inode *inode)
 	return ret;
 }
 
-ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
+ext4_io_end_t *ext4_init_io_end(struct inode *inode, int directio, gfp_t flags)
 {
 	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
-	if (io) {
-		atomic_inc(&EXT4_I(inode)->i_ioend_count);
-		io->inode = inode;
-		INIT_LIST_HEAD(&io->list);
+
+	if (!io)
+		return NULL;
+
+	if (directio) {
+		io->flag = EXT4_IO_END_DIRECT;
+	} else {
+		io->pages = kmem_cache_zalloc(io_pgvec_cachep, flags);
+		if (!io->pages) {
+			kmem_cache_free(io_end_cachep, io);
+			return NULL;
+		}
 	}
+	atomic_inc(&EXT4_I(inode)->i_ioend_count);
+	io->inode = inode;
+	INIT_LIST_HEAD(&io->list);
 	return io;
 }
 
@@ -327,7 +352,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	int nvecs = bio_get_nr_vecs(bh->b_bdev);
 	struct bio *bio;
 
-	io_end = ext4_init_io_end(inode, GFP_NOFS);
+	io_end = ext4_init_io_end(inode, 0, GFP_NOFS);
 	if (!io_end)
 		return -ENOMEM;
 	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
-- 
1.7.1

