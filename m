From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH v2 1/3] ext4: split ext4_file_write into buffered IO and direct IO
Date: Thu, 14 Jun 2012 11:32:08 +0800
Message-ID: <1339644730-6204-2-git-send-email-wenqing.lz@taobao.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Cc: Tao Ma <tm@tao.ma>, Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64546 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNDYa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 23:24:30 -0400
Received: by dady13 with SMTP id y13so1935499dad.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 20:24:30 -0700 (PDT)
In-Reply-To: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ext4_file_dio_write is defined in order to split buffered IO and
direct IO in ext4.  This patch just refactor some stuff in write path.

CC: Tao Ma <tm@tao.ma>
CC: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/file.c |   60 +++++++++++++++++++++++++++++++++++--------------------
 1 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 8c7642a..a10dc77 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -90,34 +90,16 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 }
 
 static ssize_t
-ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos)
+ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
+		    unsigned long nr_segs, loff_t pos)
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
 	int unaligned_aio = 0;
 	ssize_t ret;
 
-	/*
-	 * If we have encountered a bitmap-format file, the size limit
-	 * is smaller than s_maxbytes, which is for extent-mapped files.
-	 */
-
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
-		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-		size_t length = iov_length(iov, nr_segs);
-
-		if ((pos > sbi->s_bitmap_maxbytes ||
-		    (pos == sbi->s_bitmap_maxbytes && length > 0)))
-			return -EFBIG;
-
-		if (pos + length > sbi->s_bitmap_maxbytes) {
-			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
-					      sbi->s_bitmap_maxbytes - pos);
-		}
-	} else if (unlikely((iocb->ki_filp->f_flags & O_DIRECT) &&
-		   !is_sync_kiocb(iocb))) {
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
+	    !is_sync_kiocb(iocb))
 		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
-	}
 
 	/* Unaligned direct AIO must be serialized; see comment above */
 	if (unaligned_aio) {
@@ -141,6 +123,40 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 	return ret;
 }
 
+static ssize_t
+ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
+		unsigned long nr_segs, loff_t pos)
+{
+	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	ssize_t ret;
+
+	/*
+	 * If we have encountered a bitmap-format file, the size limit
+	 * is smaller than s_maxbytes, which is for extent-mapped files.
+	 */
+
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
+		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+		size_t length = iov_length(iov, nr_segs);
+
+		if ((pos > sbi->s_bitmap_maxbytes ||
+		    (pos == sbi->s_bitmap_maxbytes && length > 0)))
+			return -EFBIG;
+
+		if (pos + length > sbi->s_bitmap_maxbytes) {
+			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
+					      sbi->s_bitmap_maxbytes - pos);
+		}
+	}
+
+	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
+		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
+	else
+		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+
+	return ret;
+}
+
 static const struct vm_operations_struct ext4_file_vm_ops = {
 	.fault		= filemap_fault,
 	.page_mkwrite   = ext4_page_mkwrite,
-- 
1.7.4.1

