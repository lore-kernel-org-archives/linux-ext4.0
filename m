From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 19/22] ext4 crypto: enable filename encryption
Date: Thu,  2 Apr 2015 18:10:56 -0400
Message-ID: <1428012659-12709-20-git-send-email-tytso@mit.edu>
References: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Cc: jaegeuk@kernel.org, mhalcrow@google.com,
	Uday Savagaonkar <savagaon@google.com>,
	Ildar Muslukhov <ildarm@google.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47935 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbbDBWMT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Apr 2015 18:12:19 -0400
In-Reply-To: <1428012659-12709-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michael Halcrow <mhalcrow@google.com>

Change-Id: I1057e08bf05741b963705f2850710ec5d7d8bd72
Signed-off-by: Uday Savagaonkar <savagaon@google.com>
Signed-off-by: Ildar Muslukhov <ildarm@google.com>
Signed-off-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir.c    | 83 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/ext4/ialloc.c | 21 ++++++++++++--
 2 files changed, 96 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index f67f955..a77900f 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -111,6 +111,11 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	int dir_has_error = 0;
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	struct ext4_fname_crypto_ctx *enc_ctx = NULL;
+	struct ext4_str fname_crypto_str = {.name = NULL, .len = 0};
+#endif
+	int res;
 
 	if (is_dx_dir(inode)) {
 		err = ext4_dx_readdir(file, ctx);
@@ -127,11 +132,27 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 
 	if (ext4_has_inline_data(inode)) {
 		int has_inline_data = 1;
-		int ret = ext4_read_inline_dir(file, ctx,
+		res = ext4_read_inline_dir(file, ctx,
 					   &has_inline_data);
 		if (has_inline_data)
-			return ret;
+			return res;
+	}
+
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	enc_ctx = ext4_get_fname_crypto_ctx(inode, EXT4_NAME_LEN);
+	if (IS_ERR(enc_ctx))
+		return PTR_ERR(enc_ctx);
+	if (enc_ctx) {
+		res = ext4_fname_crypto_alloc_buffer(enc_ctx,
+						     &fname_crypto_str.name,
+						     &fname_crypto_str.len,
+						     EXT4_NAME_LEN);
+		if (res < 0) {
+			ext4_put_fname_crypto_ctx(&enc_ctx);
+			return res;
+		}
 	}
+#endif
 
 	offset = ctx->pos & (sb->s_blocksize - 1);
 
@@ -226,13 +247,53 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			offset += ext4_rec_len_from_disk(de->rec_len,
 					sb->s_blocksize);
 			if (le32_to_cpu(de->inode)) {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+				if (enc_ctx == NULL) {
+					/* Directory is not encrypted */
+					if (!dir_emit(ctx, de->name,
+					    de->name_len,
+					    le32_to_cpu(de->inode),
+					    get_dtype(sb, de->file_type))) {
+						ext4_put_fname_crypto_ctx(
+							&enc_ctx);
+						ext4_fname_crypto_free_buffer(
+							(void **)&fname_crypto_str.name);
+						brelse(bh);
+						return 0;
+					}
+				} else {
+					/* Directory is encrypted */
+					err = ext4_fname_disk_to_usr(enc_ctx,
+							de, &fname_crypto_str);
+					if (err < 0) {
+						ext4_put_fname_crypto_ctx(
+							&enc_ctx);
+						ext4_fname_crypto_free_buffer(
+							(void **)&fname_crypto_str.name);
+						brelse(bh);
+						return err;
+					}
+					if (!dir_emit(ctx,
+					    fname_crypto_str.name, err,
+					    le32_to_cpu(de->inode),
+					    get_dtype(sb, de->file_type))) {
+						ext4_put_fname_crypto_ctx(
+							&enc_ctx);
+						ext4_fname_crypto_free_buffer(
+							(void **)&fname_crypto_str.name);
+						brelse(bh);
+						return 0;
+					}
+				}
+#else
 				if (!dir_emit(ctx, de->name,
-						de->name_len,
-						le32_to_cpu(de->inode),
-						get_dtype(sb, de->file_type))) {
+					      de->name_len,
+					      le32_to_cpu(de->inode),
+					      get_dtype(sb, de->file_type))) {
 					brelse(bh);
 					return 0;
 				}
+#endif
 			}
 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
 						sb->s_blocksize);
@@ -240,10 +301,20 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		offset = 0;
 		brelse(bh);
 		if (ctx->pos < inode->i_size) {
-			if (!dir_relax(inode))
+			if (!dir_relax(inode)) {
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+				ext4_put_fname_crypto_ctx(&enc_ctx);
+				ext4_fname_crypto_free_buffer(
+						(void **)&fname_crypto_str.name);
+#endif
 				return 0;
+			}
 		}
 	}
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	ext4_put_fname_crypto_ctx(&enc_ctx);
+	ext4_fname_crypto_free_buffer((void **)&fname_crypto_str.name);
+#endif
 	return 0;
 }
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index e554ca3..8f37c9e 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1034,11 +1034,28 @@ got:
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
-
+#ifdef CONFIG_EXT4_FS_ENCRYPTION
+	if ((sbi->s_file_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID) &&
+	    (sbi->s_dir_encryption_mode == EXT4_ENCRYPTION_MODE_INVALID)) {
+		ei->i_inline_off = 0;
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+			ext4_set_inode_state(inode,
+			EXT4_STATE_MAY_INLINE_DATA);
+	} else {
+		/* Inline data and encryption are incompatible
+		 * We turn off inline data since encryption is enabled */
+		ei->i_inline_off = 1;
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+			EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+			ext4_clear_inode_state(inode,
+			EXT4_STATE_MAY_INLINE_DATA);
+	}
+#else
 	ei->i_inline_off = 0;
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_INLINE_DATA))
 		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
