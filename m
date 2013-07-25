From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 22/33] ext4: add support for read_iter and write_iter
Date: Thu, 25 Jul 2013 12:50:48 -0500
Message-ID: <1374774659-13121-23-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Maxim V. Patlasov" <mpatlasov@parallels.com>,
	Zach Brown <zab@zabbo.net>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

use the generic_file_read_iter(), create ext4_file_write_iter() based on
ext4_file_write(), and make ext4_file_write() a wrapper around
ext4_file_write_iter().

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext4/file.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6f4cc56..c25d48a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -74,12 +74,11 @@ void ext4_unwritten_wait(struct inode *inode)
  * or one thread will zero the other's data, causing corruption.
  */
 static int
-ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
-		   unsigned long nr_segs, loff_t pos)
+ext4_unaligned_aio(struct inode *inode, struct iov_iter *iter, loff_t pos)
 {
 	struct super_block *sb = inode->i_sb;
 	int blockmask = sb->s_blocksize - 1;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	loff_t final_size = pos + count;
 
 	if (pos >= inode->i_size)
@@ -92,8 +91,8 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
 }
 
 static ssize_t
-ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
-		    unsigned long nr_segs, loff_t pos)
+ext4_file_dio_write(struct kiocb *iocb, struct iov_iter *iter,
+		    loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -101,11 +100,11 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 	int unaligned_aio = 0;
 	ssize_t ret;
 	int overwrite = 0;
-	size_t length = iov_length(iov, nr_segs);
+	size_t length = iov_iter_count(iter);
 
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS) &&
 	    !is_sync_kiocb(iocb))
-		unaligned_aio = ext4_unaligned_aio(inode, iov, nr_segs, pos);
+		unaligned_aio = ext4_unaligned_aio(inode, iter, pos);
 
 	/* Unaligned direct AIO must be serialized; see comment above */
 	if (unaligned_aio) {
@@ -146,7 +145,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 			overwrite = 1;
 	}
 
-	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
+	ret = __generic_file_write_iter(iocb, iter, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0 || ret == -EIOCBQUEUED) {
@@ -165,8 +164,7 @@ ext4_file_dio_write(struct kiocb *iocb, const struct iovec *iov,
 }
 
 static ssize_t
-ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
-		unsigned long nr_segs, loff_t pos)
+ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t ret;
@@ -178,22 +176,24 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 
 	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 		struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-		size_t length = iov_length(iov, nr_segs);
+		size_t length = iov_iter_count(iter);
 
 		if ((pos > sbi->s_bitmap_maxbytes ||
 		    (pos == sbi->s_bitmap_maxbytes && length > 0)))
 			return -EFBIG;
 
 		if (pos + length > sbi->s_bitmap_maxbytes) {
-			nr_segs = iov_shorten((struct iovec *)iov, nr_segs,
-					      sbi->s_bitmap_maxbytes - pos);
+			ret = iov_iter_shorten(iter,
+					       sbi->s_bitmap_maxbytes - pos);
+			if (ret)
+				return ret;
 		}
 	}
 
 	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
-		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
+		ret = ext4_file_dio_write(iocb, iter, pos);
 	else
-		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
+		ret = generic_file_write_iter(iocb, iter, pos);
 
 	return ret;
 }
@@ -607,8 +607,8 @@ const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= ext4_file_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= ext4_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
-- 
1.8.3.4

