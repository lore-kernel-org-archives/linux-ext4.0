From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] ext4: use EINVAL if not a regular file in ext4_fallocate()
Date: Sat, 19 Apr 2014 14:11:07 +0900
Message-ID: <000e01cf5b8d$c57e9f80$507bde80$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:14833 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaDSFLJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2014 01:11:09 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4900J44IEKIA20@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 19 Apr 2014 14:11:08 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

Punch hole return EOPNOTSUPP about a non-REGULAR file also. So change EINVAL
to be consistent with xfs. And move this check to the start of
ext4_fallocate().

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 9 +++------
 fs/ext4/inode.c   | 3 ---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3276865..b38f487 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4741,9 +4741,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 
 	trace_ext4_zero_range(inode, offset, len, mode);
 
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.
@@ -4888,6 +4885,9 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
+	
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
 
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		return ext4_punch_hole(inode, offset, len);
@@ -5403,9 +5403,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	    len & (EXT4_BLOCK_SIZE(sb) - 1))
 		return -EINVAL;
 
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
 	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
 		return -EOPNOTSUPP;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d7b7462..d6cbbe3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3524,9 +3524,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	unsigned int credits;
 	int ret = 0;
 
-	if (!S_ISREG(inode->i_mode))
-		return -EOPNOTSUPP;
