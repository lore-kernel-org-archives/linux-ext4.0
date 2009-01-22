From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext2fs_new_inode(): Add sanity check to assure a valid inode number
Date: Thu, 22 Jan 2009 16:32:24 -0500
Message-ID: <1232659946-10073-2-git-send-email-tytso@mit.edu>
References: <20090122211224.GJ14966@mit.edu>
 <1232659946-10073-1-git-send-email-tytso@mit.edu>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44560 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZAVVca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 16:32:30 -0500
In-Reply-To: <1232659946-10073-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a sanity check to makesure that even if the superblock field
s_first_inode is insane, that we won't return an invalid inode number.
(The function will return the error EXT2_ET_INODE_ALLOC_FAIL in that
case.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/alloc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index be2b56b..ade5149 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -120,6 +120,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 	start_inode = (dir_group * EXT2_INODES_PER_GROUP(fs->super)) + 1;
 	if (start_inode < EXT2_FIRST_INODE(fs->super))
 		start_inode = EXT2_FIRST_INODE(fs->super);
+	if (start_inode > fs->super->s_inodes_count)
+		return EXT2_ET_INODE_ALLOC_FAIL;
 	i = start_inode;
 
 	do {
-- 
1.6.0.4.8.g36f27.dirty

