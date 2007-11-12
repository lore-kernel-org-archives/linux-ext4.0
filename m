From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH 2/2] FIEMAP ioctl for ext4
Date: Tue, 13 Nov 2007 02:30:06 +0530
Message-ID: <1194901206.12045.18.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andreas Dilger <adilger@Sun.COM>,
	Eric Sandeen <sandeen@redhat.com>, mark.fasheh@oracle.com,
	dgc@sgi.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Recently there was discussion about an "FIle Extent MAP"(FIEMAP) ioctl for efficiently mapping the extents and holes of a file. This will be many times more efficient than FIBMAP by cutting down the number of ioctls.

This patch adds the FIEMAP ioctl for ext4. The spec for the FIEMAP ioctl was posted earlier by Andreas Dilger and can be found at:
http://www.mail-archive.com/linux-ext4@vger.kernel.org/msg03944.html

Signed-off-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Kalpak Shah <kalpak.shah@sun.com> 

Index: linux-2.6.23.1/fs/ext4/ioctl.c
===================================================================
--- linux-2.6.23.1.orig/fs/ext4/ioctl.c
+++ linux-2.6.23.1/fs/ext4/ioctl.c
@@ -16,6 +16,7 @@
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include <asm/uaccess.h>
+#include <linux/fiemap.h>
 
 int ext4_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
 		unsigned long arg)
@@ -248,6 +249,9 @@ flags_err:
 
 		return err;
 	}
+	case EXT4_IOC_FIEMAP: {
+		return ext4_fiemap(inode, filp, cmd, arg);
+	}
 
 	default:
 		return -ENOTTY;
Index: linux-2.6.23.1/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/ext4_fs.h
+++ linux-2.6.23.1/include/linux/ext4_fs.h
@@ -228,15 +228,20 @@ struct ext4_new_group_data {
 #define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
 #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
 #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
+#define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
+#define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_GROUP_EXTEND		_IOW('f', 7, unsigned long)
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8,struct ext4_new_group_input)
+#define EXT4_IOC_FIEMAP			_IOWR('f', 10, struct fiemap)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
 #define	EXT4_IOC_SETVERSION_OLD		FS_IOC_SETVERSION
 #ifdef CONFIG_JBD2_DEBUG
 #define EXT4_IOC_WAIT_FOR_READONLY	_IOR('f', 99, long)
 #endif
-#define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
-#define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
+
+/* ext4 only handles a single LUN, ignore LUN_OFFSET flag */
+#define EXT4_FIEMAP_FLAG_INCOMPAT_UNSUPP (FIEMAP_FLAG_INCOMPAT &	\
+					  ~(FIEMAP_FLAG_LUN_OFFSET))
 
 /*
  * ioctl commands in 32 bit emulation
@@ -1067,6 +1072,8 @@ ext4_get_blocks_wrap(handle_t *handle, s
 	return ext4_get_blocks_handle(handle, inode, block, max_blocks, bh,
 					create, extend_disksize);
 }
+extern int ext4_fiemap(struct inode *inode, struct file *filp, unsigned int cmd,
+		       unsigned long arg);
 

 #endif	/* __KERNEL__ */
Index: linux-2.6.23.1/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.23.1.orig/include/linux/ext4_fs_extents.h
+++ linux-2.6.23.1/include/linux/ext4_fs_extents.h
@@ -131,8 +131,8 @@ struct ext4_ext_path {
  * callback must return valid extent (passed or newly created)
  */
 typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
-					struct ext4_ext_cache *,
-					void *);
+				    struct ext4_ext_cache *,
+				    struct ext4_extent *, void *);
 
 #define EXT_CONTINUE	0
 #define EXT_BREAK	1
Index: linux-2.6.23.1/fs/ext4/extents.c
===================================================================
--- linux-2.6.23.1.orig/fs/ext4/extents.c
+++ linux-2.6.23.1/fs/ext4/extents.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/falloc.h>
 #include <linux/ext4_fs_extents.h>
+#include <linux/fiemap.h>
 #include <asm/uaccess.h>
 

@@ -1512,7 +1513,7 @@ int ext4_ext_walk_space(struct inode *in
 		}
 
 		BUG_ON(cbex.ec_len == 0);
-		err = func(inode, path, &cbex, cbdata);
+		err = func(inode, path, &cbex, ex, cbdata);
 		ext4_ext_drop_refs(path);
 
 		if (err < 0)
@@ -2629,3 +2630,163 @@ retry:
 
 	return ret > 0 ? ret2 : ret;
 }
