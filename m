From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/9] filemap: don't call generic_write_sync for -EIOCBQUEUED
Date: Mon, 19 Nov 2012 23:51:15 -0800
Message-ID: <20121120075114.25270.24389.stgit@blackbox.djwong.org>
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
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2KTITh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Nov 2012 03:19:37 -0500
In-Reply-To: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

As it stands, generic_file_aio_write will call into generic_write_sync
when -EIOCBQUEUED is returned from __generic_file_aio_write.  EIOCBQUEUED
indicates that an I/O was submitted but NOT completed.  Thus, we will
flush the disk cache, potentially before the write(s) even make it to
the disk!  Up until now, this has been the best we could do, as file
systems didn't bother to flush the disk cache after an O_SYNC AIO+DIO
write.  After applying the prior two patches to xfs and ext4, at least
the major two file systems do the right thing.  So, let's go ahead and
fix this backwards logic.

From: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..8e14c10 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2532,7 +2532,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);


