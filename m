From: Mathieu Segaud <mathieu.segaud@regala.cx>
Subject: [PATCH] [Coding Style]: fs/ext{3,4}/dir.c
Date: Fri,  4 Jan 2008 14:21:35 +0100
Message-ID: <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
 <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
 <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mathieu Segaud <mathieu.segaud@regala.cx>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bde.crans.org ([138.231.137.76]:48602 "EHLO bde.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYADNaS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jan 2008 08:30:18 -0500
In-Reply-To: <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Misc style fixes from checkpatch.pl

Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
---
 fs/ext3/dir.c |   55 ++++++++++++++++++++++++++++---------------------------
 fs/ext4/dir.c |   50 +++++++++++++++++++++++++-------------------------
 2 files changed, 53 insertions(+), 52 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 8ca3bfd..fc3621e 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -33,10 +33,10 @@ static unsigned char ext3_filetype_table[] = {
 };
 
 static int ext3_readdir(struct file *, void *, filldir_t);
-static int ext3_dx_readdir(struct file * filp,
-			   void * dirent, filldir_t filldir);
-static int ext3_release_dir (struct inode * inode,
-				struct file * filp);
+static int ext3_dx_readdir(struct file *filp,
+			   void *dirent, filldir_t filldir);
+static int ext3_release_dir(struct inode *inode,
+				struct file *filp);
 
 const struct file_operations ext3_dir_operations = {
 	.llseek		= generic_file_llseek,
@@ -61,12 +61,12 @@ static unsigned char get_dtype(struct super_block *sb, int filetype)
 }
 
 
-int ext3_check_dir_entry (const char * function, struct inode * dir,
-			  struct ext3_dir_entry_2 * de,
-			  struct buffer_head * bh,
+int ext3_check_dir_entry(const char *function, struct inode *dir,
+			  struct ext3_dir_entry_2 *de,
+			  struct buffer_head *bh,
 			  unsigned long offset)
 {
-	const char * error_msg = NULL;
+	const char *error_msg = NULL;
 	const int rlen = ext3_rec_len_from_disk(de->rec_len);
 
 	if (rlen < EXT3_DIR_REC_LEN(1))
@@ -82,7 +82,7 @@ int ext3_check_dir_entry (const char * function, struct inode * dir,
 		error_msg = "inode out of bounds";
 
 	if (error_msg != NULL)
-		ext3_error (dir->i_sb, function,
+		ext3_error(dir->i_sb, function,
 			"bad entry in directory #%lu: %s - "
 			"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error_msg, offset,
@@ -91,8 +91,8 @@ int ext3_check_dir_entry (const char * function, struct inode * dir,
 	return error_msg == NULL ? 1 : 0;
 }
 
-static int ext3_readdir(struct file * filp,
-			 void * dirent, filldir_t filldir)
+static int ext3_readdir(struct file *filp,
+			 void *dirent, filldir_t filldir)
 {
 	int error = 0;
 	unsigned long offset;
@@ -148,7 +148,7 @@ static int ext3_readdir(struct file * filp,
 		 * of recovering data when there's a bad sector
 		 */
 		if (!bh) {
-			ext3_error (sb, "ext3_readdir",
+			ext3_error(sb, "ext3_readdir",
 				"directory #%lu contains a hole at offset %lu",
 				inode->i_ino, (unsigned long)filp->f_pos);
 			/* corrupt size?  Maybe no more blocks to read */
@@ -187,13 +187,14 @@ revalidate:
 		while (!error && filp->f_pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext3_dir_entry_2 *) (bh->b_data + offset);
-			if (!ext3_check_dir_entry ("ext3_readdir", inode, de,
+			if (!ext3_check_dir_entry("ext3_readdir", inode, de,
 						   bh, offset)) {
-				/* On error, skip the f_pos to the
-                                   next block. */
+				/*
+				 * On error, skip the f_pos to the next block.
+				 */
 				filp->f_pos = (filp->f_pos |
 						(sb->s_blocksize - 1)) + 1;
-				brelse (bh);
+				brelse(bh);
 				ret = stored;
 				goto out;
 			}
@@ -217,12 +218,12 @@ revalidate:
 					break;
 				if (version != filp->f_version)
 					goto revalidate;
-				stored ++;
+				stored++;
 			}
 			filp->f_pos += ext3_rec_len_from_disk(de->rec_len);
 		}
 		offset = 0;
-		brelse (bh);
+		brelse(bh);
 	}
 out:
 	return ret;
@@ -289,9 +290,9 @@ static void free_rb_tree_fname(struct rb_root *root)
 		parent = rb_parent(n);
 		fname = rb_entry(n, struct fname, rb_hash);
 		while (fname) {
-			struct fname * old = fname;
+			struct fname *old = fname;
 			fname = fname->next;
-			kfree (old);
+			kfree(old);
 		}
 		if (!parent)
 			root->rb_node = NULL;
@@ -336,7 +337,7 @@ int ext3_htree_store_dirent(struct file *dir_file, __u32 hash,
 			     struct ext3_dir_entry_2 *dirent)
 {
 	struct rb_node **p, *parent = NULL;
-	struct fname * fname, *new_fn;
+	struct fname *fname, *new_fn;
 	struct dir_private_info *info;
 	int len;
 
@@ -393,19 +394,19 @@ int ext3_htree_store_dirent(struct file *dir_file, __u32 hash,
  * for all entres on the fname linked list.  (Normally there is only
  * one entry on the linked list, unless there are 62 bit hash collisions.)
  */
-static int call_filldir(struct file * filp, void * dirent,
+static int call_filldir(struct file *filp, void *dirent,
 			filldir_t filldir, struct fname *fname)
 {
 	struct dir_private_info *info = filp->private_data;
 	loff_t	curr_pos;
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct super_block * sb;
+	struct super_block *sb;
 	int error;
 
 	sb = inode->i_sb;
 
 	if (!fname) {
-		printk("call_filldir: called with null fname?!?\n");
+		printk(KERN_WARNING "call_filldir: called with null fname?!?\n");
 		return 0;
 	}
 	curr_pos = hash2pos(fname->hash, fname->minor_hash);
@@ -424,8 +425,8 @@ static int call_filldir(struct file * filp, void * dirent,
 	return 0;
 }
 
-static int ext3_dx_readdir(struct file * filp,
-			 void * dirent, filldir_t filldir)
+static int ext3_dx_readdir(struct file  filp,
+			 void  dirent, filldir_t filldir)
 {
 	struct dir_private_info *info = filp->private_data;
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -506,7 +507,7 @@ finished:
 	return 0;
 }
 
-static int ext3_release_dir (struct inode * inode, struct file * filp)
+static int ext3_release_dir(struct inode *inode, struct file *filp)
 {
        if (filp->private_data)
 		ext3_htree_free_dir_info(filp->private_data);
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f612bef..14385b6 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -33,10 +33,10 @@ static unsigned char ext4_filetype_table[] = {
 };
 
 static int ext4_readdir(struct file *, void *, filldir_t);
-static int ext4_dx_readdir(struct file * filp,
-			   void * dirent, filldir_t filldir);
-static int ext4_release_dir (struct inode * inode,
-				struct file * filp);
+static int ext4_dx_readdir(struct file *filp,
+			   void *dirent, filldir_t filldir);
+static int ext4_release_dir(struct inode *inode,
+				struct file *filp);
 
 const struct file_operations ext4_dir_operations = {
 	.llseek		= generic_file_llseek,
@@ -61,12 +61,12 @@ static unsigned char get_dtype(struct super_block *sb, int filetype)
 }
 
 
-int ext4_check_dir_entry (const char * function, struct inode * dir,
-			  struct ext4_dir_entry_2 * de,
-			  struct buffer_head * bh,
+int ext4_check_dir_entry(const char *function, struct inode *dir,
+			  struct ext4_dir_entry_2 *de,
+			  struct buffer_head *bh,
 			  unsigned long offset)
 {
-	const char * error_msg = NULL;
+	const char *error_msg = NULL;
 	const int rlen = le16_to_cpu(de->rec_len);
 
 	if (rlen < EXT4_DIR_REC_LEN(1))
@@ -82,7 +82,7 @@ int ext4_check_dir_entry (const char * function, struct inode * dir,
 		error_msg = "inode out of bounds";
 
 	if (error_msg != NULL)
-		ext4_error (dir->i_sb, function,
+		ext4_error(dir->i_sb, function,
 			"bad entry in directory #%lu: %s - "
 			"offset=%lu, inode=%lu, rec_len=%d, name_len=%d",
 			dir->i_ino, error_msg, offset,
@@ -91,8 +91,8 @@ int ext4_check_dir_entry (const char * function, struct inode * dir,
 	return error_msg == NULL ? 1 : 0;
 }
 
-static int ext4_readdir(struct file * filp,
-			 void * dirent, filldir_t filldir)
+static int ext4_readdir(struct file *filp,
+			 void *dirent, filldir_t filldir)
 {
 	int error = 0;
 	unsigned long offset;
@@ -147,7 +147,7 @@ static int ext4_readdir(struct file * filp,
 		 * of recovering data when there's a bad sector
 		 */
 		if (!bh) {
-			ext4_error (sb, "ext4_readdir",
+			ext4_error(sb, "ext4_readdir",
 				"directory #%lu contains a hole at offset %lu",
 				inode->i_ino, (unsigned long)filp->f_pos);
 			/* corrupt size?  Maybe no more blocks to read */
@@ -186,14 +186,14 @@ revalidate:
 		while (!error && filp->f_pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
-			if (!ext4_check_dir_entry ("ext4_readdir", inode, de,
+			if (!ext4_check_dir_entry("ext4_readdir", inode, de,
 						   bh, offset)) {
 				/*
 				 * On error, skip the f_pos to the next block
 				 */
 				filp->f_pos = (filp->f_pos |
 						(sb->s_blocksize - 1)) + 1;
-				brelse (bh);
+				brelse(bh);
 				ret = stored;
 				goto out;
 			}
@@ -217,12 +217,12 @@ revalidate:
 					break;
 				if (version != filp->f_version)
 					goto revalidate;
-				stored ++;
+				stored++;
 			}
 			filp->f_pos += le16_to_cpu(de->rec_len);
 		}
 		offset = 0;
-		brelse (bh);
+		brelse(bh);
 	}
 out:
 	return ret;
@@ -289,9 +289,9 @@ static void free_rb_tree_fname(struct rb_root *root)
 		parent = rb_parent(n);
 		fname = rb_entry(n, struct fname, rb_hash);
 		while (fname) {
-			struct fname * old = fname;
+			struct fname *old = fname;
 			fname = fname->next;
-			kfree (old);
+			kfree(old);
 		}
 		if (!parent)
 			root->rb_node = NULL;
@@ -336,7 +336,7 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 			     struct ext4_dir_entry_2 *dirent)
 {
 	struct rb_node **p, *parent = NULL;
-	struct fname * fname, *new_fn;
+	struct fname *fname, *new_fn;
 	struct dir_private_info *info;
 	int len;
 
@@ -393,19 +393,19 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
  * for all entres on the fname linked list.  (Normally there is only
  * one entry on the linked list, unless there are 62 bit hash collisions.)
  */
-static int call_filldir(struct file * filp, void * dirent,
+static int call_filldir(struct file *filp, void *dirent,
 			filldir_t filldir, struct fname *fname)
 {
 	struct dir_private_info *info = filp->private_data;
 	loff_t	curr_pos;
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	struct super_block * sb;
+	struct super_block *sb;
 	int error;
 
 	sb = inode->i_sb;
 
 	if (!fname) {
-		printk("call_filldir: called with null fname?!?\n");
+		printk(KERN_WARNING "call_filldir: called with null fname?!?\n");
 		return 0;
 	}
 	curr_pos = hash2pos(fname->hash, fname->minor_hash);
@@ -424,8 +424,8 @@ static int call_filldir(struct file * filp, void * dirent,
 	return 0;
 }
 
-static int ext4_dx_readdir(struct file * filp,
-			 void * dirent, filldir_t filldir)
+static int ext4_dx_readdir(struct file *filp,
+			 void *dirent, filldir_t filldir)
 {
 	struct dir_private_info *info = filp->private_data;
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -506,7 +506,7 @@ finished:
 	return 0;
 }
 
-static int ext4_release_dir (struct inode * inode, struct file * filp)
+static int ext4_release_dir(struct inode *inode, struct file *filp)
 {
 	if (filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
-- 
1.5.3.7
