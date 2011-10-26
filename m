From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 12/17] ext4: Create a new function search_dir.
Date: Wed, 26 Oct 2011 15:34:23 +0800
Message-ID: <1319614468-11227-12-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

search_dirblock is used to search a dir block, but the code is
almost the same for searching an inline dir.

So create a new fuction search_dir and let search_dirblock
call it.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/namei.c |   26 +++++++++++++++++++-------
 1 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4f36137..2c388ad 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -802,11 +802,13 @@ static inline int ext4_match (int len, const char * const name,
 /*
  * Returns 0 if not found, -1 on failure, and 1 on success
  */
-static inline int search_dirblock(struct buffer_head *bh,
-				  struct inode *dir,
-				  const struct qstr *d_name,
-				  unsigned int offset,
-				  struct ext4_dir_entry_2 ** res_dir)
+static inline int search_dir(struct buffer_head *bh,
+			     char *search_buf,
+			     int buf_size,
+			     struct inode *dir,
+			     const struct qstr *d_name,
+			     unsigned int offset,
+			     struct ext4_dir_entry_2 **res_dir)
 {
 	struct ext4_dir_entry_2 * de;
 	char * dlimit;
@@ -814,8 +816,8 @@ static inline int search_dirblock(struct buffer_head *bh,
 	const char *name = d_name->name;
 	int namelen = d_name->len;
 
-	de = (struct ext4_dir_entry_2 *) bh->b_data;
-	dlimit = bh->b_data + dir->i_sb->s_blocksize;
+	de = (struct ext4_dir_entry_2 *)search_buf;
+	dlimit = search_buf + buf_size;
 	while ((char *) de < dlimit) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
@@ -840,6 +842,16 @@ static inline int search_dirblock(struct buffer_head *bh,
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
