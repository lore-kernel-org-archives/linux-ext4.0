From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 2/2][64-BIT] ext2fs_group_first_block2(): 32-bit truncation.
Date: Sat, 18 Apr 2009 02:05:13 -0400
Message-ID: <30396.1240034713@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:49828 "EHLO
	QMTA09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZDRGFA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 02:05:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_group_first_block2() returns the product of the group number
and the number of blocks per group (from the superblock). Unfortunately,
both of these are 32-bit quantities, so the multiplication result is
also 32 bits wide. It is then returned as a 64-bit quantity, but by then,
it's too late.

Cast one of the operands to blk64_t, so the multiplication will be done
in 64 bits.

e2fsck was complaining about a group that was marked BLOCK_UNINIT, but
had blocks in use (it turned out that a different group had blocks in
use, but the block numbers of the two different groups differed by
2^32, so this bug conflated them). With this change, this complaint
goes away. In addition, dumpe2fs produces the right blocks for all the
groups, whereas it was wrapping them at the 32-bit boundary previously.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/blknum.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index b9666fb..fd56d53 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -28,7 +28,7 @@ dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t blk)
 blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group)
 {
 	return fs->super->s_first_data_block +
-		(group * fs->super->s_blocks_per_group);
+		((blk64_t)group * fs->super->s_blocks_per_group);
 }
 
 /*
-- 
1.6.0.6

