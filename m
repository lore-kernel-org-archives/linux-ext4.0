From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/6 v2] xfs: Add support for FALLOC_FL_ZERO_RANGE
Date: Tue, 25 Feb 2014 20:14:39 +0100
Message-ID: <1393355679-11160-7-git-send-email-lczerner@redhat.com>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaBYTPG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Feb 2014 14:15:06 -0500
In-Reply-To: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
functionality as xfs ioctl XFS_IOC_ZERO_RANGE.

We can also preallocate blocks past EOF in the same was as with
fallocate. Flag FALLOC_FL_KEEP_SIZE will cause the inode size to remain
the same even if we preallocate blocks past EOF.

It uses the same code to zero range as it is used by the
XFS_IOC_ZERO_RANGE ioctl.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52f96e1..8fb97a6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -824,7 +824,7 @@ xfs_file_fallocate(
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
-		     FALLOC_FL_COLLAPSE_RANGE))
+		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
 	xfs_ilock(ip, XFS_IOLOCK_EXCL);
@@ -855,8 +855,11 @@ xfs_file_fallocate(
 				goto out_unlock;
 		}
 
-		error = xfs_alloc_file_space(ip, offset, len,
-					     XFS_BMAPI_PREALLOC);
+		if (mode & FALLOC_FL_ZERO_RANGE)
+			error = xfs_zero_file_space(ip, offset, len);
+		else
+			error = xfs_alloc_file_space(ip, offset, len,
+						     XFS_BMAPI_PREALLOC);
 		if (error)
 			goto out_unlock;
 	}
-- 
1.8.3.1

