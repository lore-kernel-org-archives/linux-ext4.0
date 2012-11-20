From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 2/4][RFC] xfs: remove duplicated check from xfs_file_fallocate
Date: Tue, 20 Nov 2012 17:29:43 +0800
Message-ID: <1353403785-3489-3-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from xfs_file_fallocate because vfs has already checked
it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/xfs/xfs_file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..7b50d12 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -815,9 +815,6 @@ xfs_file_fallocate(
 	int		cmd = XFS_IOC_RESVSP;
 	int		attr_flags = XFS_ATTR_NOLOCK;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
-
 	bf.l_whence = 0;
 	bf.l_start = offset;
 	bf.l_len = len;
-- 
1.7.12.rc2.18.g61b472e

