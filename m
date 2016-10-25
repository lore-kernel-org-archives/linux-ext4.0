From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: remove parameter from ext4_xattr_ibody_set()
Date: Tue, 25 Oct 2016 18:13:43 -0400
Message-ID: <20161025221343.GB15502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35924 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752476AbcJYWI6 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Oct 2016 18:08:58 -0400
Received: by mail-qk0-f193.google.com with SMTP id z190so16640746qkc.3
        for <linux-ext4@vger.kernel.org>; Tue, 25 Oct 2016 15:08:58 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The parameter "handle" isn't used.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/xattr.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index d77be9e..2ee1378 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1109,7 +1109,7 @@ int ext4_xattr_ibody_inline_set(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-static int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
+static int ext4_xattr_ibody_set(struct inode *inode,
 				struct ext4_xattr_info *i,
 				struct ext4_xattr_ibody_find *is)
 {
@@ -1216,7 +1216,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 	}
 	if (!value) {
 		if (!is.s.not_found)
-			error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+			error = ext4_xattr_ibody_set(inode, &i, &is);
 		else if (!bs.s.not_found)
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
 	} else {
@@ -1227,7 +1227,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!bs.s.not_found && ext4_xattr_value_same(&bs.s, &i))
 			goto cleanup;
 
-		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
+		error = ext4_xattr_ibody_set(inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
@@ -1242,8 +1242,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 				goto cleanup;
 			if (!is.s.not_found) {
 				i.value = NULL;
-				error = ext4_xattr_ibody_set(handle, inode, &i,
-							     &is);
+				error = ext4_xattr_ibody_set(inode, &i, &is);
 			}
 		}
 	}
@@ -1384,7 +1383,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 		goto out;
 
 	/* Remove the chosen entry from the inode */
-	error = ext4_xattr_ibody_set(handle, inode, &i, is);
+	error = ext4_xattr_ibody_set(inode, &i, is);
 	if (error)
 		goto out;
 
-- 
2.1.4

