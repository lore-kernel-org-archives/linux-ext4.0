From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] block: Make blkdev_issue_discard() interruptible
Date: Wed, 15 Sep 2010 16:32:41 +0200
Message-ID: <1284561161-22278-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, lczerner@redhat.com,
	linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0IOOcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 10:32:46 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the discard may take quite long time, especially with really big
extents (like the whole device for example), it would be nice to give to
users the opportunity to abort it. This is especially useful for mkfs,
when user can not know in advance how long it will take.

In conjunction with mke2fs patch "Inform user about ongoing discard"
it gives the user all the comfort of being informed about discard and
being able to abort the operation.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 block/blk-lib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..4f54a1a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -102,6 +102,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		else if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 	}
 	return ret;
 out_free_page:
-- 
1.7.2.2

