From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v2 2/2] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Sat, 19 Apr 2014 13:53:50 +0900
Message-ID: <000d01cf5b8b$5b149110$113db330$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:13391 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDSExv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Apr 2014 00:53:51 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4900JGVHLQIA10@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Sat, 19 Apr 2014 13:53:50 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

Once COLLAPSE RANGE is be disable for ext4 with bigalloc feature till finding
root-cause of problem. It will be enable with fixing that regression of
xfstest(generic 075 and 091) again.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4cf8c5b..3276865 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5406,6 +5406,9 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 
+	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1)
+		return -EOPNOTSUPP;
+
 	trace_ext4_collapse_range(inode, offset, len);
 
 	punch_start = offset >> EXT4_BLOCK_SIZE_BITS(sb);
-- 
1.7.11-rc0

