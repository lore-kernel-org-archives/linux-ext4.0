From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 15/19] ext4: make ext4_delete_entry generic.
Date: Tue, 22 Nov 2011 00:39:53 +0800
Message-ID: <1321893597-11024-15-git-send-email-tm@tao.ma>
References: <4ECA7DB3.9040605@tao.ma>
 <1321893597-11024-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1321893597-11024-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently ext4_delete_entry is used only for dir entry
removing from a dir block. So let us create a new function
ext4_generic_delete_entry and this function takes a entry_buf
and a buf_size so that it can be used for inline data.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    6 +++++
 fs/ext4/namei.c |   62 ++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9776c06..a88bc00 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1972,6 +1972,12 @@ extern int search_dir(struct buffer_head *bh,
 		      const struct qstr *d_name,
 		      unsigned int offset,
 		      struct ext4_dir_entry_2 **res_dir);
+extern int ext4_generic_delete_entry(handle_t *handle,
+				     struct inode *dir,
+				     struct ext4_dir_entry_2 *de_del,
+				     struct buffer_head *bh,
+				     void *entry_buf,
+				     int buf_size);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92f7b67..f706b0f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1693,32 +1693,28 @@ cleanup:
 }
 
 /*
- * ext4_delete_entry deletes a directory entry by merging it with the
- * previous entry
+ * ext4_generic_delete_entry deletes a directory entry by merging it
+ * with the previous entry
  */
-static int ext4_delete_entry(handle_t *handle,
-			     struct inode *dir,
-			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+int ext4_generic_delete_entry(handle_t *handle,
+			      struct inode *dir,
+			      struct ext4_dir_entry_2 *de_del,
+			      struct buffer_head *bh,
+			      void *entry_buf,
+			      int buf_size)
 {
 	struct ext4_dir_entry_2 *de, *pde;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
-	int i, err;
+	int i;
 
 	i = 0;
 	pde = NULL;
-	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	while (i < bh->b_size) {
+	de = (struct ext4_dir_entry_2 *)entry_buf;
+	while (i < buf_size) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 bh->b_data, bh->b_size, i))
 			return -EIO;
 		if (de == de_del)  {
-			BUFFER_TRACE(bh, "get_write_access");
-			err = ext4_journal_get_write_access(handle, bh);
-			if (unlikely(err)) {
-				ext4_std_error(dir->i_sb, err);
-				return err;
-			}
 			if (pde)
 				pde->rec_len = ext4_rec_len_to_disk(
 					ext4_rec_len_from_disk(pde->rec_len,
@@ -1729,12 +1725,6 @@ static int ext4_delete_entry(handle_t *handle,
 			else
 				de->inode = 0;
 			dir->i_version++;
-			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-			err = ext4_handle_dirty_metadata(handle, dir, bh);
-			if (unlikely(err)) {
-				ext4_std_error(dir->i_sb, err);
-				return err;
-			}
 			return 0;
 		}
 		i += ext4_rec_len_from_disk(de->rec_len, blocksize);
@@ -1744,6 +1734,36 @@ static int ext4_delete_entry(handle_t *handle,
 	return -ENOENT;
 }
 
+static int ext4_delete_entry(handle_t *handle,
+			     struct inode *dir,
+			     struct ext4_dir_entry_2 *de_del,
+			     struct buffer_head *bh)
+{
+	int err;
+
+	BUFFER_TRACE(bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, bh);
+	if (unlikely(err))
+		goto out;
+
+	err = ext4_generic_delete_entry(handle, dir, de_del,
+					bh, bh->b_data,
+					dir->i_sb->s_blocksize);
+	if (err)
+		goto out;
+
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_metadata(handle, dir, bh);
+	if (unlikely(err))
+		goto out;
+
+	return 0;
+out:
+	if (err != -ENOENT)
+		ext4_std_error(dir->i_sb, err);
+	return err;
+}
+
 /*
  * DIR_NLINK feature is set if 1) nlinks > EXT4_LINK_MAX or 2) nlinks == 2,
  * since this indicates that nlinks count was previously 1.
-- 
1.7.0.4