+
+struct fiemap_internal {
+	struct fiemap		*fiemap_s;
+	struct fiemap_extent	fm_extent;
+	size_t			tot_mapping_len;
+	char			*cur_ext_ptr;
+	int			current_extent;
+	int			err;
+};
+
+/*
+ * Callback function called for each extent to gather FIEMAP information.
+ */
+int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
+		       void *data)
+{
+	struct fiemap_internal *fiemap_i = data;
+	struct fiemap *fiemap_s = fiemap_i->fiemap_s;
+	struct fiemap_extent *fm_extent = &fiemap_i->fm_extent;
+	int current_extent = fiemap_i->current_extent;
+	unsigned long blksize_bits = inode->i_sb->s_blocksize_bits;
+
+	/*
+	 * ext4_ext_walk_space returns a hole for extents that have not been
+	 * allocated yet.
+	 */
+	if (((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+	     inode->i_size) && newex->ec_type == EXT4_EXT_CACHE_GAP) {
+		if (((u64)newex->ec_block << blksize_bits) < inode->i_size)
+			newex->ec_len = (inode->i_size - ((u64)newex->ec_block<<
+						blksize_bits)) >> blksize_bits;
+		else
+			return EXT_BREAK;
+	}
+
+	/*
+	 * We only need to return number of extents and total length of mapping
+	 */
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS) {
+		fiemap_i->tot_mapping_len += ((__u64)newex->ec_len <<
+						 blksize_bits);
+		goto count_extents;
+	}
+
+	if (current_extent >= fiemap_s->fm_extent_count)
+		return EXT_BREAK;
+
+	memset(fm_extent, 0, sizeof(*fm_extent));
+	fm_extent->fe_offset = (__u64)newex->ec_start << blksize_bits;
+	fm_extent->fe_length = (__u64)newex->ec_len << blksize_bits;
+	fiemap_i->tot_mapping_len += fm_extent->fe_length;
+
+	if (newex->ec_type == EXT4_EXT_CACHE_GAP)
+		fm_extent->fe_flags |= FIEMAP_EXTENT_HOLE;
+
+	if (ex && ext4_ext_is_uninitialized(ex))
+		fm_extent->fe_flags |= (FIEMAP_EXTENT_DELALLOC |
+					FIEMAP_EXTENT_UNMAPPED);
+
+	/*
+	 * Mark this fiemap_extent as FIEMAP_EXTENT_EOF if it's past the end
+	 * of file.
+	 */
+	if ((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+								inode->i_size)
+		fm_extent->fe_flags |= FIEMAP_EXTENT_EOF;
+
+	if (!copy_to_user(fiemap_i->cur_ext_ptr, fm_extent,
+			  sizeof(struct fiemap_extent))) {
+		fiemap_i->cur_ext_ptr += sizeof(struct fiemap_extent);
+	} else {
+		fiemap_i->err = -EFAULT;
+		return EXT_BREAK;
+	}
+
+count_extents:
+	/*
+	 * Don't count holes when only returning number of extents
+	 */
+	if (!((fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS) &&
+	      (newex->ec_type == EXT4_EXT_CACHE_GAP)))
+		fiemap_i->current_extent++;
+
+	/*
+	 * Stop if we are beyond requested mapping size but return complete last
+	 * extent.
+	 */
+	if ((u64)(newex->ec_block + newex->ec_len) << blksize_bits >=
+	    fiemap_s->fm_length)
+		return EXT_BREAK;
+
+	return EXT_CONTINUE;
+}
+
+int ext4_fiemap(struct inode *inode, struct file *filp, unsigned int cmd,
+		unsigned long arg)
+{
+	struct fiemap *fiemap_s;
+	struct fiemap_internal fiemap_i;
+	struct fiemap_extent *last_extent;
+	ext4_fsblk_t start_blk;
+	int fm_extent_size = sizeof(struct fiemap_extent);
+	int err = 0;
+
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+		return -EOPNOTSUPP;
+
+	fiemap_s = kmalloc(sizeof(*fiemap_s), GFP_KERNEL);
+	if (fiemap_s == NULL)
+		return -ENOMEM;
+	if (copy_from_user(fiemap_s, (struct fiemap __user *)arg,
+			   sizeof(*fiemap_s)))
+		return -EFAULT;
+
+	if (fiemap_s->fm_flags & EXT4_FIEMAP_FLAG_INCOMPAT_UNSUPP)
+		return -EOPNOTSUPP;
+
+	if (fiemap_s->fm_flags & FIEMAP_FLAG_SYNC)
+		ext4_sync_file(filp, filp->f_dentry, 1);
+
+	start_blk = fiemap_s->fm_start >> inode->i_sb->s_blocksize_bits;
+	fiemap_i.fiemap_s = fiemap_s;
+	fiemap_i.tot_mapping_len = 0;
+	fiemap_i.cur_ext_ptr = (char *)(arg + sizeof(*fiemap_s));
+	fiemap_i.current_extent = 0;
+	fiemap_i.err = 0;
+
+	/*
+	 * Walk the extent tree gathering extent information
+	 */
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	err = ext4_ext_walk_space(inode, start_blk , EXT_MAX_BLOCK - start_blk,
+				  ext4_ext_fiemap_cb, &fiemap_i);
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	if (err)
+		return err;
+
+	fiemap_s->fm_extent_count = fiemap_i.current_extent;
+	fiemap_s->fm_length = fiemap_i.tot_mapping_len;
+	/*
+	 * Mark last extent as EXTENT_LAST and copy the extent to userspace.
+	 */
+	if (fiemap_i.current_extent != 0 &&
+	    fiemap_i.current_extent < fiemap_s->fm_extent_count &&
+	    !(fiemap_s->fm_flags & FIEMAP_FLAG_NUM_EXTENTS)) {
+		char *dest;
+
+		last_extent = &fiemap_i.fm_extent;
+		last_extent->fe_flags |= FIEMAP_EXTENT_LAST;
+		dest = (char *)arg + sizeof(*fiemap_s) + fm_extent_size *
+						(fiemap_s->fm_extent_count - 1);
+		err = copy_to_user(dest, last_extent, fm_extent_size);
+		if (err)
+			return err;
+	}
+	err = copy_to_user((void *)arg, fiemap_s, sizeof(*fiemap_s));
+
+	return err;
+}


