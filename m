From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 4/7] btrfs: Use generic handlers of O_SYNC AIO DIO
Date: Thu, 29 Mar 2012 18:05:02 -0400
Message-ID: <1333058705-31512-5-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, jack@suse.cz,
	hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759310Ab2C2WFm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2012 18:05:42 -0400
In-Reply-To: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file. Although we use our own bio->end_io function, we call dio_end_io()
from it and thus, because we don't set any specific dio->end_io function,
generic code ends up calling generic_dio_end_io() which is all what we need
for proper O_SYNC AIO DIO handling.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a0b5c1..5cb3e22 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6249,7 +6249,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, DIO_SYNC_WRITES);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-- 
1.7.1

