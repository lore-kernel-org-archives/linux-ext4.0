From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/4][RFC] ocfs2: remove duplicated check from ocfs2_fallocate
Date: Tue, 20 Nov 2012 17:29:45 +0800
Message-ID: <1353403785-3489-5-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Cc: yan@linux.vnet.ibm.com, Zheng Liu <wenqing.lz@taobao.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

Remove a sanity check from ocfs2_fallocate because vfs has already checked it.

Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ocfs2/file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5a4ee77..2446efa 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2001,8 +2001,6 @@ static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
 	int change_size = 1;
 	int cmd = OCFS2_IOC_RESVSP64;
 
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
-		return -EOPNOTSUPP;
 	if (!ocfs2_writes_unwritten_extents(osb))
 		return -EOPNOTSUPP;
 
-- 
1.7.12.rc2.18.g61b472e

