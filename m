From: darrick.wong@oracle.com
Subject: (unknown)
Date: Tue, 20 Nov 2012 02:07:43 -0600
Message-ID: <201211200807.qAK87hOc002722@acsmt358.oracle.com>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27499 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTIH6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 03:07:58 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From nobody Mon Nov 19 23:51:14 2012
Subject: [PATCH 5/9] btrfs: Use generic handlers of O_SYNC AIO DIO
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com, jmoyer@redhat.com,
 bpm@sgi.com, viro@zeniv.linux.org.uk, jack@suse.cz
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
 djwong+kernel@djwong.org
Date: Mon, 19 Nov 2012 23:51:14 -0800
Message-ID: <20121120075114.25270.85716.stgit@blackbox.djwong.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file. Although we use our own bio->end_io function, we call dio_end_io()
from it and thus, because we don't set any specific dio->end_io function,
generic code ends up calling generic_dio_end_io() which is all what we need
for proper O_SYNC AIO DIO handling.

From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
[darrick.wong@oracle.com: Don't issue flush if aio is queued]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/file.c  |    2 +-
 fs/btrfs/inode.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..37b5bb3 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1495,7 +1495,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	 * one running right now.
 	 */
 	BTRFS_I(inode)->last_trans = root->fs_info->generation + 1;
-	if (num_written > 0 || num_written == -EIOCBQUEUED) {
+	if (num_written > 0) {
 		err = generic_write_sync(file, pos, num_written);
 		if (err < 0 && num_written > 0)
 			num_written = err;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..c8b6049 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6579,7 +6579,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	return __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, DIO_SYNC_WRITES);
 }
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,


