From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext2: Report metadata errors during fsync
Date: Wed, 25 Nov 2009 11:24:53 +0100
Message-ID: <1259144693-6732-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, tytso@mit.edu,
	chris.mason@oracle.com, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602AbZKYKZX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 05:25:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When an IO error happens while writing metadata buffers, we should better
report it and call ext2_error since the filesystem is probably no longer
consistent. Sometimes such IO errors happen while flushing thread does
background writeback, the buffer gets later evicted from memory, and thus
the only trace of the error remains as AS_EIO bit set in blockdevice's
mapping. So we check this bit in ext2_fsync and report the error although
we cannot be really sure which buffer we failed to write.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/dir.c  |    2 +-
 fs/ext2/ext2.h |    1 +
 fs/ext2/file.c |   21 +++++++++++++++++++--
 3 files changed, 21 insertions(+), 3 deletions(-)

  Guys, what do you think about the patch below? We carried something similar
in SUSE kernels for quite some time (the original patch was by Chris Mason) -
I've just now got to porting it to current kernel. If nobody objects, I'd
merge the patch...

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 6cde970..545eb42 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -721,5 +721,5 @@ const struct file_operations ext2_dir_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 9a8a8e2..aff22e0 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -155,6 +155,7 @@ extern void ext2_write_super (struct super_block *);
 extern const struct file_operations ext2_dir_operations;
 
 /* file.c */
+extern int ext2_fsync(struct file *file, struct dentry *dentry, int datasync);
 extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 extern const struct file_operations ext2_xip_file_operations;
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index a2f3afd..586e358 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/time.h>
+#include <linux/pagemap.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -38,6 +39,22 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+int ext2_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int ret;
+	struct super_block *sb = dentry->d_inode->i_sb;
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+
+	ret = simple_fsync(file, dentry, datasync);
+	if (ret == -EIO || test_and_clear_bit(AS_EIO, &mapping->flags)) {
+		/* We don't really know where the IO error happened... */
+		ext2_error(sb, __func__,
+			   "detected IO error when writing metadata buffers");
+		ret = -EIO;
+	}
+	return ret;
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ext2 filesystem.
@@ -55,7 +72,7 @@ const struct file_operations ext2_file_operations = {
 	.mmap		= generic_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 };
@@ -72,7 +89,7 @@ const struct file_operations ext2_xip_file_operations = {
 	.mmap		= xip_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
-	.fsync		= simple_fsync,
+	.fsync		= ext2_fsync,
 };
 #endif
 
-- 
1.6.4.2

