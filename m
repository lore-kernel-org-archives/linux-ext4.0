From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: fix freeing bitmap in allocation error path
Date: Mon, 21 Mar 2011 11:13:41 +0100
Message-ID: <1300702421-4774-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab1CUKNw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Mar 2011 06:13:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_alloc_generic_bmap() error path, when new bitmap allocation
fails ext2fs_generic_bitmap should be freed, however in current state it
first frees ext2fs_generic_bitmap and then
ext2fs_generic_bitmap->description which is wrong. This commit fix the
free ordering.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/gen_bitmap64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index df095ac..8b9e4c5 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -129,8 +129,8 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 
 	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
 	if (retval) {
-		ext2fs_free_mem(&bitmap);
 		ext2fs_free_mem(&bitmap->description);
+		ext2fs_free_mem(&bitmap);
 		return retval;
 	}
 
-- 
1.7.4

