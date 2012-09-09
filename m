From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/7] ext4: ext4_inode_info diet
Date: Sun,  9 Sep 2012 21:27:08 +0400
Message-ID: <1347211634-11509-2-git-send-email-dmonakhov@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37543 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751885Ab2IIR1V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 13:27:21 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id y9so659795lag.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 10:27:21 -0700 (PDT)
In-Reply-To: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Generic inode has unused i_private pointer which may be used as cur_aio_dio
storage.

TODO: If cur_aio_dio will be passed as an argument to get_block_t this allow
      to have concurent AIO_DIO requests.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    5 +++--
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    6 +++---
 fs/ext4/super.c   |    1 -
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f9024a6..b3f3c55 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -912,8 +912,6 @@ struct ext4_inode_info {
 	struct list_head i_completed_io_list;
 	spinlock_t i_completed_io_lock;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
-	/* current io_end structure for async DIO write*/
-	ext4_io_end_t *cur_aio_dio;
 	atomic_t i_aiodio_unwritten; /* Nr. of inflight conversions pending */
 
 	spinlock_t i_block_reservation_lock;
@@ -929,6 +927,9 @@ struct ext4_inode_info {
 	__u32 i_csum_seed;
 };
 
+/* current io_end structure for async DIO write */
+#define EXT4_CUR_AIO_DIO(inode) (inode)->i_private
+
 /*
  * File system states
  */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 10f0afd..e993879 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3644,7 +3644,7 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 {
 	int ret = 0;
 	int err = 0;
-	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
+	ext4_io_end_t *io = (ext4_io_end_t*) EXT4_CUR_AIO_DIO(inode);
 
 	ext_debug("ext4_ext_handle_uninitialized_extents: inode %lu, logical "
 		  "block %llu, max_blocks %u, flags %x, allocated %u\n",
@@ -3902,7 +3902,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0;
 	struct ext4_allocation_request ar;
-	ext4_io_end_t *io = EXT4_I(inode)->cur_aio_dio;
+	ext4_io_end_t *io = (ext4_io_end_t*) EXT4_CUR_AIO_DIO(inode);
 	ext4_lblk_t cluster_offset;
 
 	ext_debug("blocks %u/%u requested for inode %lu\n",
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d12d30e..202ae3f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3060,7 +3060,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		 * hook to the iocb.
  		 */
 		iocb->private = NULL;
-		EXT4_I(inode)->cur_aio_dio = NULL;
+		EXT4_CUR_AIO_DIO(inode) = NULL;
 		if (!is_sync_kiocb(iocb)) {
 			ext4_io_end_t *io_end =
 				ext4_init_io_end(inode, GFP_NOFS);
@@ -3077,7 +3077,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 			 * is a unwritten extents needs to be converted
 			 * when IO is completed.
 			 */
-			EXT4_I(inode)->cur_aio_dio = iocb->private;
+			EXT4_CUR_AIO_DIO(inode) = iocb->private;
 		}
 
 		if (overwrite)
@@ -3097,7 +3097,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 						 NULL,
 						 DIO_LOCKING);
 		if (iocb->private)
-			EXT4_I(inode)->cur_aio_dio = NULL;
+			EXT4_CUR_AIO_DIO(inode) = NULL;
 		/*
 		 * The io_end structure takes a reference to the inode,
 		 * that structure needs to be destroyed and the
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4a7092b..a6904b3 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -967,7 +967,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->jinode = NULL;
 	INIT_LIST_HEAD(&ei->i_completed_io_list);
 	spin_lock_init(&ei->i_completed_io_lock);
-	ei->cur_aio_dio = NULL;
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
-- 
1.7.7.6

