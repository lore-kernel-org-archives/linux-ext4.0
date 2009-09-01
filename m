From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: avoid overflow in pass5 check_block_end()
Date: Tue, 01 Sep 2009 17:40:28 -0500
Message-ID: <4A9DA2DC.10001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZIAWk1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Sep 2009 18:40:27 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n81MeTZl031851
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 18:40:29 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id n81MeSub000422
	for <linux-ext4@vger.kernel.org>; Tue, 1 Sep 2009 18:40:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When making a filesystem as in:

mke2fs -E lazy_itable_init=1 -O uninit_bg -b 4096 bigfile 4294967298

a subsequent fsck would result in:

Pass 5: Checking group summary information
Internal error: fudging end of bitmap (3)
e2fsck: aborted

This is because check_block_end() was overflowing in the calculation
for "end", and giving it a value of -1 (0xFFFF....) which eventually
ended up tripping up a test in ext2fs_fudge_generic_bmap_end,

        if (end > bitmap->real_end)
                return neq;

Fix another such error in read_bitmaps() as well.

lib/ext2fs/imager.c likely has similar problems but it looks like
it has no 64-bit treatment at all yet.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Applies to pu branch.

Index: e2fsprogs/e2fsck/pass5.c
===================================================================
--- e2fsprogs.orig/e2fsck/pass5.c
+++ e2fsprogs/e2fsck/pass5.c
@@ -662,7 +662,7 @@ static void check_block_end(e2fsck_t ctx
 	clear_problem_context(&pctx);
 
 	end = ext2fs_get_block_bitmap_start2(fs->block_map) +
-		(EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count) - 1;
+		((blk64_t)EXT2_BLOCKS_PER_GROUP(fs->super) * fs->group_desc_count) - 1;
 	pctx.errcode = ext2fs_fudge_block_bitmap_end2(fs->block_map, end,
 						     &save_blocks_count);
 	if (pctx.errcode) {
Index: e2fsprogs/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/rw_bitmaps.c
+++ e2fsprogs/lib/ext2fs/rw_bitmaps.c
@@ -212,7 +212,7 @@ static errcode_t read_bitmaps(ext2_filsy
 		}
 		blk = (fs->image_header->offset_blockmap /
 		       fs->blocksize);
-		blk_cnt = EXT2_BLOCKS_PER_GROUP(fs->super) *
+		blk_cnt = (blk64_t)EXT2_BLOCKS_PER_GROUP(fs->super) *
 			fs->group_desc_count;
 		while (block_nbytes > 0) {
 			retval = io_channel_read_blk64(fs->image_io, blk++,


