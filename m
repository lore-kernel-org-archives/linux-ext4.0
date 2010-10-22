From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] block: Make blkdev_issue_discard() interruptible
Date: Fri, 22 Oct 2010 13:06:09 +0200
Message-ID: <1287745569-11705-1-git-send-email-lczerner@redhat.com>
References: <x49k4lb1oah.fsf@segfault.boston.devel.redhat.com>
Cc: jmoyer@redhat.com, tytso@mit.edu, sandeen@redhat.com,
	adilger@dilger.ca, axboe@kernel.dk, linux-kernel@vger.kernel.org,
	lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0JVLGW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 07:06:22 -0400
In-Reply-To: <x49k4lb1oah.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since the discard may take quite long time, especially with really big
extents (like the whole device for example), it would be nice to give to
users the opportunity to abort it. This is especially useful for mkfs,
when user can not know in advance how long it will take.

In conjunction with mke2fs patch "Inform user about ongoing discard"
it gives the user all the comfort of being informed about discard and
being able to abort the operation.

It has been tested on SSD device where mkfs.ext4 without -K takes rally
long due to discarding whole device. With this patch I am able to
successfully terminate that with ctrl+c. Aside that discard functionality
remains unchanged.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 block/blk-lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c392029..54994e7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -101,6 +101,9 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		else if (!bio_flagged(bio, BIO_UPTODATE))
 			ret = -EIO;
 		bio_put(bio);
+
+		if (unlikely(fatal_signal_pending(current)))
+			ret = -ERESTARTSYS;
 	}
 
 	return ret;
-- 
1.7.2.3

