From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] misc: fix 'zero_hugefiles = false' regression
Date: Mon,  8 May 2017 15:47:57 -0700
Message-ID: <20170508224757.94528-1-ebiggers3@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@google.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34040 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750941AbdEHWso (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 May 2017 18:48:44 -0400
Received: by mail-pf0-f196.google.com with SMTP id w69so5689564pfk.1
        for <linux-ext4@vger.kernel.org>; Mon, 08 May 2017 15:48:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

When mk_hugefiles() was switched to use ext2fs_fallocate(), it was
accidentally changed to ignore the 'zero_hugefiles = false' setting,
which should cause hugefiles to be allocated without initializing their
contents.  Fix this by only passing EXT2_FALLOCATE_ZERO_BLOCKS to
ext2fs_fallocate() when zero_hugefiles is true.

Fixes: 4f868703f6f2 ("libext2fs: use fallocate for creating journals and hugefiles")
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/mk_hugefiles.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index 71a15c5d..049c6f41 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -260,6 +260,7 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 {
 	errcode_t		retval;
 	struct ext2_inode	inode;
+	int			falloc_flags;
 
 	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
 	if (retval)
@@ -281,10 +282,11 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 	if (ext2fs_has_feature_extents(fs->super))
 		inode.i_flags |= EXT4_EXTENTS_FL;
-	retval = ext2fs_fallocate(fs,
-				  EXT2_FALLOCATE_FORCE_INIT |
-				  EXT2_FALLOCATE_ZERO_BLOCKS,
-				  *ino, &inode, goal, 0, num);
+
+	falloc_flags = EXT2_FALLOCATE_FORCE_INIT;
+	if (zero_hugefile)
+		falloc_flags |= EXT2_FALLOCATE_ZERO_BLOCKS;
+	retval = ext2fs_fallocate(fs, falloc_flags, *ino, &inode, goal, 0, num);
 	if (retval)
 		return retval;
 	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
-- 
2.13.0.rc2.291.g57267f2277-goog
