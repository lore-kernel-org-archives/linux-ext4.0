From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/6 v7] ext4: Lock i_mutex for punch hole
Date: Tue, 30 Aug 2011 17:28:31 -0700
Message-ID: <1314750513-10045-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33450 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab1HaA0m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Aug 2011 20:26:42 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7V02WZE001247
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:02:32 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7V0PPFn226912
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 20:25:25 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7V0POHk001586
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 21:25:25 -0300
In-Reply-To: <1314750513-10045-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch modifies the fallocate routine to lock i_mutex during
the punch hole operation.

Yongqiang noticed that the vfs layer locks i_mutex for truncate,
but not fallocate, so the fallocate routine will need to take
care of locking i_mutex.  Otherwise a page may be mapped after
punch hole has released the pages, but before i_data_sem is
locked to release the blocks in the extent tree.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 9124cd2... 007fb08... M	fs/ext4/extents.c
 fs/ext4/extents.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9124cd2..007fb08 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3774,8 +3774,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return ext4_punch_hole(file, offset, len);
+	mutex_lock(&inode->i_mutex);
+
+	if (mode & FALLOC_FL_PUNCH_HOLE) {
+		ret = ext4_punch_hole(file, offset, len);
+		mutex_unlock(&inode->i_mutex);
+		return ret;	
+	}
 
 	trace_ext4_fallocate_enter(inode, offset, len, mode);
 	map.m_lblk = offset >> blkbits;
@@ -3789,7 +3794,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * credits to insert 1 extent into extent tree
 	 */
 	credits = ext4_chunk_trans_blocks(inode, max_blocks);
-	mutex_lock(&inode->i_mutex);
 	ret = inode_newsize_ok(inode, (len + offset));
 	if (ret) {
 		mutex_unlock(&inode->i_mutex);
-- 
1.7.1

