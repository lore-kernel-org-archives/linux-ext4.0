From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: remove unused d_name argument from ext4_search_dir() et al.
Date: Wed, 15 Feb 2017 16:30:55 -0800
Message-ID: <20170216003055.129998-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34775 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753829AbdBPAbo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Feb 2017 19:31:44 -0500
Received: by mail-pf0-f194.google.com with SMTP id o64so184971pfb.1
        for <linux-ext4@vger.kernel.org>; Wed, 15 Feb 2017 16:31:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

Now that we are passing a struct ext4_filename, we do not need to pass
around the original struct qstr too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ext4.h   |  2 --
 fs/ext4/inline.c |  5 ++---
 fs/ext4/namei.c  | 13 +++++--------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 55b7a77a0444..10628e3ad6c5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2542,7 +2542,6 @@ extern int ext4_search_dir(struct buffer_head *bh,
 			   int buf_size,
 			   struct inode *dir,
 			   struct ext4_filename *fname,
-			   const struct qstr *d_name,
 			   unsigned int offset,
 			   struct ext4_dir_entry_2 **res_dir);
 extern int ext4_generic_delete_entry(handle_t *handle,
@@ -3026,7 +3025,6 @@ extern int htree_inlinedir_to_tree(struct file *dir_file,
 				   int *has_inline_data);
 extern struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 					struct ext4_filename *fname,
-					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
 					int *has_inline_data);
 extern int ext4_delete_inline_entry(handle_t *handle,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 30a9f210d1e3..3a1f2822541b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1628,7 +1628,6 @@ int ext4_try_create_inline_dir(handle_t *handle, struct inode *parent,
 
 struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 					struct ext4_filename *fname,
-					const struct qstr *d_name,
 					struct ext4_dir_entry_2 **res_dir,
 					int *has_inline_data)
 {
@@ -1650,7 +1649,7 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 						EXT4_INLINE_DOTDOT_SIZE;
 	inline_size = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DOTDOT_SIZE;
 	ret = ext4_search_dir(iloc.bh, inline_start, inline_size,
-			      dir, fname, d_name, 0, res_dir);
+			      dir, fname, 0, res_dir);
 	if (ret == 1)
 		goto out_find;
 	if (ret < 0)
@@ -1663,7 +1662,7 @@ struct buffer_head *ext4_find_inline_entry(struct inode *dir,
 	inline_size = ext4_get_inline_size(dir) - EXT4_MIN_INLINE_DATA_SIZE;
 
 	ret = ext4_search_dir(iloc.bh, inline_start, inline_size,
-			      dir, fname, d_name, 0, res_dir);
+			      dir, fname, 0, res_dir);
 	if (ret == 1)
 		goto out_find;
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6ad612c576fc..8ccfd72c3b89 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1155,12 +1155,11 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 static inline int search_dirblock(struct buffer_head *bh,
 				  struct inode *dir,
 				  struct ext4_filename *fname,
-				  const struct qstr *d_name,
 				  unsigned int offset,
 				  struct ext4_dir_entry_2 **res_dir)
 {
 	return ext4_search_dir(bh, bh->b_data, dir->i_sb->s_blocksize, dir,
-			       fname, d_name, offset, res_dir);
+			       fname, offset, res_dir);
 }
 
 /*
@@ -1275,7 +1274,6 @@ static inline int ext4_match(struct ext4_filename *fname,
  */
 int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		    struct inode *dir, struct ext4_filename *fname,
-		    const struct qstr *d_name,
 		    unsigned int offset, struct ext4_dir_entry_2 **res_dir)
 {
 	struct ext4_dir_entry_2 * de;
@@ -1385,7 +1383,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 
 	if (ext4_has_inline_data(dir)) {
 		int has_inline_data = 1;
-		ret = ext4_find_inline_entry(dir, &fname, d_name, res_dir,
+		ret = ext4_find_inline_entry(dir, &fname, res_dir,
 					     &has_inline_data);
 		if (has_inline_data) {
 			if (inlined)
@@ -1477,7 +1475,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 			goto next;
 		}
 		set_buffer_verified(bh);
-		i = search_dirblock(bh, dir, &fname, d_name,
+		i = search_dirblock(bh, dir, &fname,
 			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
 		if (i == 1) {
 			EXT4_I(dir)->i_dir_start_lookup = block;
@@ -1518,7 +1516,6 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 {
 	struct super_block * sb = dir->i_sb;
 	struct dx_frame frames[2], *frame;
-	const struct qstr *d_name = fname->usr_fname;
 	struct buffer_head *bh;
 	ext4_lblk_t block;
 	int retval;
@@ -1535,7 +1532,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 		if (IS_ERR(bh))
 			goto errout;
 
-		retval = search_dirblock(bh, dir, fname, d_name,
+		retval = search_dirblock(bh, dir, fname,
 					 block << EXT4_BLOCK_SIZE_BITS(sb),
 					 res_dir);
 		if (retval == 1)
@@ -1560,7 +1557,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 
 	bh = NULL;
 errout:
-	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
+	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
 	dx_release(frames);
 	return bh;
-- 
2.11.0.483.g087da7b7c-goog
