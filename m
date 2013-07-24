From: Dhaval Giani <dgiani@mozilla.com>
Subject: [RFC/PATCH 2/2] Add rudimentary transparent decompression support
 to ext4
Date: Wed, 24 Jul 2013 17:03:47 -0400
Message-ID: <1374699827.7083.1.camel@localhost>
References: <cover.1374693578.git.dgiani@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, tglek@mozilla.com, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1374693578.git.dgiani@mozilla.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Adds basic support for transparently reading compressed
files in ext4.

Lots of issues in this patch
1. It requires a fully read file from disk, no seeking allowed
2. Compressed files give their compressed sizes and not uncompressed
sizes. Therefore cat will return truncated data (since the buffer
isn't big enough)
3. It adds a new file operation. That will be *removed*.
4. Doesn't mmap decompressed data

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Vladan Djeric <vdjeric@mozilla.com>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Mike Hommey <glandium@mozilla.com>
Signed-off-by: Dhaval Giani <dgiani@mozilla.com>
---
 fs/ext4/file.c     | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/read_write.c    |  3 +++
 include/linux/fs.h |  1 +
 3 files changed, 70 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index b1b4d51..5c9db04 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -31,6 +31,9 @@
 #include "xattr.h"
 #include "acl.h"
 
+#include <linux/zlib.h>
+#include <linux/szip.h>
+
 /*
  * Called when an inode is released. Note that this is different
  * from ext4_file_open: open gets called at every open, but release
@@ -623,6 +626,68 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 	return -EINVAL;
 }
 
+static int ext4_is_file_compressed(struct file *file)
+{
+	struct inode *inode = file->f_mapping->host;
+	return ext4_test_inode_flag(inode, EXT4_INODE_COMPR);
+}
+
+static int _ext4_decompress(char __user *buf, int sz)
+{
+	/*
+	 * We can really cheat here since we have the full buffer already read
+	 * and made available
+	 */
+	struct szip_struct szip;
+	char *temp;
+	size_t uncom_size;
+
+	int ret = szip_init(&szip, buf);
+	if (ret) {
+		ret = -1;
+		goto out;
+	}
+
+	uncom_size = szip_uncompressed_size(&szip);
+	temp = kmalloc(uncom_size, GFP_NOFS);
+	if (!temp) {
+		ret = -2;
+		goto out;
+	}
+
+	ret = szip_decompress(&szip, temp, 0);
+	if (ret) {
+		ret = -3;
+		goto out_free;
+	}
+
+	sz = min_t(int, sz, uncom_size);
+
+	memset(buf, 0, sz);
+	memcpy(buf, temp, sz);
+out_free:
+	kfree(temp);
+
+out:
+	return ret;
+
+}
+
+int ext4_decompress(struct file *file, char __user *buf, size_t len)
+{
+	int ret = 0;
+
+	if (!ext4_is_file_compressed(file))
+		return 0;
+
+	ret = _ext4_decompress(buf, len);
+	if (ret) {
+		goto out;
+	}
+out:
+	return ret;
+}
+
 const struct file_operations ext4_file_operations = {
 	.llseek		= ext4_llseek,
 	.read		= do_sync_read,
@@ -640,6 +705,7 @@ const struct file_operations ext4_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
 	.fallocate	= ext4_fallocate,
+	.decompress	= ext4_decompress,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
diff --git a/fs/read_write.c b/fs/read_write.c
index 2cefa41..44d2523 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -330,6 +330,7 @@ int rw_verify_area(int read_write, struct file *file, loff_t *ppos, size_t count
 	return count > MAX_RW_COUNT ? MAX_RW_COUNT : count;
 }
 
+
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = buf, .iov_len = len };
@@ -345,6 +346,8 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
+	if (filp->f_op->decompress)
+		filp->f_op->decompress(filp, buf, len);
 	return ret;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 65c2be2..ce43e82 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1543,6 +1543,7 @@ struct file_operations {
 	long (*fallocate)(struct file *file, int mode, loff_t offset,
 			  loff_t len);
 	int (*show_fdinfo)(struct seq_file *m, struct file *f);
+	int (*decompress)(struct file *, char *, size_t);
 };
 
 struct inode_operations {
-- 
1.8.1.4
