From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 20/32] ext4: improve journal credit handling in set xattr paths
Date: Wed, 21 Jun 2017 14:21:30 -0700
Message-ID: <20170621212142.16581-20-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34007 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbdFUVWR (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:17 -0400
Received: by mail-pf0-f175.google.com with SMTP id s66so90499356pfs.1
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:17 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Both ext4_set_acl() and ext4_set_context() need to be made aware of
ea_inode feature when it comes to credits calculation.

Also add a sufficient credits check in ext4_xattr_set_handle() right
after xattr write lock is grabbed. Original credits calculation is done
outside the lock so there is a possiblity that the initially calculated
credits are not sufficient anymore.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
v2: fixed checkpatch.pl warning about replacing spaces with tab

 fs/ext4/acl.c       |  7 ++++---
 fs/ext4/ext4_jbd2.h | 14 --------------
 fs/ext4/super.c     |  6 +++---
 fs/ext4/xattr.c     | 55 +++++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/xattr.h     |  1 +
 5 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 3ec0e46de95f..74f7ac539e00 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -231,14 +231,15 @@ int
 ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	handle_t *handle;
-	int error, retries = 0;
+	int error, credits, retries = 0;
+	size_t acl_size = acl ? ext4_acl_size(acl->a_count) : 0;
 
 	error = dquot_initialize(inode);
 	if (error)
 		return error;
 retry:
-	handle = ext4_journal_start(inode, EXT4_HT_XATTR,
-				    ext4_jbd2_credits_xattr(inode));
+	credits = ext4_xattr_set_credits(inode, acl_size);
+	handle = ext4_journal_start(inode, EXT4_HT_XATTR, credits);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index f97611171023..a5bda70feed5 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -104,20 +104,6 @@
 #define EXT4_MAXQUOTAS_INIT_BLOCKS(sb) (EXT4_MAXQUOTAS*EXT4_QUOTA_INIT_BLOCKS(sb))
 #define EXT4_MAXQUOTAS_DEL_BLOCKS(sb) (EXT4_MAXQUOTAS*EXT4_QUOTA_DEL_BLOCKS(sb))
 
-static inline int ext4_jbd2_credits_xattr(struct inode *inode)
-{
-	int credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
-
-	/*
-	 * In case of inline data, we may push out the data to a block,
-	 * so we need to reserve credits for this eventuality
-	 */
-	if (ext4_has_inline_data(inode))
-		credits += ext4_writepage_trans_blocks(inode) + 1;
-	return credits;
-}
-
-
 /*
  * Ext4 handle operation types -- for logging purposes
  */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d37c81f327e7..b02a23ec92ca 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1143,7 +1143,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 							void *fs_data)
 {
 	handle_t *handle = fs_data;
-	int res, res2, retries = 0;
+	int res, res2, credits, retries = 0;
 
 	res = ext4_convert_inline_data(inode);
 	if (res)
@@ -1178,8 +1178,8 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (res)
 		return res;
 retry:
-	handle = ext4_journal_start(inode, EXT4_HT_MISC,
-			ext4_jbd2_credits_xattr(inode));
+	credits = ext4_xattr_set_credits(inode, len);
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 97d33ecf0818..fd017faaf221 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1473,6 +1473,17 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 
 	ext4_write_lock_xattr(inode, &no_expand);
 
+	/* Check journal credits under write lock. */
+	if (ext4_handle_valid(handle)) {
+		int credits;
+
+		credits = ext4_xattr_set_credits(inode, value_len);
+		if (!ext4_handle_has_enough_credits(handle, credits)) {
+			error = -ENOSPC;
+			goto cleanup;
+		}
+	}
+
 	error = ext4_reserve_inode_write(handle, inode, &is.iloc);
 	if (error)
 		goto cleanup;
@@ -1570,6 +1581,36 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	return error;
 }
 
+int ext4_xattr_set_credits(struct inode *inode, size_t value_len)
+{
+	struct super_block *sb = inode->i_sb;
+	int credits;
+
+	if (!EXT4_SB(sb)->s_journal)
+		return 0;
+
+	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
+
+	/*
+	 * In case of inline data, we may push out the data to a block,
+	 * so we need to reserve credits for this eventuality
+	 */
+	if (ext4_has_inline_data(inode))
+		credits += ext4_writepage_trans_blocks(inode) + 1;
+
+	if (ext4_has_feature_ea_inode(sb)) {
+		int nrblocks = (value_len + sb->s_blocksize - 1) >>
+					sb->s_blocksize_bits;
+
+		/* For new inode */
+		credits += EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + 3;
+
+		/* For data blocks of EA inode */
+		credits += ext4_meta_trans_blocks(inode, nrblocks, 0);
+	}
+	return credits;
+}
+
 /*
  * ext4_xattr_set()
  *
@@ -1585,24 +1626,14 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	handle_t *handle;
 	struct super_block *sb = inode->i_sb;
 	int error, retries = 0;
-	int credits = ext4_jbd2_credits_xattr(inode);
+	int credits;
 
 	error = dquot_initialize(inode);
 	if (error)
 		return error;
 
-	if (ext4_has_feature_ea_inode(sb)) {
-		int nrblocks = (value_len + sb->s_blocksize - 1) >>
-					sb->s_blocksize_bits;
-
-		/* For new inode */
-		credits += EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + 3;
-
-		/* For data blocks of EA inode */
-		credits += ext4_meta_trans_blocks(inode, nrblocks, 0);
-	}
