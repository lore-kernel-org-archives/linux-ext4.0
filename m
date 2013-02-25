From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] libext2fs: Fix return value in ext2fs_test_block_bitmap_range2()
Date: Mon, 25 Feb 2013 16:55:06 +0100
Message-ID: <1361807708-15871-3-git-send-email-jack@suse.cz>
References: <1361807708-15871-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759868Ab3BYPzP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 10:55:15 -0500
In-Reply-To: <1361807708-15871-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We used return without a return value in
ext2fs_test_block_bitmap_range2() despite the fuction returns int.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 lib/ext2fs/gen_bitmap64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 42a97d4..44ac499 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -658,7 +658,7 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_TEST, block,
 				   bmap->description);
-		return;
+		return EINVAL;
 	}
 
 	return bmap->bitmap_ops->test_clear_bmap_extent(bmap, block, num);
-- 
1.7.1

