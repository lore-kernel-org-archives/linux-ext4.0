From: Tao Ma <tm@tao.ma>
Subject: [PATCH V7 13/23] ext4: Create a new function search_dir.
Date: Wed, 24 Oct 2012 10:55:28 +0800
Message-ID: <1351047338-4963-13-git-send-email-tm@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma>
 <1351047338-4963-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:41817 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S964994Ab2JXDEM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 23:04:12 -0400
Received: from [182.92.247.2] (port=23186 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TQr8U-0006KI-2J
	for linux-ext4@vger.kernel.org; Tue, 23 Oct 2012 20:56:02 -0600
In-Reply-To: <1351047338-4963-1-git-send-email-tm@tao.ma>
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
index eb3f391..3ba236d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2105,6 +2105,13 @@ extern int ext4_orphan_add(handle_t *, struct inode *);
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
index bbf9c2e..4613379 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1096,11 +1096,13 @@ static inline int ext4_match (int len, const char * const name,
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
@@ -1108,8 +1110,8 @@ static inline int search_dirblock(struct buffer_head *bh,
 	const char *name = d_name->name;
 	int namelen = d_name->len;
 
-	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	dlimit = bh->b_data + dir->i_sb->s_blocksize;
+	de = (struct ext4_dir_entry_2 *)search_buf;
+	dlimit = search_buf + buf_size;
 	while ((char *) de < dlimit) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
@@ -1134,6 +1136,16 @@ static inline int search_dirblock(struct buffer_head *bh,
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
1.7.1

