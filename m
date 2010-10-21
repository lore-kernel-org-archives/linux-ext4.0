From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] block: Make blkdev_issue_discard() interruptible
Date: Thu, 21 Oct 2010 16:34:33 +0200
Message-ID: <1287671673-11448-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, sandeen@redhat.com, adilger@dilger.ca,
	axboe@kernel.dk, linux-kernel@vger.kernel.org, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab0JUOew (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Oct 2010 10:34:52 -0400
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
index c392029..204839b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -101,6 +101,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		else if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
+
+		if (fatal_signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 	}
 
 	return ret;
-- 
1.7.2.3

