From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] ext4: fix COLLAPSE RANGE test failure when bigalloc is enable
Date: Wed, 04 Jun 2014 17:08:45 +0900
Message-ID: <001001cf7fcc$34f3c2c0$9edb4840$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Ashish Sangwan <a.sangwan@samsung.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38369 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaFDIIs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jun 2014 04:08:48 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N6M00I15XAMQIA0@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Wed, 04 Jun 2014 17:08:46 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Blocks in collapse range should be collapsed per cluster unit when bigalloc
is enable. If bigalloc is not enable, EXT4_CLUSTER_SIZE will be same with
EXT4_BLOCK_SIZE.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4da228a..2b9f5f3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5403,16 +5403,13 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	int ret;
 
 	/* Collapse range works only on fs block size aligned offsets. */
-	if (offset & (EXT4_BLOCK_SIZE(sb) - 1) ||
-	    len & (EXT4_BLOCK_SIZE(sb) - 1))
+	if (offset & (EXT4_CLUSTER_SIZE(sb) - 1) ||
+	    len & (EXT4_CLUSTER_SIZE(sb) - 1))
 		return -EINVAL;
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
-	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
-		return -EOPNOTSUPP;
