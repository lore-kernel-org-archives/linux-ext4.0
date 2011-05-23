From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2] ext4: use truncate_setsize() unconditionally
Date: Mon, 23 May 2011 15:19:01 -0400
Message-ID: <1306178341-17632-1-git-send-email-tytso@mit.edu>
References: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>
Cc: jiayingz@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49577 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933001Ab1EWTTF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 15:19:05 -0400
In-Reply-To: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In commit c8d46e41 (ext4: Add flag to files with blocks intentionally
past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_truncate()
before calling vmtruncate().  This caused any allocated but unwritten
blocks created by calling fallocate() with the FALLOC_FL_KEEP_SIZE
flag to be dropped.  This was done to make to make sure that
EOFBLOCKS_FL would not be cleared while still leaving blocks past
i_size allocated.  This was not necessary, since ext4_truncate()
guarantees that blocks past i_size will be dropped, even in the case
where truncate() has increased i_size before calling ext4_truncate().

So fix this by removing the EOFBLOCKS_FL special case treatment in
ext4_setattr().  In addition, use truncate_setsize() followed by a
call to ext4_truncate() instead of using vmtruncate().  This is more
efficient since it skips the call to inode_newsize_ok(), which has
been checked already by inode_change_ok().  This is also in a win in
the case where EOFBLOCKS_FL is set since it avoids calling
ext4_truncate() twice.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 Jiayingz pointed out that in the case where we fallocate 12k, write 4k, and
 then truncate to 4k, we should discard the excess fallocate'd blocks.  So if
 attr->ia_size == inode.i_size, we can skip the truncate_setsize() call, but
 if the EOFBLOCKS_FL flag is set, we should still call ext4_truncate().

 fs/ext4/inode.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index df3fb20..2e95819 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5363,8 +5363,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (S_ISREG(inode->i_mode) &&
 	    attr->ia_valid & ATTR_SIZE &&
-	    (attr->ia_size < inode->i_size ||
-	     (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))) {
+	    (attr->ia_size < inode->i_size)) {
 		handle_t *handle;
 
 		handle = ext4_journal_start(inode, 3);
@@ -5398,14 +5397,15 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 				goto err_out;
 			}
 		}
-		/* ext4_truncate will clear the flag */
-		if ((ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS)))
-			ext4_truncate(inode);
 	}
 
-	if ((attr->ia_valid & ATTR_SIZE) &&
-	    attr->ia_size != i_size_read(inode))
-		rc = vmtruncate(inode, attr->ia_size);
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (attr->ia_size != i_size_read(inode)) {
+			truncate_setsize(inode, attr->ia_size);
+			ext4_truncate(inode);
+		} else if (ext4_test_inode_flag(inode, EXT4_INODE_EOFBLOCKS))
+			ext4_truncate(inode);
+	}
 
 	if (!rc) {
 		setattr_copy(inode, attr);
-- 
1.7.3.1

