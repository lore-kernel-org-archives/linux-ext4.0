From: Tao Ma <tm@tao.ma>
Subject: [PATCH V4 13/22] ext4: Create a new function search_dir.
Date: Mon, 20 Feb 2012 15:01:47 +0800
Message-ID: <1329721316-4955-13-git-send-email-tm@tao.ma>
References: <4F41EF95.2000909@tao.ma>
 <1329721316-4955-1-git-send-email-tm@tao.ma>
Cc: linux-fsdevel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1329721316-4955-1-git-send-email-tm@tao.ma>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
index d8cd350..c8dc24e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1971,6 +1971,13 @@ extern int ext4_orphan_add(handle_t *, struct inode *);
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
index 311efe2..7e74503 100644
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

