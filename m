From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 1/3] ext4: forbid i_extra_isize not divisible by 4
Date: Sat, 26 Nov 2016 22:39:44 -0800
Message-ID: <1480228786-106775-1-git-send-email-ebiggers@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Eric Biggers <ebiggers@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35612 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbcK0GlA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Nov 2016 01:41:00 -0500
Received: by mail-pf0-f177.google.com with SMTP id i88so19556611pfk.2
        for <linux-ext4@vger.kernel.org>; Sat, 26 Nov 2016 22:41:00 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

i_extra_isize not divisible by 4 is problematic for several reasons:

- It causes the in-inode xattr space to be misaligned, but the xattr
  header and entries are not declared __packed to express this
  possibility.  This may cause poor performance or incorrect code
  generation on some platforms.
- When validating the xattr entries we can read past the end of the
  inode if the size available for xattrs is not a multiple of 4.
- It allows the nonsensical i_extra_isize=1, which doesn't even leave
  enough room for i_extra_isize itself.

Therefore, update ext4_iget() to consider i_extra_isize not divisible by
4 to be an error, like the case where i_extra_isize is too large.

This also matches the rule recently added to e2fsck for determining
whether an inode has valid i_extra_isize.

This patch shouldn't have any noticeable effect on
non-corrupted/non-malicious filesystems, since the size of ext4_inode
has always been a multiple of 4.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/inode.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 861f848..bc99ebe 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4564,10 +4564,12 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		ei->i_extra_isize = le16_to_cpu(raw_inode->i_extra_isize);
 		if (EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize >
-		    EXT4_INODE_SIZE(inode->i_sb)) {
-			EXT4_ERROR_INODE(inode, "bad extra_isize (%u != %u)",
-				EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize,
-				EXT4_INODE_SIZE(inode->i_sb));
+			EXT4_INODE_SIZE(inode->i_sb) ||
+		    (ei->i_extra_isize & 3)) {
+			EXT4_ERROR_INODE(inode,
+					 "bad extra_isize %u (inode size %u)",
+					 ei->i_extra_isize,
+					 EXT4_INODE_SIZE(inode->i_sb));
 			ret = -EFSCORRUPTED;
 			goto bad_inode;
 		}
@@ -4685,6 +4687,7 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 		if (ei->i_extra_isize == 0) {
 			/* The extra space is currently unused. Use it. */
+			BUILD_BUG_ON(sizeof(struct ext4_inode) & 3);
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
 					    EXT4_GOOD_OLD_INODE_SIZE;
 		} else {
-- 
2.8.0.rc3.226.g39d4020

