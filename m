From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: check if device support discard in FITRIM ioctl
Date: Tue, 15 Feb 2011 18:06:24 +0100
Message-ID: <1297789585-5986-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab1BORGa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 12:06:30 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Right now we, are relying on the fact that when we attempt to actually do
the discard, blkdev_issue_discar() returns -EOPNOTSUPP and the user is
informed that the device does not support discard.

However, in the case where the we do not hit any suitable free extent to
trim in FITRIM code, it will finish without any error. This is very
confusing, because it seems that FITRIM was successful even though the
device does not actually supports discard.

Solution: Check for the discard support before attempt to search for
free extents.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ioctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index eb3bc2f..25ba7c7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -334,12 +334,16 @@ mext_out:
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
 		struct fstrim_range range;
 		int ret = 0;
 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
+		if (!blk_queue_discard(q))
+			return -EOPNOTSUPP;
+
 		if (copy_from_user(&range, (struct fstrim_range *)arg,
 		    sizeof(range)))
 			return -EFAULT;
-- 
1.7.4

