From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] btrfs: Use generic handlers of O_SYNC AIO DIO
Date: Fri, 10 Feb 2012 17:04:02 +0100
Message-ID: <1328889842-23231-5-git-send-email-jack@suse.cz>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file. Although we use our own bio->end_io function, we call dio_end_io()
from it and thus, because we don't set any specific dio->end_io function,
generic code ends up calling generic_dio_end_io() which is all what we need
for proper O_SYNC AIO DIO handling.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 32214fe..68add6e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6221,7 +6221,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
 		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+		   btrfs_submit_direct, DIO_SYNC_WRITES);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-- 
1.7.1

