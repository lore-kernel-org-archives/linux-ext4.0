From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/6] ext4: convert ext4_dx_find_entry() to use the ERR_PTR convention
Date: Fri, 22 Aug 2014 03:29:46 -0400
Message-ID: <1408692590-13346-3-git-send-email-tytso@mit.edu>
References: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:44043 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbaHVHaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Aug 2014 03:30:00 -0400
In-Reply-To: <1408692590-13346-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/namei.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ae7088b..51a4a5d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -270,8 +270,7 @@ static int ext4_htree_next_block(struct inode *dir, __u32 hash,
 				 __u32 *start_hash);
 static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 		const struct qstr *d_name,
-		struct ext4_dir_entry_2 **res_dir,
-		int *err);
+		struct ext4_dir_entry_2 **res_dir);
 static int ext4_dx_add_entry(handle_t *handle, struct dentry *dentry,
 			     struct inode *inode);
 
@@ -1258,17 +1257,13 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		goto restart;
 	}
 	if (is_dx(dir)) {
-		bh = ext4_dx_find_entry(dir, d_name, res_dir, &err);
+		bh = ext4_dx_find_entry(dir, d_name, res_dir);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
 		 * old fashioned way.
 		 */
-		if (err == -ENOENT)
-			return NULL;
-		if (err && err != ERR_BAD_DX_DIR)
-			return ERR_PTR(err);
-		if (bh)
+		if (!IS_ERR(bh) || PTR_ERR(bh) != ERR_BAD_DX_DIR)
 			return bh;
 		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
 			       "falling back\n"));
@@ -1366,34 +1361,32 @@ cleanup_and_exit:
 }
 
 static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct qstr *d_name,
-		       struct ext4_dir_entry_2 **res_dir, int *err)
+		       struct ext4_dir_entry_2 **res_dir)
 {
 	struct super_block * sb = dir->i_sb;
 	struct dx_hash_info	hinfo;
 	struct dx_frame frames[2], *frame;
 	struct buffer_head *bh;
 	ext4_lblk_t block;
-	int retval;
+	int err = 0, retval;
 
-	if (!(frame = dx_probe(d_name, dir, &hinfo, frames, err)))
-		return NULL;
+	frame = dx_probe(d_name, dir, &hinfo, frames, &err);
+	if (err)
+		return ERR_PTR(err);
 	do {
 		block = dx_get_block(frame->at);
 		bh = ext4_read_dirblock(dir, block, DIRENT);
-		if (IS_ERR(bh)) {
-			*err = PTR_ERR(bh);
+		if (IS_ERR(bh))
 			goto errout;
-		}
+
 		retval = search_dirblock(bh, dir, d_name,
 					 block << EXT4_BLOCK_SIZE_BITS(sb),
 					 res_dir);
-		if (retval == 1) { 	/* Success! */
-			dx_release(frames);
-			return bh;
-		}
+		if (retval == 1)
+			goto success;
 		brelse(bh);
 		if (retval == -1) {
-			*err = ERR_BAD_DX_DIR;
+			bh = ERR_PTR(ERR_BAD_DX_DIR);
 			goto errout;
 		}
 
@@ -1402,18 +1395,19 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir, const struct q
 					       frames, NULL);
 		if (retval < 0) {
 			ext4_warning(sb,
-			     "error reading index page in directory #%lu",
-			     dir->i_ino);
-			*err = retval;
+			     "error %d reading index page in directory #%lu",
+			     retval, dir->i_ino);
+			bh = ERR_PTR(retval);
 			goto errout;
 		}
 	} while (retval == 1);
 
-	*err = -ENOENT;
+	bh = NULL;
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", d_name->name));
-	dx_release (frames);
-	return NULL;
+success:
+	dx_release(frames);
+	return bh;
 }
 
 static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
-- 
2.1.0

