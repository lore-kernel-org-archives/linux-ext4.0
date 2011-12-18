From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 07/10] libext2fs: use the rbtree bitmap by default when initializing a file system
Date: Sun, 18 Dec 2011 01:42:35 -0500
Message-ID: <1324190558-7436-8-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50565 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This change causes the max resident memory of mke2fs, as reported by
/usr/bin/time, to drop from 9296k to 5328k when formatting a 25
gig volume.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/initialize.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index b050a0a..a63ea18 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -112,6 +112,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	fs->magic = EXT2_ET_MAGIC_EXT2FS_FILSYS;
 	fs->flags = flags | EXT2_FLAG_RW;
 	fs->umask = 022;
+	fs->default_bitmap_type = EXT2FS_BMAP64_RBTREE;
 #ifdef WORDS_BIGENDIAN
 	fs->flags |= EXT2_FLAG_SWAP_BYTES;
 #endif
-- 
1.7.8.11.gefc1f.dirty

