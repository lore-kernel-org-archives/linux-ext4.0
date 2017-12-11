From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: add missing error check in __ext4_new_inode()
Date: Mon, 11 Dec 2017 12:52:47 -0500
Message-ID: <20171211175247.5564-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59506 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdLKRwv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Dec 2017 12:52:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's possible for ext4_get_acl() to return an ERR_PTR.  So we need to
add a check for this case in __ext4_new_inode().  Otherwise on an
error we can end up oops the kernel.

This was getting triggered by xfstests generic/388, which is a test
which exercises the shutdown code path.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b4267d72f249..b32cf263750d 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -816,6 +816,8 @@ struct inode *__ext4_new_inode(handle_t *handle, struct inode *dir,
 #ifdef CONFIG_EXT4_FS_POSIX_ACL
 		struct posix_acl *p = get_acl(dir, ACL_TYPE_DEFAULT);
 
+		if (IS_ERR(p))
+			return ERR_CAST(p);
 		if (p) {
 			int acl_size = p->a_count * sizeof(ext4_acl_entry);
 
-- 
2.11.0.rc0.7.gbe5a750
