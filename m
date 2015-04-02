From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 16/22] ext4 crypto: insert encrypted filenames into a leaf directory block
Date: Thu,  2 Apr 2015 18:10:53 -0400
Message-ID: <1428012659-12709-17-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48019 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbbDBWNF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:13:05 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: Iea5da045383d41e3912eed7e63292096c24668e4
Signed-off-by: Uday Savagaonkar <savagaon@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h   |   4 ++-
 fs/ext4/inline.c |  10 ++++--
 fs/ext4/namei.c  | 104 +++++++++++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 105 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 576321c..421c065 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2122,9 +2122,11 @@ extern int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 			     void *buf, int buf_size,
 			     const char *name, int namelen,
 			     struct ext4_dir_entry_2 **dest_de);
-void ext4_insert_dentry(struct inode *inode,
+int ext4_insert_dentry(struct inode *dir,
+			struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
+		       const struct qstr *iname,
 			const char *name, int namelen);
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 056ef06..5184111 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -11,11 +11,16 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
+
+#include <linux/fiemap.h>
+
 #include "ext4_jbd2.h"
 #include "ext4.h"
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+#include "ext4_crypto.h"
+#endif
 #include "xattr.h"
 #include "truncate.h"
-#include <linux/fiemap.h>
 
 #define EXT4_XATTR_SYSTEM_DATA	"data"
 #define EXT4_MIN_INLINE_DATA_SIZE	((sizeof(__le32) * EXT4_N_BLOCKS))
@@ -1014,7 +1019,8 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	err = ext4_journal_get_write_access(handle, iloc->bh);
 	if (err)
 		return err;
-	ext4_insert_dentry(inode, de, inline_size, name, namelen);
+	ext4_insert_dentry(dir, inode, de, inline_size, &dentry->d_name,
+			   name, namelen);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 57cae22..cbedeb0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1663,19 +1663,51 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 	return 0;
 }
 
-void ext4_insert_dentry(struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			const char *name, int namelen)
+int ext4_insert_dentry(struct inode *dir,
+		       struct inode *inode,
+		       struct ext4_dir_entry_2 *de,
+		       int buf_size,
+		       const struct qstr *iname,
+		       const char *name, int namelen)
 {
 
 	int nlen, rlen;
+	struct ext4_fname_crypto_ctx *ctx = NULL;
+	struct ext4_str fname_crypto_str = {.name = NULL, .len = 0};
+	struct ext4_str tmp_str;
+	int res;
+
+	ctx = ext4_get_fname_crypto_ctx(dir, EXT4_NAME_LEN);
+	if (IS_ERR(ctx))
+		return -EIO;
+	/* By default, the input name would be written to the disk */
+	tmp_str.name = (unsigned char *)name;
+	tmp_str.len = namelen;
+	if (ctx != NULL) {
+		/* Directory is encrypted */
+		res = ext4_fname_crypto_alloc_buffer(ctx,
+			&fname_crypto_str.name, &fname_crypto_str.len,
+			EXT4_NAME_LEN);
+		if (res < 0) {
+			ext4_put_fname_crypto_ctx(&ctx);
+			return -ENOMEM;
+		}
+		res = ext4_fname_usr_to_disk(ctx, iname, &fname_crypto_str);
+		if (res < 0) {
+			ext4_put_fname_crypto_ctx(&ctx);
+			ext4_fname_crypto_free_buffer(
+			    (void **)&fname_crypto_str.name);
+			return res;
+		}
+		tmp_str.name = fname_crypto_str.name;
+		tmp_str.len = fname_crypto_str.len;
+	}
 
 	nlen = EXT4_DIR_REC_LEN(de->name_len);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
-				(struct ext4_dir_entry_2 *)((char *)de + nlen);
+			(struct ext4_dir_entry_2 *)((char *)de + nlen);
 		de1->rec_len = ext4_rec_len_to_disk(rlen - nlen, buf_size);
 		de->rec_len = ext4_rec_len_to_disk(nlen, buf_size);
 		de = de1;
@@ -1683,9 +1715,14 @@ void ext4_insert_dentry(struct inode *inode,
 	de->file_type = EXT4_FT_UNKNOWN;
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
-	de->name_len = namelen;
-	memcpy(de->name, name, namelen);
+	de->name_len = tmp_str.len;
+
+	memcpy(de->name, tmp_str.name, tmp_str.len);
+	ext4_put_fname_crypto_ctx(&ctx);
+	ext4_fname_crypto_free_buffer((void **)&fname_crypto_str.name);
+	return 0;
 }
+
 /*
  * Add a new entry into a directory (leaf) block.  If de is non-NULL,
  * it points to a directory entry which is guaranteed to be large
@@ -1722,8 +1759,12 @@ static int add_dirent_to_buf(handle_t *handle, struct dentry *dentry,
 		return err;
 	}
 
-	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(inode, de, blocksize, name, namelen);
+	/* By now the buffer is marked for journaling. Due to crypto operations,
+	 * the following function call may fail */
+	err = ext4_insert_dentry(dir, inode, de, blocksize, &dentry->d_name,
+				 name, namelen);
+	if (err < 0)
+		return err;
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -1770,7 +1811,26 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	struct dx_hash_info hinfo;
 	ext4_lblk_t  block;
 	struct fake_dirent *fde;
-	int		csum_size = 0;
+	int csum_size = 0;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	struct ext4_fname_crypto_ctx *ctx = NULL;
+	struct ext4_str fname_crypto_str = {.name = NULL, .len = 0};
+	int res;
+
+	ctx = ext4_get_fname_crypto_ctx(dir, EXT4_NAME_LEN);
+	if (IS_ERR(ctx))
+		return -1;
+	if (ctx != NULL) {
+		/* Allocate buffer to hold maximum name length */
+		res = ext4_fname_crypto_alloc_buffer(ctx,
+			&fname_crypto_str.name, &fname_crypto_str.len,
+			EXT4_NAME_LEN);
+		if (res < 0) {
+			ext4_put_fname_crypto_ctx(&ctx);
+			return -1;
+		}
+	}
+#endif
 
 	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
@@ -1837,7 +1897,31 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	if (hinfo.hash_version <= DX_HASH_TEA)
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if (ctx == NULL) {
+		/* Directory is not encrypted */
+		ext4fs_dirhash(name, namelen, &hinfo);
+	} else {
+		/* Directory is encrypted */
+		res = ext4_fname_usr_to_htree(ctx, &dentry->d_name,
+					      &fname_crypto_str);
+		if (res < 0) {
+			ext4_put_fname_crypto_ctx(&ctx);
+			ext4_fname_crypto_free_buffer(
+			    (void **)&fname_crypto_str.name);
+			ext4_mark_inode_dirty(handle, dir);
+			brelse(bh);
+			return res;
+		}
+		ext4fs_dirhash(fname_crypto_str.name,
+			       fname_crypto_str.len,
+			       &hinfo);
+		ext4_put_fname_crypto_ctx(&ctx);
+		ext4_fname_crypto_free_buffer((void **)&fname_crypto_str.name);
+	}
+#else
 	ext4fs_dirhash(name, namelen, &hinfo);
+#endif
 	memset(frames, 0, sizeof(frames));
 	frame = frames;
 	frame->entries = entries;
-- 
2.3.0

