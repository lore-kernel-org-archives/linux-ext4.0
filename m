From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] e2image: fix invalid lseek error detection
Date: Wed, 24 Aug 2011 10:00:34 +0200
Message-ID: <1314172834-18424-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab1HXIAu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Aug 2011 04:00:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In flush_l2_cache() we are using ext2fs_llseek() however we do not
properly detect the error code returned from the function, because we
are assigning it into ULL variable, hence we will not see negative
values.

Fix this by changing the type of the variable to ext2_loff_t which is
signed and hence will store negative values.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 misc/e2image.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/misc/e2image.c b/misc/e2image.c
index 83a9d02..bf0c0d4 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -759,7 +759,8 @@ static void put_used_table(struct ext2_qcow2_image *img,
 
 static void flush_l2_cache(struct ext2_qcow2_image *image)
 {
-	blk64_t offset, seek = 0;
+	blk64_t seek = 0;
+	ext2_loff_t offset;
 	struct ext2_qcow2_l2_cache *cache = image->l2_cache;
 	struct ext2_qcow2_l2_table *table = cache->used_head;
 	int fd = image->fd;
-- 
1.7.4.4

