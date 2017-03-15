From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/2] ext4: rename ext4_xattr_check_names() to ext4_xattr_check_entries()
Date: Tue, 14 Mar 2017 21:50:55 -0700
Message-ID: <20170315045057.18837-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34725 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdCOEw0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Mar 2017 00:52:26 -0400
Received: by mail-pg0-f65.google.com with SMTP id b5so897478pgg.1
        for <linux-ext4@vger.kernel.org>; Tue, 14 Mar 2017 21:52:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

ext4_xattr_check_names() actually validates both the xattr names and
values, not just the names.  So rename it to ext4_xattr_check_entries()
to avoid confusion.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/xattr.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1d59895a91ee..71bf40933bbb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -167,8 +167,8 @@ ext4_xattr_handler(int name_index)
 }
 
 static int
-ext4_xattr_check_names(struct ext4_xattr_entry *entry, void *end,
-		       void *value_start)
+ext4_xattr_check_entries(struct ext4_xattr_entry *entry, void *end,
+			 void *value_start)
 {
 	struct ext4_xattr_entry *e = entry;
 
@@ -222,8 +222,8 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 		return -EFSCORRUPTED;
 	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
 		return -EFSBADCRC;
-	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
-				       bh->b_data);
+	error = ext4_xattr_check_entries(BFIRST(bh), bh->b_data + bh->b_size,
+					 bh->b_data);
 	if (!error)
 		set_buffer_verified(bh);
 	return error;
@@ -238,7 +238,7 @@ __xattr_check_inode(struct inode *inode, struct ext4_xattr_ibody_header *header,
 	if (end - (void *)header < sizeof(*header) + sizeof(u32) ||
 	    (header->h_magic != cpu_to_le32(EXT4_XATTR_MAGIC)))
 		goto errout;
-	error = ext4_xattr_check_names(IFIRST(header), end, IFIRST(header));
+	error = ext4_xattr_check_entries(IFIRST(header), end, IFIRST(header));
 errout:
 	if (error)
 		__ext4_error_inode(inode, function, line, 0,
-- 
2.12.0
