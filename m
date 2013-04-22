From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: only use override function when reading an 128 byte inode
Date: Sun, 21 Apr 2013 23:56:09 -0400
Message-ID: <1366602969-26187-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43364 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137Ab3DVD4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 23:56:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_read_inode_full() function should not use fs->read_inode()
if the caller has requested more than the base 128 byte inode
structure and the inode size is greater than 128 bytes.  Otherwise the
caller won't get all of the bytes that they were asking for, since
there's no way for the fs->read_inode override function can know what
the size of the buffer passed to ext2fs_read_inode_full().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 77fc447..fd72d4c 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -533,7 +533,9 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	/* Check to see if user has an override function */
-	if (fs->read_inode) {
+	if (fs->read_inode &&
+	    ((bufsize == sizeof(struct ext2_inode)) ||
+	     (EXT2_INODE_SIZE(fs->super) == sizeof(struct ext2_inode)))) {
 		retval = (fs->read_inode)(fs, ino, inode);
 		if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
 			return retval;
-- 
1.7.12.rc0.22.gcdd159b

