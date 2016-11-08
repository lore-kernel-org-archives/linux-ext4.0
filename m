From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/11] ext4: Convert DAX reads to iomap infrastructure
Date: Tue,  8 Nov 2016 12:08:09 +0100
Message-ID: <1478603297-11793-4-git-send-email-jack@suse.cz>
References: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbcKHLKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:04 -0500
In-Reply-To: <1478603297-11793-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement basic iomap_begin function that handles reading and use it for
DAX reads.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |  2 ++
 fs/ext4/file.c  | 38 +++++++++++++++++++++++++++++++++++++-
 fs/ext4/inode.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 282a51b07c57..098b39910001 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3271,6 +3271,8 @@ static inline bool ext4_aligned_io(struct inode *inode, loff_t off, loff_t len)
 	return IS_ALIGNED(off, blksize) && IS_ALIGNED(len, blksize);
 }
 
+extern struct iomap_ops ext4_iomap_ops;
+
 #endif	/* __KERNEL__ */
 
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 9facb4dc5c70..1f25c644cb12 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -31,6 +31,42 @@
 #include "xattr.h"
 #include "acl.h"
 
+#ifdef CONFIG_FS_DAX
+static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+
+	inode_lock_shared(inode);
+	/*
+	 * Recheck under inode lock - at this point we are sure it cannot
+	 * change anymore
+	 */
+	if (!IS_DAX(inode)) {
+		inode_unlock_shared(inode);
+		/* Fallback to buffered IO in case we cannot support DAX */
+		return generic_file_read_iter(iocb, to);
+	}
+	ret = dax_iomap_rw(iocb, to, &ext4_iomap_ops);
+	inode_unlock_shared(inode);
+
+	file_accessed(iocb->ki_filp);
+	return ret;
+}
+#endif
+
+static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	if (!iov_iter_count(to))
+		return 0; /* skip atime */
+
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(file_inode(iocb->ki_filp)))
+		return ext4_dax_read_iter(iocb, to);
+#endif
+	return generic_file_read_iter(iocb, to);
+}
+
 /*
  * Called when an inode is released. Note that this is different
  * from ext4_file_open: open gets called at every open, but release
@@ -690,7 +726,7 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
-	.read_iter	= generic_file_read_iter,
+	.read_iter	= ext4_file_read_iter,
 	.write_iter	= ext4_file_write_iter,
 	.unlocked_ioctl = ext4_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5337828c68a7..83e8411370d3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
+#include <linux/iomap.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -3310,6 +3311,59 @@ int ext4_dax_get_block(struct inode *inode, sector_t iblock,
 	clear_buffer_new(bh_result);
 	return 0;
 }
+
+static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+			    unsigned flags, struct iomap *iomap)
+{
+	unsigned int blkbits = inode->i_blkbits;
+	unsigned long first_block = offset >> blkbits;
+	unsigned long last_block = (offset + length - 1) >> blkbits;
+	struct ext4_map_blocks map;
+	int ret;
+
+	if (flags & IOMAP_WRITE)
+		return -EIO;
+
+	if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
+		return -ERANGE;
+
+	map.m_lblk = first_block;
+	map.m_len = last_block - first_block + 1;
+
+	ret = ext4_map_blocks(NULL, inode, &map, 0);
+	if (ret < 0)
+		return ret;
+
+	iomap->flags = 0;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->offset = first_block << blkbits;
+
+	if (ret == 0) {
+		iomap->type = IOMAP_HOLE;
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->length = (u64)map.m_len << blkbits;
+	} else {
+		if (map.m_flags & EXT4_MAP_MAPPED) {
+			iomap->type = IOMAP_MAPPED;
+		} else if (map.m_flags & EXT4_MAP_UNWRITTEN) {
+			iomap->type = IOMAP_UNWRITTEN;
+		} else {
+			WARN_ON_ONCE(1);
+			return -EIO;
+		}
+		iomap->blkno = (sector_t)map.m_pblk << (blkbits - 9);
+		iomap->length = (u64)map.m_len << blkbits;
+	}
+
+	if (map.m_flags & EXT4_MAP_NEW)
+		iomap->flags |= IOMAP_F_NEW;
+	return 0;
+}
+
+struct iomap_ops ext4_iomap_ops = {
+	.iomap_begin		= ext4_iomap_begin,
+};
+
 #else
 /* Just define empty function, it will never get called. */
 int ext4_dax_get_block(struct inode *inode, sector_t iblock,
-- 
2.6.6

