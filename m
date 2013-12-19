From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3 0/3] Add XIP support to ext4
Date: Wed, 18 Dec 2013 18:05:31 -0700
Message-ID: <20131219010530.GA17545@parisc-linux.org>
References: <cover.1387307259.git.matthew.r.wilcox@intel.com> <20131217223050.GB20579@dastard> <20131218023143.GA24491@parisc-linux.org> <20131218123319.GH31386@dastard> <20131218152234.GB9207@parisc-linux.org> <20131219004831.GU31386@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131219004831.GU31386@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 19, 2013 at 11:48:31AM +1100, Dave Chinner wrote:
> We already have a model for handling non page cache based IO paths:
> Direct IO has to handle this read/truncate race condition without
> page lock serialisation, and it works just fine. Go and look at
> inode_dio_wait() rather than reinventing the wheel.

I've spent most of today looking at that code.  Here's where I'm at
right now.  It doesn't even compile.

diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
index 18b34d2..29be737 100644
--- a/fs/ext2/xip.h
+++ b/fs/ext2/xip.h
@@ -16,9 +16,7 @@ static inline int ext2_use_xip (struct super_block *sb)
 }
 int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
 				void **, unsigned long *);
-#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
 #else
-#define mapping_is_xip(map)			0
 #define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
 #define ext2_clear_xip_target(inode, chain)	0
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b9499b2..66d2b35 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -190,7 +190,8 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT))
+	if (unlikely(iocb->ki_filp->f_flags & O_DIRECT) ||
+	    (mapping_is_xip(inode->i_mapping)))
 		ret = ext4_file_dio_write(iocb, iov, nr_segs, pos);
 	else
 		ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
@@ -612,8 +613,10 @@ const struct file_operations ext4_file_operations = {
 #ifdef CONFIG_EXT4_FS_XIP
 const struct file_operations ext4_xip_file_operations = {
 	.llseek		= ext4_llseek,
-	.read		= xip_file_read,
-	.write		= xip_file_write,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= ext4_file_write,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext4_compat_ioctl,
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 594009f..ae760d9 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -686,15 +686,22 @@ retry:
 			inode_dio_done(inode);
 			goto locked;
 		}
-		ret = __blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+		if (mapping_is_xip(file->f_mapping))
+			ret = xip_io(rw, iocb, inode, iov, offset, nr_segs,
+					ext4_get_block, NULL, 0);
+		else
+			ret = __blockdev_direct_IO(rw, iocb, inode,
+					inode->i_sb->s_bdev, iov, offset,
+					nr_segs, ext4_get_block, NULL, NULL, 0);
 		inode_dio_done(inode);
 	} else {
 locked:
-		ret = blockdev_direct_IO(rw, iocb, inode, iov,
-				 offset, nr_segs, ext4_get_block);
+		if (mapping_is_xip(file->f_mapping))
+			ret = xip_io(rw, iocb, inode, iov, offset, nr_segs,
+					ext4_get_block, NULL, 0);
+		else
+			ret = blockdev_direct_IO(rw, iocb, inode, iov,
+					offset, nr_segs, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7b50832..0303412 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3170,13 +3170,14 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		get_block_func = ext4_get_block_write;
 		dio_flags = DIO_LOCKING;
 	}
-	ret = __blockdev_direct_IO(rw, iocb, inode,
-				   inode->i_sb->s_bdev, iov,
-				   offset, nr_segs,
-				   get_block_func,
-				   ext4_end_io_dio,
-				   NULL,
-				   dio_flags);
+	if (mapping_is_xip(file->f_mapping))
+		ret = xip_io(rw, iocb, inode, iov, offset, nr_segs,
+			     get_block_func, ext4_end_io_dio, dio_flags);
+	else
+		ret = __blockdev_direct_IO(rw, iocb, inode,
+					   inode->i_sb->s_bdev, iov, offset,
+					   nr_segs, get_block_func,
+					   ext4_end_io_dio, NULL, dio_flags);
 
 	/*
 	 * Put our reference to io_end. This can free the io_end structure e.g.
@@ -3291,6 +3292,7 @@ static const struct address_space_operations ext4_aops = {
 const struct address_space_operations ext4_xip_aops = {
 	.bmap			= ext4_bmap,
 	.get_xip_mem		= ext4_get_xip_mem,
+	.direct_IO		= ext4_direct_IO,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
diff --git a/fs/ext4/xip.h b/fs/ext4/xip.h
index af0d553..b279dae 100644
--- a/fs/ext4/xip.h
+++ b/fs/ext4/xip.h
@@ -15,9 +15,7 @@ static inline int ext4_use_xip(struct super_block *sb)
 }
 int ext4_get_xip_mem(struct address_space *, pgoff_t, int,
 				void **, unsigned long *);
-#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
 #else
-#define mapping_is_xip(map)			0
 #define ext4_use_xip(sb)			0
 #define ext4_clear_xip_target(inode, chain)	0
 #define ext4_get_xip_mem			NULL
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a063bff..94a8e50 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2511,6 +2511,14 @@ extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);
 extern int xip_zero_page_range(struct address_space *, loff_t from,
 			       unsigned length);
+extern ssize_t xip_io(int rw, struct kiocb *, struct inode *,
+			const struct iovec *, loff_t, unsigned segs,
+			get_block_t, dio_iodone_t, int flags);
+
+static inline bool mapping_is_xip(struct address_space *mapping)
+{
+	return mapping->a_ops->get_xip_mem != NULL;
+}
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 {
@@ -2522,6 +2530,18 @@ static inline int xip_zero_page_range(struct address_space *mapping,
 {
 	return 0;
 }
+
+static inline bool mapping_is_xip(struct address_space *mapping)
+{
+	return false;
+}
+
+static inline ssize_t xip_io(int rw, struct kiocb *iocb, struct inode *inode,
+		const struct iovec *iov, loff_t offset, unsigned nr_segs,
+		get_block_t get_block, dio_iodone_t end_io, int flags)
+{
+	return -ENOTTY;
+}
 #endif
 
 #ifdef CONFIG_BLOCK
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index d808b72..38caad3 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -8,6 +8,7 @@
  *
  */
 
+#include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/export.h>
@@ -41,6 +42,103 @@ static struct page *xip_sparse_page(void)
 	return __xip_sparse_page;
 }
 
