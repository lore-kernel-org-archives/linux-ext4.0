From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 7/7] filemap: don't call generic_write_sync for -EIOCBQUEUED
Date: Fri,  2 Mar 2012 14:56:15 -0500
Message-ID: <1330718175-21540-8-git-send-email-jmoyer@redhat.com>
References: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
Cc: jack@suse.cz, hch@infradead.org, Jeff Moyer <jmoyer@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1330718175-21540-1-git-send-email-jmoyer@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index c4ee2e9..004442f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2634,7 +2634,7 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
 
-	if (ret > 0 || ret == -EIOCBQUEUED) {
+	if (ret > 0) {
 		ssize_t err;
 
 		err = generic_write_sync(file, pos, ret);
-- 
1.7.1

