From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/9] xfs: factor out everything but the filemap_write_and_wait
 from xfs_file_fsync
Date: Mon, 19 Nov 2012 23:41:38 -0800
Message-ID: <20121120074138.24645.36708.stgit@blackbox.djwong.org>
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

Hi,

Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
function that can be used from the I/O post-processing path.

From: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 fs/xfs/xfs_file.c  |   44 +++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_inode.h |    1 +
 2 files changed, 30 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..507f446 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -152,25 +152,18 @@ xfs_dir_fsync(
 	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
-STATIC int
-xfs_file_fsync(
-	struct file		*file,
-	loff_t			start,
-	loff_t			end,
+/*
+ * Returns 0 on success, -errno on failure.
+ */
+int
+do_xfs_file_fsync(
+	struct xfs_inode	*ip,
+	struct xfs_mount	*mp,
 	int			datasync)
 {
-	struct inode		*inode = file->f_mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
 	int			log_flushed = 0;
 	xfs_lsn_t		lsn = 0;
-
-	trace_xfs_file_fsync(ip);
-
-	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (error)
-		return error;
+	int			error = 0;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -XFS_ERROR(EIO);
@@ -222,6 +215,27 @@ xfs_file_fsync(
 	return -error;
 }
 
+STATIC int
+xfs_file_fsync(
+	struct file		*file,
+	loff_t			start,
+	loff_t			end,
+	int			datasync)
+{
+	struct inode		*inode = file->f_mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error = 0;
+
+	trace_xfs_file_fsync(ip);
+
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
+	return do_xfs_file_fsync(ip, mp, datasync);
+}
+
 STATIC ssize_t
 xfs_file_aio_read(
 	struct kiocb		*iocb,
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 94b32f9..d5bf105 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -546,6 +546,7 @@ do { \
 	iput(VFS_I(ip)); \
 } while (0)
 
+int	do_xfs_file_fsync(struct xfs_inode *, struct xfs_mount *, int);
 #endif /* __KERNEL__ */
 
 /*
