From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
Date: Fri,  2 Mar 2012 14:56:11 -0500
Message-ID: <1330718175-21540-4-git-send-email-jmoyer@redhat.com>
References: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
Cc: jack@suse.cz, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jan Kara <jack@suse.cz>

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
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

