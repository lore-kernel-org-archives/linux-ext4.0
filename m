From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/8] xfs: Protect xfs_file_aio_write() & xfs_setattr_size() with sb_start_write - sb_end_write
Date: Fri, 20 Jan 2012 21:34:43 +0100
Message-ID: <1327091686-23177-6-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Dave Chinner <dchinner@redhat.com>,
	Surbhi Palande <csurbhi@gmail.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Replace racy xfs_wait_for_freeze() check in xfs_file_aio_write() with
a reliable sb_start_write() - sb_end_write() locking. Due to lock ranking
dictated by the page fault code we have to call sb_start_write() after we
acquire ilock.

Similarly we have to protect xfs_setattr_size() because it can modify last
page of truncated file. Because ilock is dropped in xfs_setattr_size() we
have to drop and retake write access as well to avoid deadlocks.

CC: Ben Myers <bpm@sgi.com>
CC: Alex Elder <elder@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_file.c |    6 ++++--
 fs/xfs/xfs_iops.c |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..9efd153 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -862,9 +862,11 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_SHARED;
 	}
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	trace_xfs_file_direct_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_direct_write(iocb, iovp,
 			&nr_segs, pos, &iocb->ki_pos, count, ocount);
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* No fallback to buffered IO on errors for XFS. */
 	ASSERT(ret < 0 || ret == count);
@@ -899,6 +901,7 @@ xfs_file_buffered_aio_write(
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 write_retry:
 	trace_xfs_file_buffered_write(ip, count, iocb->ki_pos, 0);
 	ret = generic_file_buffered_write(iocb, iovp, nr_segs,
@@ -914,6 +917,7 @@ write_retry:
 		enospc = 1;
 		goto write_retry;
 	}
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	current->backing_dev_info = NULL;
 	return ret;
 }
@@ -945,8 +949,6 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	xfs_wait_for_freeze(ip->i_mount, SB_FREEZE_WRITE);
-
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 3579bc8..798b9c6 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -793,6 +793,7 @@ xfs_setattr_size(
 		return xfs_setattr_nonsize(ip, iattr, 0);
 	}
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	/*
 	 * Make sure that the dquots are attached to the inode.
 	 */
@@ -849,10 +850,14 @@ xfs_setattr_size(
 				     xfs_get_blocks);
 	if (error)
 		goto out_unlock;
+	/* Drop the write access to avoid lock inversion with ilock */
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	lock_flags |= XFS_ILOCK_EXCL;
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
+
 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_SIZE);
 	error = xfs_trans_reserve(tp, 0, XFS_ITRUNCATE_LOG_RES(mp), 0,
 				 XFS_TRANS_PERM_LOG_RES,
@@ -924,6 +929,7 @@ xfs_setattr_size(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
 out_unlock:
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	if (lock_flags)
 		xfs_iunlock(ip, lock_flags);
 	return error;
-- 
1.7.1
