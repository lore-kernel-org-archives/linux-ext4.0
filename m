From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] e2fsck: Fix segmentation fault when checking a file system
Date: Wed, 17 Mar 2010 13:48:12 -0400
Message-ID: <E1NrxLo-0004P2-Dj@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0CQRsz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Mar 2010 13:48:55 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Murphy's Law says that this report would come in *just* after I release
1.41.11.  :-)

						- Ted

>From 19f433a5214e720a95bdbf78bdcdca353c25b770 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Wed, 17 Mar 2010 13:32:52 -0400
Subject: [PATCH] e2fsck: Fix segmentation fault when checking a file system

If a corrupted file system causes us to want to delete an extent, and
that causes us to want to release a block in e2fsck pass #1, it would
be preferable if e2fsck didn't seg fault.  This tends to get users
craky, as users are wont to do.  :-)

Thanks to Dirk Reiners for reporting this bug:

e2fsck crashes fixing a corrupted 3.5 TB filesystem:

0x0000000000432002 in ext2fs_unmark_generic_bitmap (bitmap=0x0, bitno=623386749)
at gen_bitmap.c:183
183             if ((bitno < bitmap->start) || (bitno > bitmap->end)) {
(gdb) bt
bitno=623386749) at gen_bitmap.c:183
block=623386749) at ../../lib/ext2fs/bitops.h:319
inuse=-1) at alloc_stats.c:78
extent.c:1509
pb=0x7fffffffdfe0, start_block=0, ehandle=0x6dcf50) at pass1.c:1709
pb=0x7fffffffdfe0, start_block=0, ehandle=0x6dcf50) at pass1.c:1737
pctx=0x7fffffffe100, pb=0x7fffffffdfe0) at pass1.c:1842
block_buf=0x6c4330 "\373\212#") at pass1.c:1920

The source of the NULL bitmap is fs on stack frame 2:

(gdb) up 2
inuse=-1) at alloc_stats.c:78
78                      ext2fs_unmark_block_bitmap(fs->block_map, blk);

Addresses-SourceForge-Bug: #2971800

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 130b3f6..3c6f91c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1706,6 +1706,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
 			if (fix_problem(ctx, problem, pctx)) {
+				e2fsck_read_bitmaps(ctx);
 				pctx->errcode =
 					ext2fs_extent_delete(ehandle, 0);
 				if (pctx->errcode) {
-- 
1.6.6.1.1.g974db.dirty

