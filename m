From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 3/3] ext4: disable COLLAPSE_RANGE for bigalloc
Date: Thu, 17 Apr 2014 07:30:54 +0900
Message-ID: <002b01cf59c3$878af780$96a0e680$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	=?iso-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:34038 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPWaz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Apr 2014 18:30:55 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N45001QVAJJXC10@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Thu, 17 Apr 2014 07:30:55 +0900 (KST)
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Namjae Jeon <namjae.jeon@samsung.com>

Once COLLAPSE RANGE is be disable for ext4 with bigalloc feature till finding
root-cause of problem. It will be enable with fixing that regression of
xfstest(generic 075 and 091) again.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/extents.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a64242f..8d45ef8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5461,6 +5461,11 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		goto out_mutex;
 	}
 
+	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
+		ret = -EOPNOTSUPP;
+		goto out_mutex;
+	}
+
 	truncate_pagecache_range(inode, ioffset, -1);
 
 	/* Wait for existing dio to complete */
-- 
1.7.11-rc0

