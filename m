From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Add a missing return in ext4_ext_calc_credits_for_single_extent
Date: Fri,  3 Jul 2009 16:25:56 +0530
Message-ID: <1246618556-1524-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37724 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZGCKz7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jul 2009 06:55:59 -0400
Received: from d23relay02.au.ibm.com (d23relay02.au.ibm.com [202.81.31.244])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id n63AsA3C022172
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jul 2009 20:54:10 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay02.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n63Au1BS663680
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jul 2009 20:56:01 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n63Au0Lw028576
	for <linux-ext4@vger.kernel.org>; Fri, 3 Jul 2009 20:56:01 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we have space in the extent tree leaf node we should be able to
insert the extent with much less journal credits. The code was doing
proper calculation but missed a return statement.

Reported-by:Andreas Dilger <adilger@sun.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f9ab60f..3e8889f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1977,6 +1977,7 @@ int ext4_ext_calc_credits_for_single_extent(struct inode *inode, int nrblocks,
 			 */
 			/* 1 bitmap, 1 block group descriptor */
 			ret = 2 + EXT4_META_TRANS_BLOCKS(inode->i_sb);
+			return ret;
 		}
 	}
 
-- 
1.6.3.2.363.gc5764

