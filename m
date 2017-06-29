From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] ext4: have ext4_xattr_set_handle() allocate journal credits
Date: Wed, 28 Jun 2017 17:50:29 -0700
Message-ID: <20170629005029.13302-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently, callers of ext4_xattr_set_handle() are expected to allocate
journal credits for setting extended attributes. ext4_xattr_set_credits()
helps them figure out necessary credits. ext4_xattr_set_handle()
performs a sufficient credits check before starting data updates.

This model works fine for callers that start the transaction handle
themselves, such as ext4_xattr_set(). Other callers like ext4_set_context()
and __ext4_set_acl() use transaction handles that were started by outer
scopes so for this to work properly we would have to involve outer scope
callers to incorporate xattr credits.

Also, existing sufficient credits check in ext4_xattr_set_handle()
ignores the fact that allocated credits may have been intended for
operations other than setting extended attributes. So in theory
ext4_xattr_set_handle() may finish successfully but have also depleted
the journal credits that were supposed to be used by other operations
afterwards.

In this patch, responsibility of allocating journal credits is moved to
ext4_xattr_set_handle(). It tries to extend the journal credits as
needed or will restart the transaction handle if extend doesn't work.

Fixes: 021264a98d700e8 ("ext4: improve journal credit handling in set xattr paths")

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/acl.c   | 10 +++-------
 fs/ext4/super.c |  9 +++------
 fs/ext4/xattr.c | 39 +++++++--------------------------------
 fs/ext4/xattr.h |  2 --
 4 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8db03e5c78bc..537a469d8039 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -231,18 +231,14 @@ int
 ext4_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	handle_t *handle;
-	int error, credits, retries = 0;
-	size_t acl_size = acl ? ext4_acl_size(acl->a_count) : 0;
+	int error, retries = 0;
 
 	error = dquot_initialize(inode);
 	if (error)
 		return error;
 retry:
-	error = ext4_xattr_set_credits(inode, acl_size, &credits);
-	if (error)
-		return error;
-
-	handle = ext4_journal_start(inode, EXT4_HT_XATTR, credits);
+	/* ext4_xattr_set_handle() allocates journal credits if necessary. */
+	handle = ext4_journal_start(inode, EXT4_HT_XATTR, 0 /* credits */);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 56c971807df5..96d4b5296fa0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1150,7 +1150,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 							void *fs_data)
 {
 	handle_t *handle = fs_data;
-	int res, res2, credits, retries = 0;
+	int res, res2, retries = 0;
 
 	/*
 	 * Encrypting the root directory is not allowed because e2fsck expects
@@ -1194,11 +1194,8 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (res)
 		return res;
 retry:
-	res = ext4_xattr_set_credits(inode, len, &credits);
-	if (res)
-		return res;
-
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
+	/* ext4_xattr_set_handle() allocates journal credits if necessary. */
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 0 /* credits */);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 062756b4e6d8..6b909804aa5e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2253,7 +2253,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		credits = __ext4_xattr_set_credits(inode->i_sb, bh, value_len);
 		brelse(bh);
 
-		if (!ext4_handle_has_enough_credits(handle, credits)) {
+		if (ext4_xattr_ensure_credits(
+					handle, inode,
+					handle->h_buffer_credits + credits,
+					NULL /* bh */, false /* dirty */,
+					false /* block_csum */)) {
 			error = -ENOSPC;
 			goto cleanup;
 		}
@@ -2357,31 +2361,6 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	return error;
 }
 
-int ext4_xattr_set_credits(struct inode *inode, size_t value_len, int *credits)
-{
-	struct buffer_head *bh;
-	int err;
-
-	*credits = 0;
-
-	if (!EXT4_SB(inode->i_sb)->s_journal)
-		return 0;
-
-	down_read(&EXT4_I(inode)->xattr_sem);
-
-	bh = ext4_xattr_get_block(inode);
-	if (IS_ERR(bh)) {
-		err = PTR_ERR(bh);
-	} else {
-		*credits = __ext4_xattr_set_credits(inode->i_sb, bh, value_len);
-		brelse(bh);
-		err = 0;
-	}
-
-	up_read(&EXT4_I(inode)->xattr_sem);
-	return err;
-}
-
 /*
  * ext4_xattr_set()
  *
@@ -2397,18 +2376,14 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 	handle_t *handle;
 	struct super_block *sb = inode->i_sb;
 	int error, retries = 0;
-	int credits;
 
 	error = dquot_initialize(inode);
 	if (error)
 		return error;
 
 retry:
-	error = ext4_xattr_set_credits(inode, value_len, &credits);
-	if (error)
-		return error;
-
-	handle = ext4_journal_start(inode, EXT4_HT_XATTR, credits);
+	/* ext4_xattr_set_handle() allocates journal credits if necessary. */
+	handle = ext4_journal_start(inode, EXT4_HT_XATTR, 0 /* credits */);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
 	} else {
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 26119a67c8c3..f81cee5c21cc 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -152,8 +152,6 @@ extern ssize_t ext4_listxattr(struct dentry *, char *, size_t);
 extern int ext4_xattr_get(struct inode *, int, const char *, void *, size_t);
 extern int ext4_xattr_set(struct inode *, int, const char *, const void *, size_t, int);
 extern int ext4_xattr_set_handle(handle_t *, struct inode *, int, const char *, const void *, size_t, int);
-extern int ext4_xattr_set_credits(struct inode *inode, size_t value_len,
-				  int *credits);
 
 extern int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 				   struct ext4_xattr_inode_array **array,
-- 
2.13.2.725.g09c95d1e9-goog
