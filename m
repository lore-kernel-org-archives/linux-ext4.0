From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/7] gfs2: Use generic handlers of O_SYNC AIO DIO
Date: Thu, 29 Mar 2012 18:05:01 -0400
Message-ID: <1333058705-31512-4-git-send-email-jmoyer@redhat.com>
References: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com, jack@suse.cz,
	hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab2C2WFn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 Mar 2012 18:05:43 -0400
In-Reply-To: <1333058705-31512-1-git-send-email-jmoyer@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
file.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/gfs2/aops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 38b7a74..2589781 100644
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

