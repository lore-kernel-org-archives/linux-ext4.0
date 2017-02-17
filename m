From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] ext4: inherit encryption xattr before other xattrs
Date: Fri, 17 Feb 2017 15:33:21 -0800
Message-ID: <20170217233321.108637-1-ebiggers3@gmail.com>
Cc: linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35019 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964847AbdBQXhA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Feb 2017 18:37:00 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When using both encryption and SELinux (or another feature that requires
an xattr per file) on a filesystem with 256-byte inodes, each file's
xattrs usually spill into an external xattr block.  Currently, the
xattrs are inherited in the order ACL, security, then encryption.
Therefore, if spillage occurs, the encryption xattr will always end up
in the external block.  This is not ideal because the encryption xattrs
contain a nonce, so they will always be unique and will prevent the
external xattr blocks from being deduplicated.

To improve the situation, change the inheritance order to encryption,
ACL, then security.  This gives the encryption xattr a better chance to
be stored in-inode, allowing the other xattr(s) to be deduplicated.

Note that it may be better for userspace to format the filesystem with
512-byte inodes in this case.  However, it's not the default.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/ialloc.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b14bae2598bc..0304e28c2014 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1096,6 +1096,17 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 	if (err)
 		goto fail_drop;
 
+	/*
+	 * Since the encryption xattr will always be unique, create it first so
+	 * that it's less likely to end up in an external xattr block and
+	 * prevent its deduplication.
+	 */
+	if (encrypt) {
+		err = fscrypt_inherit_context(dir, inode, handle, true);
+		if (err)
+			goto fail_free_drop;
+	}
+
 	err = ext4_init_acl(handle, inode, dir);
 	if (err)
 		goto fail_free_drop;
@@ -1117,12 +1128,6 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 		ei->i_datasync_tid = handle->h_transaction->t_tid;
 	}
 
-	if (encrypt) {
-		err = fscrypt_inherit_context(dir, inode, handle, true);
-		if (err)
-			goto fail_free_drop;
-	}
