From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] libext2fs: add stricter checks on the inode size in ext2fs_open2()
Date: Sun, 23 Jul 2017 00:50:33 -0400
Message-ID: <20170723045035.26019-3-tytso@mit.edu>
References: <20170723045035.26019-1-tytso@mit.edu>
Cc: abuchbinder@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:51420 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdGWEup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Jul 2017 00:50:45 -0400
In-Reply-To: <20170723045035.26019-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An inode size larger than the block size can cause userspace programs
to crash.

This problem was found using American Fuzzy Lop.

Reported-by: Adam Buchbinder <abuchbinder@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/openfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 0362b2839..da03bc147 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -121,6 +121,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	blk64_t		group_block, blk;
 	char		*dest, *cp;
 	int		group_zero_adjust = 0;
+	int		inode_size;
 #ifdef WORDS_BIGENDIAN
 	unsigned int	groups_per_block;
 	struct ext2_group_desc *gdp;
@@ -297,7 +298,10 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		goto cleanup;
 	}
 	fs->fragsize = fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
-	if (EXT2_INODE_SIZE(fs->super) < EXT2_GOOD_OLD_INODE_SIZE) {
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	if ((inode_size < EXT2_GOOD_OLD_INODE_SIZE) ||
+	    (inode_size > fs->blocksize) ||
+	    (inode_size & (inode_size - 1))) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
-- 
2.11.0.rc0.7.gbe5a750
