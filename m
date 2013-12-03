From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 04/10] dumpe2fs: fix printing of block offsets for 64-bit file systems
Date: Tue,  3 Dec 2013 00:10:12 -0500
Message-ID: <1386047418-32431-5-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35855 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab3LCFK0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:26 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use ext2fs_group_first_block2() instead of ext2fs_group_first_block()
to avoid dumpe2fs from printing crazy block offsets when we have block
numbers which are larger than 32 bits.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 misc/dumpe2fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 2ba1771..2464100 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -146,7 +146,7 @@ static void print_bg_rel_offset(ext2_filsys fs, blk64_t block, int itable,
 		   EXT4_FEATURE_INCOMPAT_FLEX_BG) {
 		dgrp_t flex_grp = ext2fs_group_of_blk2(fs, block);
 		printf(" (bg #%u + %u)", flex_grp,
-		       (unsigned)(block-ext2fs_group_first_block(fs,flex_grp)));
+		       (unsigned)(block-ext2fs_group_first_block2(fs,flex_grp)));
 	}
 }
 
-- 
1.8.5.rc3.362.gdf10213

