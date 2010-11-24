From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2fsprogs: fix possible mem-leak in ext2fs_free_generic_bmap()
Date: Wed, 24 Nov 2010 12:46:38 +0100
Message-ID: <1290599198-5280-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab0KXLqq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Nov 2010 06:46:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext2fs_free_generic_bmap is supposed to free the ext2fs_generic_bitmap
structure, however it frees just the memory allocated to the members of
the structure but not the memory allocated for the structure itself.
This commit fixes it with simple oneliner by adding free() at the end of
the ext2fs_free_generic_bmap().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/gen_bitmap64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9f23b92..f46f048 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -158,6 +158,7 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
 		bmap->description = 0;
 	}
 	bmap->magic = 0;
+	free(bmap);
 }
 
 errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
-- 
1.7.2.3

