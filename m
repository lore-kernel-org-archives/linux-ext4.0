From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2 for 2.6.31] ext4: Use -1 as the fake block number for delayed new buffer_head
Date: Wed, 29 Apr 2009 16:43:30 +0530
Message-ID: <1241003611-3652-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:37615 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZD2LNl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 07:13:41 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp09.in.ibm.com (8.13.1/8.13.1) with ESMTP id n3TAcYHW014903
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 16:08:34 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3TBDceT2326636
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 16:43:38 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id n3TBDbtm006633
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 21:13:38 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Block number '0' should not be used as the fake block number for
the delayed new buffer. This will result in vfs calling umap_underlying_metadata for
block number '0'. So  use -1 instead.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

---
 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e91f978..3afd5f1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2318,7 +2318,7 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			/* not enough space to reserve */
 			return ret;
 
-		map_bh(bh_result, inode->i_sb, 0);
+		map_bh(bh_result, inode->i_sb, -1);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
 	} else if (ret > 0) {
-- 
tg: (56a50ad..) ext4_corruption_fix (depends on: master)
