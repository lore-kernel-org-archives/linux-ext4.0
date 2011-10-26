From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 14/17] ext4: let ext4_delete_entry handle inline data.
Date: Wed, 26 Oct 2011 15:34:25 +0800
Message-ID: <1319614468-11227-14-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |   99 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 79 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 55498a8..fefd061 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1861,32 +1861,28 @@ cleanup:
 }
 
 /*
- * ext4_delete_entry deletes a directory entry by merging it with the
+ * __ext4_delete_entry deletes a directory entry by merging it with the
  * previous entry
  */
-static int ext4_delete_entry(handle_t *handle,
-			     struct inode *dir,
-			     struct ext4_dir_entry_2 *de_del,
-			     struct buffer_head *bh)
+static int __ext4_delete_entry(handle_t *handle,
+			       struct inode *dir,
+			       struct ext4_dir_entry_2 *de_del,
+			       struct buffer_head *bh,
+			       void *entry_buf,
+			       int buf_size)
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
@@ -1897,12 +1893,6 @@ static int ext4_delete_entry(handle_t *handle,
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
@@ -1912,6 +1902,75 @@ static int ext4_delete_entry(handle_t *handle,
 	return -ENOENT;
 }
 
+static int ext4_delete_inline_entry(handle_t *handle,
+				    struct inode *dir,
+				    struct ext4_dir_entry_2 *de_del,
+				    struct buffer_head *bh)
+{
+	int err, inline_size;
+	struct ext4_iloc iloc;
+	void *inline_start;
+
+	err = ext4_get_inode_loc(dir, &iloc);
+	if (err)
+		return err;
+
+	inline_start = ext4_get_inline_data_pos(dir, &iloc);
+	inline_size = ext4_get_max_inline_size(dir);
+
+	err = ext4_journal_get_write_access(handle, bh);
+
+	err = __ext4_delete_entry(handle, dir, de_del, bh,
+				  inline_start, inline_size);
+	if (err)
+		goto out;
+
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_mark_inode_dirty(handle, dir);
+	if (unlikely(err))
+		goto out;
+
+	ext4_show_inline_dir(dir, iloc.bh, inline_start, inline_size);
+	return 0;
+out:
+	brelse(iloc.bh);
+	if (err != -ENOENT)
+		ext4_std_error(dir->i_sb, err);
+	return err;
+}
+
+static int ext4_delete_entry(handle_t *handle,
+			     struct inode *dir,
+			     struct ext4_dir_entry_2 *de_del,
+			     struct buffer_head *bh)
+{
+	int err;
+
+	if (ext4_has_inline_data(dir))
+		return ext4_delete_inline_entry(handle, dir, de_del, bh);
+
+	BUFFER_TRACE(bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, bh);
+	if (unlikely(err))
+		goto out;
+
+	err = __ext4_delete_entry(handle, dir, de_del, bh, bh->b_data,
+				   dir->i_sb->s_blocksize);
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
