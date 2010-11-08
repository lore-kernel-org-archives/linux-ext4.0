From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 2/6] XFS: handle hole punching via fallocate properly
Date: Mon,  8 Nov 2010 15:32:03 -0500
Message-ID: <1289248327-16308-2-git-send-email-josef@redhat.com>
References: <1289248327-16308-1-git-send-email-josef@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	xfs@oss.sgi.com, joel.becker@oracle.com, cmm@us.ibm.com,
	cluster-
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1289248327-16308-1-git-send-email-josef@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch simply allows XFS to handle the hole punching flag in fallocate
properly.  I've tested this with a little program that does a bunch of random
hole punching with FL_KEEP_SIZE and without it to make sure it does the right
thing.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/xfs/linux-2.6/xfs_iops.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index 96107ef..99df347 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -516,6 +516,7 @@ xfs_vn_fallocate(
 	loff_t		new_size = 0;
 	xfs_flock64_t	bf;
 	xfs_inode_t	*ip = XFS_I(inode);
+	int		cmd = XFS_IOC_RESVSP;
 
 	/* preallocation on directories not yet supported */
 	error = -ENODEV;
@@ -528,17 +529,22 @@ xfs_vn_fallocate(
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		cmd = XFS_IOC_UNRESVSP;
+
 	/* check the new inode size is valid before allocating */
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	    offset + len > i_size_read(inode)) {
-		new_size = offset + len;
+		if (cmd == XFS_IOC_UNRESVSP)
+			new_size = offset;
+		else
+			new_size = offset + len;
 		error = inode_newsize_ok(inode, new_size);
 		if (error)
 			goto out_unlock;
 	}
 
-	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
-				       0, XFS_ATTR_NOLOCK);
+	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);
 	if (error)
 		goto out_unlock;
 
-- 
1.6.6.1

