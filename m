From: Tao Ma <tm@tao.ma>
Subject: [PATCH V5 15/23] ext4: make ext4_delete_entry generic.
Date: Sat, 30 Jun 2012 23:45:16 +0800
Message-ID: <1341071124-4976-15-git-send-email-tm@tao.ma>
References: <1341070917-4889-1-git-send-email-tm@tao.ma>
 <1341071124-4976-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:57140 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755654Ab2F3Pt5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2012 11:49:57 -0400
Received: from [221.217.40.18] (port=40170 helo=localhost.localdomain)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1Skzu9-0006eg-NS
	for linux-ext4@vger.kernel.org; Sat, 30 Jun 2012 09:48:14 -0600
In-Reply-To: <1341071124-4976-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Currently ext4_delete_entry is used only for dir entry
removing from a dir block. So let us create a new function
ext4_generic_delete_entry and this function takes a entry_buf
and a buf_size so that it can be used for inline data.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    7 +++++
 fs/ext4/namei.c |   72 +++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9b4a0dd..953f530 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2089,6 +2089,13 @@ extern int search_dir(struct buffer_head *bh,
 		      const struct qstr *d_name,
 		      unsigned int offset,
 		      struct ext4_dir_entry_2 **res_dir);
+extern int ext4_generic_delete_entry(handle_t *handle,
+				     struct inode *dir,
+				     struct ext4_dir_entry_2 *de_del,
+				     struct buffer_head *bh,
+				     void *entry_buf,
+				     int buf_size,
+				     int csum_size);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3cff036..b39da8b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2037,37 +2037,29 @@ cleanup:
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
+			      int buf_size,
+			      int csum_size)
 {
 	struct ext4_dir_entry_2 *de, *pde;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
-	int csum_size = 0;
-	int i, err;
-
-	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		csum_size = sizeof(struct ext4_dir_entry_tail);
+	int i;
 
 	i = 0;
 	pde = NULL;
-	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	while (i < bh->b_size - csum_size) {
+	de = (struct ext4_dir_entry_2 *)entry_buf;
+	while (i < buf_size - csum_size) {
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
@@ -2078,12 +2070,6 @@ static int ext4_delete_entry(handle_t *handle,
 			else
 				de->inode = 0;
 			dir->i_version++;
-			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-			err = ext4_handle_dirty_dirent_node(handle, dir, bh);
-			if (unlikely(err)) {
-				ext4_std_error(dir->i_sb, err);
-				return err;
-			}
 			return 0;
 		}
 		i += ext4_rec_len_from_disk(de->rec_len, blocksize);
@@ -2093,6 +2079,40 @@ static int ext4_delete_entry(handle_t *handle,
 	return -ENOENT;
 }
 
+static int ext4_delete_entry(handle_t *handle,
+			     struct inode *dir,
+			     struct ext4_dir_entry_2 *de_del,
+			     struct buffer_head *bh)
+{
+	int err, csum_size = 0;
+
+	if (EXT4_HAS_RO_COMPAT_FEATURE(dir->i_sb,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		csum_size = sizeof(struct ext4_dir_entry_tail);
+
+	BUFFER_TRACE(bh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, bh);
+	if (unlikely(err))
+		goto out;
+
+	err = ext4_generic_delete_entry(handle, dir, de_del,
+					bh, bh->b_data,
+					dir->i_sb->s_blocksize, csum_size);
+	if (err)
+		goto out;
+
+	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+	err = ext4_handle_dirty_dirent_node(handle, dir, bh);
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