+static ssize_t __xip_io(int rw, struct inode *inode, const struct iovec *iov,
+		loff_t offset, loff_t end, unsigned nr_segs,
+		get_block_t get_block, struct buffer_head *bh)
+{
+	ssize_t retval;
+	unsigned seg = 0;
+	unsigned len;
+	unsigned copied = 0;
+	loff_t max = offset;
+
+	while (offset < end) {
+		void __user *buf = iov[seg].iov_base + copied;
+		bool hole;
+
+		if (max == offset) {
+			sector_t block = offset >> inode->i_blkbits;
+			memset(bh, 0, sizeof(*bh));
+			bh->b_size = ALIGN(end - offset, PAGE_SIZE);
+			retval = get_block(inode, block, bh, 0);
+			if (retval)
+				break;
+			if (buffer_mapped(bh))
+				hole = false;
+			else
+				hole = true;
+			if (rw == WRITE && hole) {
+				bh->b_size = ALIGN(end - offset, PAGE_SIZE);
+				retval = get_block(inode, block, bh, 1);
+				if (retval)
+					break;
+			} 
+			max = offset + bh->b_size;
+		}
+
+		len = min_t(unsigned, iov[seg].iov_len - copied, max - offset);
+
+		if (rw == WRITE)
+			len -= __copy_from_user_nocache(addr, buf, len);
+		else if (!hole)
+			len -= __copy_to_user(buf, addr, len);
+		else
+			len -= __clear_user(buf, len);
+
+		offset += len;
+		copied += len;
+		if (copied == iov[seg].iov_len) {
+			seg++;
+			copied = 0;
+		}
+	}
+
+	return retval;
+}
+
+/*
+ * Perform I/O to an XIP file.  We follow the same rules as
+ * __blockdev_direct_IO with respect to locking
+ */
+ssize_t xip_io(int rw, struct kiocb *iocb, struct inode *inode,
+		const struct iovec *iov, loff_t offset, unsigned nr_segs,
+		get_block_t get_block, dio_iodone_t end_io, int flags)
+{
+	struct buffer_head bh;
+	unsigned seg;
+	ssize_t retval = -EINVAL;
+	loff_t end = offset;
+
+	for (seg = 0; seg < nr_segs; seg++)
+		end += iov[seg].iov_len;
+
+	if ((flags & DIO_LOCKING) && (rw == READ)) {
+		struct address_space *mapping = inode->i_mapping;
+		mutex_lock(&inode->i_mutex);
+		retval = filemap_write_and_wait_range(mapping, offset, end - 1);
+		if (retval) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
+
+	/* Protects against truncate */
+	atomic_inc(&inode->i_dio_count);
+
+	retval = __xip_io(rw, inode, iov, offset, end, nr_segs, get_block, &bh);
+
+	if ((flags & DIO_LOCKING) && (rw == READ))
+		mutex_unlock(&inode->i_mutex);
+
+	inode_dio_done(inode);
+
+	if (end_io)
+		end_io(iocb, offset, transferred, bh.b_private);
+ out:
+	return retval;
+}
+EXPORT_SYMBOL_GPL(xip_io);
+
 /*
  * This is a file read routine for execute in place files, and uses
  * the mapping->a_ops->get_xip_mem() function for the actual low-level

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
