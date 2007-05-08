From: Daniel Drake <ddrake@brontes3d.com>
Subject: [PATCH e2fsprogs] get_backup_sb: Consider block size when searching for backups
Date: Tue,  8 May 2007 17:25:36 +0100 (BST)
Message-ID: <20070508162536.D3B9F7B409F@zog.reactivated.net>
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from queue04-winn.ispmail.ntl.com ([81.103.221.58]:2329 "EHLO
	queue04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965748AbXEHQu4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2007 12:50:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

I've been investigating why e2fsck refuses to restore the backup superblock
of a partition with a broken primary superblock.

The partition in question has a block size of 4096, and mke2fs reports that
backup superblocks were created on blocks 32768, 98304, 163840, ...

When running e2fsck, get_backup_sb starts by guessing a block size of 1024
and backup superblock at block 8193. I'm not sure why, but it actually finds
a superblock at this location, so returns a context with superblock 8193,
blocksize 1024. 

Later on, ext2fs_open2() tries to process this superblock. It then realises
that the block size value stored in the superblock (4096) does not match what
it was told (1024), so it bails out with EXT2_ET_UNEXPECTED_BLOCK_SIZE. fsck
aborts without fixing the partition.

The following patch solves the problem by discounting superblocks which do
not meet the currently-sought block size.
As a result, block 32768 (blocksize=4096) is now used to restore the backup,
which agrees with the first location that mke2fs listed.

This doesn't explain why a superblock backup also appears to exist at
block 8193 (blocksize=1024), which in terms of my real filesystem is actually
offset into block 2048 (blocksize=4096). I assume there is an explanation
for this...

Signed-off-by: Daniel Drake <d.drake@mmm.com>

Index: e2fsprogs-1.39/e2fsck/util.c
===================================================================
--- e2fsprogs-1.39.orig/e2fsck/util.c
+++ e2fsprogs-1.39/e2fsck/util.c
@@ -453,7 +453,8 @@ blk_t get_backup_sb(e2fsck_t ctx, ext2_f
 		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
 			ext2fs_swap_super(sb);
 #endif
-		if (sb->s_magic == EXT2_SUPER_MAGIC) {
+		if (sb->s_magic == EXT2_SUPER_MAGIC &&
+		    EXT2_BLOCK_SIZE(sb) == blocksize) {
 			ret_sb = superblock;
 			if (ctx) {
 				ctx->superblock = superblock;
