From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 03/16] ext4: use is_xxx_kiocb instead  of filp->fl_flags
Date: Sat,  4 Apr 2015 23:13:12 +0400
Message-ID: <1428174805-853-4-git-send-email-dmonakhov@openvz.org>
References: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1428174805-853-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Cc: linux-ext4@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/file.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 598abbb..27cf1cc 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -95,7 +95,6 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct mutex *aio_mutex = NULL;
 	struct blk_plug plug;
-	int o_direct = io_is_direct(file);
 	int overwrite = 0;
 	size_t length = iov_iter_count(from);
 	ssize_t ret;
@@ -105,18 +104,17 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	 * Unaligned direct AIO must be serialized; see comment above
 	 * In the case of O_APPEND, assume that we must always serialize
 	 */
-	if (o_direct &&
+	if (is_direct_kiocb(iocb) &&
 	    ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
 	    !is_sync_kiocb(iocb) &&
-	    (file->f_flags & O_APPEND ||
-	     ext4_unaligned_aio(inode, from, pos))) {
+	    (is_append_kiocb(iocb) || ext4_unaligned_aio(inode, from, pos))) {
 		aio_mutex = ext4_aio_mutex(inode);
 		mutex_lock(aio_mutex);
 		ext4_unwritten_wait(inode);
 	}
 
 	mutex_lock(&inode->i_mutex);
-	if (file->f_flags & O_APPEND)
+	if (is_append_kiocb(iocb))
 		iocb->ki_pos = pos = i_size_read(inode);
 
 	/*
@@ -138,7 +136,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	iocb->private = &overwrite;
-	if (o_direct) {
+	if (is_direct_kiocb(iocb)) {
 		blk_start_plug(&plug);
 
 
@@ -182,7 +180,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (err < 0)
 			ret = err;
 	}
-	if (o_direct)
+	if (is_direct_kiocb(iocb))
 		blk_finish_plug(&plug);
 
 errout:
-- 
1.7.1

