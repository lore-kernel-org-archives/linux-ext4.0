From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V4 2/2] ext4: Use -1 as the fake block number for delayed new buffer_head
Date: Wed, 29 Apr 2009 10:17:21 +0530
Message-ID: <1240980441-8105-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50149 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZD2Er3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Apr 2009 00:47:29 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp09.au.ibm.com (8.13.1/8.13.1) with ESMTP id n3T4NecQ018590
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 00:23:40 -0400
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3T4lSUQ536876
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:47:28 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3T4lST8024782
	for <linux-ext4@vger.kernel.org>; Wed, 29 Apr 2009 14:47:28 +1000
In-Reply-To: <1240980441-8105-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
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
index 12dcfab..c7c2156 100644
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
tg: (15262e5..) proper_mappingblock_for_delay (depends on: preallocate_corruption_quickfix)
