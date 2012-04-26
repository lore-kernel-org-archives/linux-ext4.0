From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: call vfs llseek code from ext4_dir_llseek
Date: Thu, 26 Apr 2012 17:34:49 -0500
Message-ID: <4F99CD89.7070407@redhat.com>
References: <4F984F22.10203@redhat.com> <4F99904F.3040000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab2DZWey (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 Apr 2012 18:34:54 -0400
In-Reply-To: <4F99904F.3040000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_dir_llseek can call the vfs llseek functions and get all the
the functionality needed by the NFS server.

For htree directories, we call the _sized() variant with the
maximum allowable hash value.  For non-htree, we can call
ext4_file_llseek, which will sort out the maximum allowable
offset based on whether the dir is extent based or not.

This does lose the special SEEK_END handling of going to the
max hash size, but I know of no usecase for that and no bugs,
despite SEEK_END going to i_size and not the hash EOF for
many years now, so I don't think the cut & paste is warranted.
The vfs function can be expanded if it's critical.

This also returns dir llseek to it's (mostly) lockless
implementation.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index b867862..faebc89 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -312,74 +312,26 @@ static inline loff_t ext4_get_htree_eof(struct file *filp)
 
 
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
