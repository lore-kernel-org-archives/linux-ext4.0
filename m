From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 13/21] ext4: Create a new function search_dir.
Date: Sun, 18 Dec 2011 22:24:30 +0800
Message-ID: <1324218278-2460-13-git-send-email-tm@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
 <1324218278-2460-1-git-send-email-tm@tao.ma>
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55442 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751939Ab1LROgk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:36:40 -0500
In-Reply-To: <1324218278-2460-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

search_dirblock is used to search a dir block, but the code is
almost the same for searching an inline dir.

So create a new fuction search_dir and let search_dirblock
call it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    7 +++++++
 fs/ext4/namei.c |   26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 25d6e58..16efcad 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1967,6 +1967,13 @@ extern int ext4_orphan_add(handle_t *, struct inode *);
 extern int ext4_orphan_del(handle_t *, struct inode *);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
+extern int search_dir(struct buffer_head *bh,
+		      char *search_buf,
+		      int buf_size,
+		      struct inode *dir,
+		      const struct qstr *d_name,
+		      unsigned int offset,
+		      struct ext4_dir_entry_2 **res_dir);
 
 /* resize.c */
 extern int ext4_group_add(struct super_block *sb,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 77312dc..6e97dd2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -794,11 +794,13 @@ static inline int ext4_match (int len, const char * const name,
 /*
  * Returns 0 if not found, -1 on failure, and 1 on success
  */
-static inline int search_dirblock(struct buffer_head *bh,
-				  struct inode *dir,
-				  const struct qstr *d_name,
-				  unsigned int offset,
-				  struct ext4_dir_entry_2 ** res_dir)
+int search_dir(struct buffer_head *bh,
+	       char *search_buf,
+	       int buf_size,
+	       struct inode *dir,
+	       const struct qstr *d_name,
+	       unsigned int offset,
+	       struct ext4_dir_entry_2 **res_dir)
 {
 	struct ext4_dir_entry_2 * de;
 	char * dlimit;
@@ -806,8 +808,8 @@ static inline int search_dirblock(struct buffer_head *bh,
 	const char *name = d_name->name;
 	int namelen = d_name->len;
 
-	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	dlimit = bh->b_data + dir->i_sb->s_blocksize;
+	de = (struct ext4_dir_entry_2 *)search_buf;
+	dlimit = search_buf + buf_size;
 	while ((char *) de < dlimit) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
@@ -832,6 +834,16 @@ static inline int search_dirblock(struct buffer_head *bh,
 	return 0;
 }
 
+static inline int search_dirblock(struct buffer_head *bh,
+				  struct inode *dir,
+				  const struct qstr *d_name,
+				  unsigned int offset,
+				  struct ext4_dir_entry_2 **res_dir)
+{
+	return search_dir(bh, bh->b_data, dir->i_sb->s_blocksize, dir,
+			  d_name, offset, res_dir);
+}
+
 
 /*
  *	ext4_find_entry()
-- 
1.7.0.4

