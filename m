From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 7/8] ext4: Count all requests in direct io
Date: Thu, 10 Nov 2011 18:34:53 +0800
Message-ID: <1320921294-30321-8-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

ext4_ios_submit_io() function is defined to be called by __blockdev_direct_IO()
to count direct io.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/ext4.h     |    2 ++
 fs/ext4/indirect.c |    2 +-
 fs/ext4/inode.c    |   12 +++++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 39a1495..68032e9 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1916,6 +1916,8 @@ extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
 					int used, int quota_claim);
+extern void ext4_ios_submit_io(int rw, struct bio *bio,
+			       struct inode *inode, loff_t file_offset);
 
 /* indirect.c */
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 0d7174e..a27bb19 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -819,7 +819,7 @@ retry:
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+				 ext4_get_block, NULL, ext4_ios_submit_io, 0);
 	} else {
 		ret = blockdev_direct_IO(rw, iocb, inode, iov,
 				 offset, nr_segs, ext4_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e552fb2..600a742 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2962,7 +2962,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 					 offset, nr_segs,
 					 ext4_get_block_write,
 					 ext4_end_io_dio,
-					 NULL,
+					 ext4_ios_submit_io,
 					 DIO_LOCKING | DIO_SKIP_HOLES);
 		if (iocb->private)
 			EXT4_I(inode)->cur_aio_dio = NULL;
@@ -3003,6 +3003,16 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
 }
 
+void ext4_ios_submit_io(int rw, struct bio *bio,
+			struct inode *inode, loff_t file_offset)
+{
+	int tmprw = !!rw;
+
+	/* ext4 io type statistic */
+	__ext4_io_stat(tmprw, EXT4_IOS_REGULAR_DATA, ext4_blocks_per_page(inode));
+	submit_bio(rw, bio);
+}
+
 static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 			      const struct iovec *iov, loff_t offset,
 			      unsigned long nr_segs)
-- 
1.7.4.1

