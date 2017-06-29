From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH v2] ext4: have ext4_xattr_set_handle() allocate journal credits
Date: Wed, 28 Jun 2017 20:06:18 -0700
Message-ID: <20170629030618.5101-1-tahsin@google.com>
References: <20170629005029.13302-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35522 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdF2DGX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Jun 2017 23:06:23 -0400
Received: by mail-pf0-f177.google.com with SMTP id c73so42995690pfk.2
        for <linux-ext4@vger.kernel.org>; Wed, 28 Jun 2017 20:06:23 -0700 (PDT)
In-Reply-To: <20170629005029.13302-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
v2: Allocate 1 journal credit in ext4_set_acl() and ext4_set_context() for modifying
    inode outside ext4_xattr_set_handle() call.

 fs/ext4/acl.c   | 14 +++++++-------
 fs/ext4/super.c | 13 +++++++------
 fs/ext4/xattr.c | 39 +++++++--------------------------------
 fs/ext4/xattr.h |  2 --
 4 files changed, 21 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8db03e5c78bc..6a4c2b831699 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -231,18 +231,18 @@ int
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
+	/*
+	 * Allocate 1 journal credit to allow __ext4_set_acl() update inode
+	 * before calling ext4_xattr_set_handle(). Extended attribute related
+	 * credits are allocated by ext4_xattr_set_handle() itself.
+	 */
+	handle = ext4_journal_start(inode, EXT4_HT_XATTR, 1 /* credits */);
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 56c971807df5..74036c382b63 100644
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
@@ -1194,11 +1194,12 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (res)
 		return res;
 retry:
-	res = ext4_xattr_set_credits(inode, len, &credits);
-	if (res)
-		return res;
-
-	handle = ext4_journal_start(inode, EXT4_HT_MISC, credits);
+	/*
+	 * Allocate 1 journal credit for ext4_mark_inode_dirty() call in this
+	 * function. Extended attribute related credits are allocated by
+	 * ext4_xattr_set_handle() itself.
+	 */
+	handle = ext4_journal_start(inode, EXT4_HT_MISC, 1 /* credits */);
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
