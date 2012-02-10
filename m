From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] gfs2: Use generic handlers of O_SYNC AIO DIO
Date: Fri, 10 Feb 2012 17:04:01 +0100
Message-ID: <1328889842-23231-4-git-send-email-jack@suse.cz>
References: <1328889842-23231-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
	LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328889842-23231-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 501e5cb..9c381ff 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1034,7 +1034,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, gfs2_get_block_direct,
-				  NULL, NULL, 0);
+				  NULL, NULL, DIO_SYNC_WRITES);
 out:
 	gfs2_glock_dq_m(1, &gh);
 	gfs2_holder_uninit(&gh);
-- 
1.7.1
