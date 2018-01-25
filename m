From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: [PATCH RFC v2 12/13] ext4: Support charset name matching
Date: Thu, 25 Jan 2018 00:53:48 -0200
Message-ID: <20180125025349.31494-13-krisman@collabora.co.uk>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        alvaro.soliverez@collabora.co.uk, kernel@lists.collabora.co.uk,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>
To: tytso@mit.edu, david@fromorbit.com, olaf@sgi.com,
        viro@zeniv.linux.org.uk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52126 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933065AbeAYCze (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jan 2018 21:55:34 -0500
In-Reply-To: <20180125025349.31494-1-krisman@collabora.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Implement generic caseless lookup based on the mount flags using the
charset library.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
---
 fs/ext4/namei.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e750d68fbcb5..24056172e225 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1255,8 +1255,10 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
  *
  * Return: %true if the directory entry matches, otherwise %false.
  */
-static inline bool ext4_match(const struct ext4_filename *fname,
-			      const struct ext4_dir_entry_2 *de)
+static inline bool ext4_match(const struct charset *charset,
+			      const struct ext4_filename *fname,
+			      const struct ext4_dir_entry_2 *de,
+			      bool ignorecase)
 {
 	struct fscrypt_name f;
 
@@ -1268,7 +1270,8 @@ static inline bool ext4_match(const struct ext4_filename *fname,
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	f.crypto_buf = fname->crypto_buf;
 #endif
-	return fscrypt_match_name(&f, de->name, de->name_len);
+	return fscrypt_charset_match_name(&f, charset, de->name, de->name_len,
+					  ignorecase);
 }
 
 /*
@@ -1281,6 +1284,8 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 	struct ext4_dir_entry_2 * de;
 	char * dlimit;
 	int de_len;
+	struct super_block *sb = dir->i_sb;
+	bool ignorecase = test_opt2(sb, CASE_INSENSITIVE);
 
 	de = (struct ext4_dir_entry_2 *)search_buf;
 	dlimit = search_buf + buf_size;
@@ -1288,7 +1293,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
 		if ((char *) de + de->name_len <= dlimit &&
-		    ext4_match(fname, de)) {
+		    ext4_match(EXT4_SB(sb)->encoding, fname, de, ignorecase)) {
 			/* found a match - just to be sure, do
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
@@ -1389,11 +1394,13 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	if (is_dx(dir)) {
 		ret = ext4_dx_find_entry(dir, &fname, res_dir);
 		/*
-		 * On success, or if the error was file not found,
-		 * return.  Otherwise, fall back to doing a search the
-		 * old fashioned way.
+		 * On success, or if the file cannot be found, return.
+		 * If an error occurred, or if the file was not found
+		 * but we can do case-insensitive lookups, fall back to
+		 * the linear search.
 		 */
-		if (!IS_ERR(ret) || PTR_ERR(ret) != ERR_BAD_DX_DIR)
+		if ((!IS_ERR(ret) && (ret || !test_opt2(sb, CASE_INSENSITIVE))) ||
+		    (IS_ERR(ret) && PTR_ERR(ret) != ERR_BAD_DX_DIR))
 			goto cleanup_and_exit;
 		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
 			       "falling back\n"));
@@ -1788,6 +1795,8 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
+	struct super_block *sb = dir->i_sb;
+	bool ignorecase = test_opt2(sb, CASE_INSENSITIVE);
 
 	de = (struct ext4_dir_entry_2 *)buf;
 	top = buf + buf_size - reclen;
@@ -1795,7 +1804,7 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(fname, de))
+		if (ext4_match(EXT4_SB(sb)->encoding, fname, de, ignorecase))
 			return -EEXIST;
 		nlen = EXT4_DIR_REC_LEN(de->name_len);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
-- 
2.15.1
