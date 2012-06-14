From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH v2 3/3] ext4: add dio overwrite nolock
Date: Thu, 14 Jun 2012 11:32:10 +0800
Message-ID: <1339644730-6204-4-git-send-email-wenqing.lz@taobao.com>
References: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Cc: Tao Ma <tm@tao.ma>, Eric Sandeen <sandeen@redhat.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37650 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNDYe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Jun 2012 23:24:34 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so3174066pbb.19
        for <linux-ext4@vger.kernel.org>; Wed, 13 Jun 2012 20:24:34 -0700 (PDT)
In-Reply-To: <1339644730-6204-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Aligned and overwrite direct I/O can be parallelized.  In ext4_file_dio_write,
we first check whether these conditions are satisfied or not.  If so, we
take i_data_sem and release i_mutex lock directly.  Meanwhile iocb->private is
set to indicate that this is a dio overwrite, and it will be handled in
ext4_ext_direct_IO.

CC: Tao Ma <tm@tao.ma>
CC: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/file.c  |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/ext4/inode.c |   27 +++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index a10dc77..812358f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -93,9 +93,13 @@ static ssize_t
 ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 		    unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_mapping->host;
+	struct blk_plug plug;
 	int unaligned_aio = 0;
 	ssize_t ret;
+	int overwrite = 0;
+	size_t length = iov_length(iov, nr_segs);
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
 	    !is_sync_kiocb(iocb))
@@ -115,7 +119,52 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 		ext4_aiodio_wait(inode);
 	}
 
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	BUG_ON(iocb->ki_pos != pos);
+
+	mutex_lock(&inode->i_mutex);
+	blk_start_plug(&plug);
+
+	iocb->private = &overwrite;
+
+	/* check whether we do a DIO overwrite or not */
+	if (ext4_should_dioread_nolock(inode) && !unaligned_aio &&
+	    !file->f_mapping->nrpages && pos + length <= i_size_read(inode)) {
+		struct ext4_map_blocks map;
+		unsigned int blkbits = inode->i_blkbits;
+		int err, len;
+
+		map.m_lblk = pos >> blkbits;
+		map.m_len = (EXT4_BLOCK_ALIGN(pos + length, blkbits) >> blkbits)
+			- map.m_lblk;
+		map.m_flags &= ~EXT4_MAP_FLAGS;
+		len = map.m_len;
+
+		err = ext4_map_blocks(NULL, inode, &map, 0);
+		/*
+		 * 'err==len' means that all of blocks has been preallocated no
+		 * matter they are initialized or not.  For excluding
+		 * uninitialized extents, we need to check m_flags.  There are
+		 * two conditions that indicate for initialized extents.
+		 * 1) If we hit extent cache, EXT4_MAP_MAPPED flag is returned;
+		 * 2) If we do a real lookup, non-flags are returned.
+		 * So we should check these two conditions.
+		 */
+		if (err == len && (!map.m_flags ||
+				   map.m_flags & EXT4_MAP_MAPPED))
+			overwrite = 1;
+	}
+
+	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+	mutex_unlock(&inode->i_mutex);
+
+	if (ret > 0 || ret == -EIOCBQUEUED) {
+		ssize_t err;
+
+		err = generic_write_sync(file, pos, ret);
+		if (err < 0 && ret > 0)
+			ret = err;
+	}
+	blk_finish_plug(&plug);
 
 	if (unaligned_aio)
 		mutex_unlock(ext4_aio_mutex(inode));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9a714ff..98e9096 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2996,6 +2996,26 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	if (rw == WRITE && final_size <= inode->i_size) {
 		int overwrite = 0;
 
+		BUG_ON(iocb->private == NULL);
+
+		/* If we do a overwrite dio, i_mutex locking can be released */
+		overwrite = *((int *)iocb->private);
+
+		if (overwrite) {
+			down_read(&EXT4_I(inode)->i_data_sem);
+			mutex_unlock(&inode->i_mutex);
+		}
+
+		/*
+		 * If there are still some buffered I/O, we should fall back
+		 * to take i_mutex locking.
+		 */
+		if (overwrite && file->f_mapping->nrpages) {
+			overwrite = 0;
+			up_read(&EXT4_I(inode)->i_data_sem);
+			mutex_lock(&inode->i_mutex);
+		}
+
 		/*
  		 * We could direct write to holes and fallocate.
 		 *
@@ -3083,6 +3103,13 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 				ret = err;
 			ext4_clear_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN);
 		}
+
+		/* take i_mutex locking again if we do a ovewrite dio */
+		if (overwrite) {
+			up_read(&EXT4_I(inode)->i_data_sem);
+			mutex_lock(&inode->i_mutex);
+		}
+
 		return ret;
 	}
 
-- 
1.7.4.1

