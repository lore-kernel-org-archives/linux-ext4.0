From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Check for the correct error return from ext4_ext_get_blocks
Date: Mon,  3 Dec 2007 15:57:30 +0530
Message-ID: <1196677650-10479-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48389 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbXLCK1g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 05:27:36 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id lB3ARUb0014252
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:57:30 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3ARUBg3764302
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 15:57:30 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id lB3ARUuk025106
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 10:27:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_get_blocks returns negative values on error. We should
check for  <= 0

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a2475d4..ce57245 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2558,8 +2558,8 @@ retry:
 		ret = ext4_ext_get_blocks(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
-		WARN_ON(!ret);
-		if (!ret) {
+		WARN_ON(ret <= 0);
+		if (ret <= 0) {
 			ext4_error(inode->i_sb, "ext4_fallocate",
 				   "ext4_ext_get_blocks returned 0! inode#%lu"
 				   ", block=%llu, max_blocks=%llu",
-- 
1.5.3.6.985.g65c6a4-dirty
