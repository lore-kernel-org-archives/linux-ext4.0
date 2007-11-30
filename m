From: Eric Sandeen <sandeen@sandeen.net>
Subject: [RFC] support multiple max offset limits for a single superblock
Date: Fri, 30 Nov 2007 10:35:01 -0600
Message-ID: <47503BB5.2010501@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822AbXK3QfE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2007 11:35:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Reiserfs, and now ext4, both have the possibility of encountering older on-disk
format files which do not support the s_maxbytes of the newer formats.  Reiserfs
currently has spots in various places to catch these too-large offsets and
reject them, but it's replicating a bit of code in the process.

I could do the same for ext4, but Chris Mason prodded me to think of something
more generic... this is what I came up with.  A filesystem could then define
a maxbytes i_op, and if present, it would return the max offset for that 
particular inode, based on format.

I'm not wedded to this, but thought I'd send it out for comment.

(BTW another option would be to convert old-format files when accessed, but
that has its own set of tradeoffs...)

Thanks,

-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---

Index: linux-2.6.24-rc1/fs/buffer.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/buffer.c
+++ linux-2.6.24-rc1/fs/buffer.c
@@ -2175,7 +2175,7 @@ int generic_cont_expand_simple(struct in
 		send_sig(SIGXFSZ, current, 0);
 		goto out;
 	}
-	if (size > inode->i_sb->s_maxbytes)
+	if (size > inode_maxbytes(inode))
 		goto out;
 
 	err = pagecache_write_begin(NULL, mapping, size, 0,
Index: linux-2.6.24-rc1/fs/open.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/open.c
+++ linux-2.6.24-rc1/fs/open.c
@@ -399,7 +399,7 @@ asmlinkage long sys_fallocate(int fd, in
 
 	ret = -EFBIG;
 	/* Check for wrap through zero too */
-	if (((offset + len) > inode->i_sb->s_maxbytes) || ((offset + len) < 0))
+	if (((offset + len) > inode_maxbytes(inode)) || ((offset + len) < 0))
 		goto out_fput;
 
 	if (inode->i_op && inode->i_op->fallocate)
Index: linux-2.6.24-rc1/fs/read_write.c
===================================================================
--- linux-2.6.24-rc1.orig/fs/read_write.c
+++ linux-2.6.24-rc1/fs/read_write.c
@@ -45,7 +45,7 @@ loff_t generic_file_llseek(struct file *
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
-	if (offset>=0 && offset<=inode->i_sb->s_maxbytes) {
+	if (offset >= 0 && offset <= inode_maxbytes(inode)) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
@@ -71,7 +71,7 @@ loff_t remote_llseek(struct file *file, 
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
-	if (offset>=0 && offset<=file->f_path.dentry->d_inode->i_sb->s_maxbytes) {
+	if (offset>=0 && offset<=inode_maxbytes(file->f_path.dentry->d_inode)) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
@@ -764,7 +764,7 @@ static ssize_t do_sendfile(int out_fd, i
 		goto fput_out;
 
 	if (!max)
-		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
+		max = min(inode_maxbytes(in_inode), inode_maxbytes(out_inode));
 
 	pos = *ppos;
 	retval = -EINVAL;
Index: linux-2.6.24-rc1/include/linux/fs.h
===================================================================
--- linux-2.6.24-rc1.orig/include/linux/fs.h
+++ linux-2.6.24-rc1/include/linux/fs.h
@@ -1217,8 +1217,17 @@ struct inode_operations {
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
 	long (*fallocate)(struct inode *inode, int mode, loff_t offset,
 			  loff_t len);
+	unsigned long long (*maxbytes)(struct inode *inode);
 };
 
+static inline unsigned long long inode_maxbytes(struct inode *inode)
+{
+	if (unlikely(inode->i_op->maxbytes)) {
+		return inode->i_op->maxbytes(inode);
+	} else
+		return inode->i_sb->s_maxbytes;
+}
+
 struct seq_file;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
Index: linux-2.6.24-rc1/mm/filemap.c
===================================================================
--- linux-2.6.24-rc1.orig/mm/filemap.c
+++ linux-2.6.24-rc1/mm/filemap.c
@@ -1827,15 +1827,15 @@ inline int generic_write_checks(struct f
 	 * Linus frestrict idea will clean these up nicely..
 	 */
 	if (likely(!isblk)) {
-		if (unlikely(*pos >= inode->i_sb->s_maxbytes)) {
-			if (*count || *pos > inode->i_sb->s_maxbytes) {
+		if (unlikely(*pos >= inode_maxbytes(inode))) {
+			if (*count || *pos > inode_maxbytes(inode)) {
 				return -EFBIG;
 			}
-			/* zero-length writes at ->s_maxbytes are OK */
+			/* zero-length writes at inode_maxbytes are OK */
 		}
 
-		if (unlikely(*pos + *count > inode->i_sb->s_maxbytes))
-			*count = inode->i_sb->s_maxbytes - *pos;
+		if (unlikely(*pos + *count > inode_maxbytes(inode)))
+			*count = inode_maxbytes(inode) - *pos;
 	} else {
 #ifdef CONFIG_BLOCK
 		loff_t isize;
Index: linux-2.6.24-rc1/mm/memory.c
===================================================================
--- linux-2.6.24-rc1.orig/mm/memory.c
+++ linux-2.6.24-rc1/mm/memory.c
@@ -1936,7 +1936,7 @@ do_expand:
 	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
 	if (limit != RLIM_INFINITY && offset > limit)
 		goto out_sig;
-	if (offset > inode->i_sb->s_maxbytes)
+	if (offset > inode_maxbytes(inode))
 		goto out_big;
 	i_size_write(inode, offset);
 
Index: linux-2.6.24-rc1/mm/nommu.c
===================================================================
--- linux-2.6.24-rc1.orig/mm/nommu.c
+++ linux-2.6.24-rc1/mm/nommu.c
@@ -78,7 +78,7 @@ do_expand:
 	limit = current->signal->rlim[RLIMIT_FSIZE].rlim_cur;
 	if (limit != RLIM_INFINITY && offset > limit)
 		goto out_sig;
-	if (offset > inode->i_sb->s_maxbytes)
+	if (offset > inode_maxbytes(inode))
 		goto out;
 	i_size_write(inode, offset);
 
