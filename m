From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC2] vfs: teach llseek about custom EOF values
Date: Wed, 25 Apr 2012 14:29:14 -0500
Message-ID: <4F98508A.2040506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab2DYT3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Apr 2012 15:29:15 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3PJTFhc010358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Apr 2012 15:29:15 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q3PJTE0V018693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 25 Apr 2012 15:29:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a pretty-much untested patch which lets ext4 tell the vfs
llseek code that when someone goes to SEEK_END on a dx dir, they should
go out to the max hash value, not to i_size.  It also contains changes
to ext4_dir_llseek (from what is upstream) to send the appropriate
max size for dx, non-dx, extent, non-extent, 32-bit, and 64-bit
systems.  (!)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This patch is mutually exclusive to the "remove ext4_dir_llseek"
patch, of course)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b867862..1ac06f3 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -312,9 +312,12 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
 
 
 /*
- * ext4_dir_llseek() based on generic_file_llseek() to handle both
- * non-htree and htree directories, where the "offset" is in terms
- * of the filename hash value instead of the byte offset.
+ * ext4_dir_llseek() uses generic_file_llseek() routines.
+ * This handles both non-htree and htree directories, where the "offset"
+ * is in terms of the filename hash value instead of the byte offset.
+ *
+ * For htree/dx dirs, the max offset and SEEK_END are both at
+ * ext4_get_htree_eof.
  *
  * NOTE: offsets obtained *before* ext4_set_inode_flag(dir, EXT4_INODE_INDEX)
  *       will be invalid once the directory was converted into a dx directory
@@ -322,64 +325,23 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
 loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
-	loff_t ret = -EINVAL;
 	int dx_dir = is_dx_dir(inode);
 
-	mutex_lock(&inode->i_mutex);
-
-	/* NOTE: relative offsets with dx directories might not work
-	 *       as expected, as it is difficult to figure out the
-	 *       correct offset between dx hashes */
+	if (dx_dir) {
+		loff_t htree_max = ext4_get_htree_eof(file);
 
-	switch (origin) {
-	case SEEK_END:
-		if (unlikely(offset > 0))
-			goto out_err; /* not supported for directories */
+		return generic_file_llseek_size_eof(file, offset, origin,
+				htree_max, htree_max); 
+	} else {
+		loff_t maxsize;
 
-		/* so only negative offsets are left, does that have a
-		 * meaning for directories at all? */
-		if (dx_dir)
-			offset += ext4_get_htree_eof(file);
+		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
+			maxsize= EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
 		else
-			offset += inode->i_size;
-		break;
-	case SEEK_CUR:
-		/*
-		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
-		 * position-querying operation.  Avoid rewriting the "same"
-		 * f_pos value back to the file because a concurrent read(),
-		 * write() or lseek() might have altered it
-		 */
-		if (offset == 0) {
-			offset = file->f_pos;
-			goto out_ok;
-		}
-
-		offset += file->f_pos;
-		break;
-	}
-
-	if (unlikely(offset < 0))
-		goto out_err;
-
-	if (!dx_dir) {
-		if (offset > inode->i_sb->s_maxbytes)
-			goto out_err;
-	} else if (offset > ext4_get_htree_eof(file))
-		goto out_err;
+			maxsize= inode->i_sb->s_maxbytes;
 
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
+		return generic_file_llseek_size(file, offset, origin, maxsize);
 	}
-
-out_ok:
-	ret = offset;
-out_err:
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
 }
 
 /*
diff --git a/fs/read_write.c b/fs/read_write.c
index ffc99d2..f67c3b7 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -51,14 +51,15 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
 }
 
 /**
- * generic_file_llseek_size - generic llseek implementation for regular files
+ * generic_file_llseek_size_eof - generic llseek implementation for regular files
  * @file:	file structure to seek on
  * @offset:	file offset to seek to
  * @origin:	type of seek
  * @size:	max size of file system
+ * @eof:	if > 0, use for SEEK_END position other than i_size_read()
  *
  * This is a variant of generic_file_llseek that allows passing in a custom
- * file size.
+ * file size and a custom EOF position.
  *
  * Synchronization:
  * SEEK_SET and SEEK_END are unsynchronized (but atomic on 64bit platforms)
@@ -66,14 +67,17 @@ static loff_t lseek_execute(struct file *file, struct inode *inode,
  * read/writes behave like SEEK_SET against seeks.
  */
 loff_t
-generic_file_llseek_size(struct file *file, loff_t offset, int origin,
-		loff_t maxsize)
+generic_file_llseek_size_eof(struct file *file, loff_t offset, int origin,
+		loff_t maxsize, loff_t eof)
 {
 	struct inode *inode = file->f_mapping->host;
 
+	if (!eof)
+		eof = i_size_read(inode);
+
 	switch (origin) {
 	case SEEK_END:
-		offset += i_size_read(inode);
+		offset += eof;
 		break;
 	case SEEK_CUR:
 		/*
@@ -99,7 +103,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
 		 * In the generic case the entire file is data, so as long as
 		 * offset isn't at the end of the file then the offset is data.
 		 */
-		if (offset >= i_size_read(inode))
+		if (offset >= eof)
 			return -ENXIO;
 		break;
 	case SEEK_HOLE:
@@ -107,14 +111,32 @@ generic_file_llseek_size(struct file *file, loff_t offset, int origin,
 		 * There is a virtual hole at the end of the file, so as long as
 		 * offset isn't i_size or larger, return i_size.
 		 */
-		if (offset >= i_size_read(inode))
+		if (offset >= eof)
 			return -ENXIO;
-		offset = i_size_read(inode);
+		offset = eof;
 		break;
 	}
 
 	return lseek_execute(file, inode, offset, maxsize);
 }
+EXPORT_SYMBOL(generic_file_llseek_size_eof);
+
+/**
+ * generic_file_llseek_size - generic llseek implementation for regular files
+ * @file:	file structure to seek on
+ * @offset:	file offset to seek to
+ * @origin:	type of seek
+ * @size:	max size of file system
+ *
+ * This is a variant of generic_file_llseek that allows passing in a custom
+ * file size.
+ */
+loff_t
+generic_file_llseek_size(struct file *file, loff_t offset, int origin,
+		loff_t maxsize)
+{
+	return generic_file_llseek_size(file, offset, origin, maxsize, 0);
+}
 EXPORT_SYMBOL(generic_file_llseek_size);
 
 /**
@@ -131,8 +153,8 @@ loff_t generic_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
 
-	return generic_file_llseek_size(file, offset, origin,
-					inode->i_sb->s_maxbytes);
+	return generic_file_llseek_size_eof(file, offset, origin,
+					inode->i_sb->s_maxbytes, 0);
 }
 EXPORT_SYMBOL(generic_file_llseek);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..a6ae7a4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2402,6 +2402,8 @@ extern loff_t no_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek(struct file *file, loff_t offset, int origin);
 extern loff_t generic_file_llseek_size(struct file *file, loff_t offset,
 		int origin, loff_t maxsize);
+extern loff_t generic_file_llseek_size_eof(struct file *file, loff_t offset,
+		int origin, loff_t maxsize, loff_t eof);
 extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 

