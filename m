From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: merge ext4_xattr_list() into ext4_listxattr()
Date: Tue, 14 Mar 2017 21:33:25 -0700
Message-ID: <20170315043325.6764-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34800 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdCOEe3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Mar 2017 00:34:29 -0400
Received: by mail-pf0-f193.google.com with SMTP id o126so823835pfb.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2017 21:34:28 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

There's no difference between ext4_xattr_list() and ext4_listxattr(), so
merge them together and just have ext4_listxattr().  Some years ago they
took different arguments, but that's no longer the case.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/xattr.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 67636acf7624..1d59895a91ee 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -78,8 +78,6 @@ static struct buffer_head *ext4_xattr_cache_find(struct inode *,
 						 struct mb_cache_entry **);
 static void ext4_xattr_rehash(struct ext4_xattr_header *,
 			      struct ext4_xattr_entry *);
-static int ext4_xattr_list(struct dentry *dentry, char *buffer,
-			   size_t buffer_size);
 
 static const struct xattr_handler *ext4_xattr_handler_map[] = {
 	[EXT4_XATTR_INDEX_USER]		     = &ext4_xattr_user_handler,
@@ -168,17 +166,6 @@ ext4_xattr_handler(int name_index)
 	return handler;
 }
 
-/*
- * Inode operation listxattr()
- *
- * d_inode(dentry)->i_mutex: don't care
- */
-ssize_t
-ext4_listxattr(struct dentry *dentry, char *buffer, size_t size)
-{
-	return ext4_xattr_list(dentry, buffer, size);
-}
