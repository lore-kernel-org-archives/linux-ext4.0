From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: fix memory leak in ext2fs_free_generic_bmap()
Date: Mon, 21 Mar 2011 11:14:00 +0100
Message-ID: <1300702440-4835-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1CUKOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 06:14:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_free_generic_bmap() when we are freeing 64-bit bitmap, we do
call free_bmap() to free backend specific bitmap structures, however we
should also free ext2fs_generic_bitmap structure as well. So this commit
fixes that and removes unnecessary assignments.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/gen_bitmap64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 8b9e4c5..f343cc7 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -153,11 +153,11 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
 
 	bmap->bitmap_ops->free_bmap(bmap);
 
-	if (bmap->description) {
+	if (bmap->description)
 		ext2fs_free_mem(&bmap->description);
-		bmap->description = 0;
-	}
-	bmap->magic = 0;
+
+	ext2fs_free_mem(&bmap);
+	bmap = NULL;
 }
 
 errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
-- 
1.7.4

