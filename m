From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/9] gfs2: Use generic handlers of O_SYNC AIO DIO
Date: Mon, 19 Nov 2012 23:51:14 -0800
Message-ID: <20121120075114.25270.60746.stgit@blackbox.djwong.org>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com,
	jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk,
	jack@suse.cz
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file.

From: Jan Kara <jack@suse.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/gfs2/aops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 01c4975..8b1d0f7 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1022,7 +1022,7 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 
 	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
 				  offset, nr_segs, gfs2_get_block_direct,
-				  NULL, NULL, 0);
+				  NULL, NULL, DIO_SYNC_WRITES);
 out:
 	gfs2_glock_dq(&gh);
 	gfs2_holder_uninit(&gh);
