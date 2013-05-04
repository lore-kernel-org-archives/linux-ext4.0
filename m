From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libext2fs: fix return value
Date: Sat,  4 May 2013 01:05:54 -0400
Message-ID: <1367643954-31340-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48872 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3EDFFx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 01:05:53 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 107A033DBE6
	for <linux-ext4@vger.kernel.org>; Sat,  4 May 2013 05:05:52 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_test_block_bitmap_range2 func is not a void, so make sure we
return a value.  I picked EINVAL as it looks like what other things in
this func use.

URL: http://bugs.gentoo.org/467986
Reported-by: Vicente Olivert Riera <vincent@gentoo.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/ext2fs/gen_bitmap64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.8.2.1

