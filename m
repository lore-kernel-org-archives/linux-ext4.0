From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/3] ext4: use core vfs llseek code for dir seeks
Date: Mon, 30 Apr 2012 13:14:03 -0500
Message-ID: <4F9ED66B.7080304@redhat.com>
References: <4F9AC770.8080004@redhat.com> <20120428183315.GA28349@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120428183315.GA28349@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use the new functionality in generic_file_llseek_size() to
accept a custom EOF position, and un-cut-and-paste all the
vfs llseek code from ext4.

Also fix up comments on ext4_llseek() to reflect reality.

Signed-off-by: Eric Sandeen <sandeen@redaht.com>
---

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b867862..84161c9 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -312,74 +312,27 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
 
 
 /*
- * ext4_dir_llseek() based on generic_file_llseek() to handle both
- * non-htree and htree directories, where the "offset" is in terms
- * of the filename hash value instead of the byte offset.
+ * ext4_dir_llseek() calls generic_file_llseek_size to handle htree
+ * directories, where the "offset" is in terms of the filename hash
+ * value instead of the byte offset.
  *
- * NOTE: offsets obtained *before* ext4_set_inode_flag(dir, EXT4_INODE_INDEX)
- *       will be invalid once the directory was converted into a dx directory
+ * Because we may return a 64-bit hash that is well beyond offset limits,
+ * we need to pass the max hash as the maximum allowable offset in
+ * the htree directory case.
+ *
+ * For non-htree, ext4_llseek already chooses the proper max offset.
  */
 loff_t ext4_dir_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct inode *inode = file->f_mapping->host;
-	loff_t ret = -EINVAL;
 	int dx_dir = is_dx_dir(inode);
+	loff_t htree_max = ext4_get_htree_eof(file);
 
-	mutex_lock(&inode->i_mutex);
-
-	/* NOTE: relative offsets with dx directories might not work
-	 *       as expected, as it is difficult to figure out the
-	 *       correct offset between dx hashes */
-
-	switch (origin) {
-	case SEEK_END:
-		if (unlikely(offset > 0))
-			goto out_err; /* not supported for directories */
-
-		/* so only negative offsets are left, does that have a
-		 * meaning for directories at all? */
-		if (dx_dir)
-			offset += ext4_get_htree_eof(file);
-		else
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
-
-	/* Special lock needed here? */
-	if (offset != file->f_pos) {
-		file->f_pos = offset;
-		file->f_version = 0;
-	}
-
-out_ok:
-	ret = offset;
-out_err:
-	mutex_unlock(&inode->i_mutex);
-
-	return ret;
+	if (likely(dx_dir))
+		return generic_file_llseek_size(file, offset, origin,
+						    htree_max, htree_max);
+	else
+		return ext4_llseek(file, offset, origin);
 }
 
 /*
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index cb70f18..2f0bf2a 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -211,9 +211,9 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 }
 
 /*
- * ext4_llseek() copied from generic_file_llseek() to handle both
- * block-mapped and extent-mapped maxbytes values. This should
- * otherwise be identical with generic_file_llseek().
+ * ext4_llseek() handles both block-mapped and extent-mapped maxbytes values
+ * by calling generic_file_llseek_size() with the appropriate maxbytes
+ * value for each.
  */
 loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 {
@@ -225,7 +225,8 @@ loff_t ext4_llseek(struct file *file, loff_t offset, int origin)
 	else
 		maxbytes = inode->i_sb->s_maxbytes;
 
-	return generic_file_llseek_size(file, offset, origin, maxbytes);
+	return generic_file_llseek_size(file, offset, origin,
+					maxbytes, i_size_read(inode));
 }
 
 const struct file_operations ext4_file_operations = {

