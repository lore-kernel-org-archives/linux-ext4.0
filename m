From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3] ext4: Init the complete page while building buddy cache
Date: Tue,  2 Dec 2008 11:41:02 +0530
Message-ID: <1228198262-23984-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54564 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYLBGLa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 01:11:30 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB26B82h026638
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 11:41:08 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB26ALUp4403398
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 11:40:22 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB26B6hH013355
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 17:11:07 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to init the complete page during buddy cache init
by setting the contents to '1'. This ensures that during
resize when we increment the s_groups_count we don't hit
the erros as below.

EXT4-fs error (device sdb1): ext4_mb_mark_diskspace_used:
	Allocating block 1040385 in system zone of 127 group

V3 changes:
We don't need to do a memset when updating buddy cache since
we do a complete init of the page.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8f33691..0ecc7c7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -846,6 +846,8 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 
 	err = 0;
 	first_block = page->index * blocks_per_page;
+	/* init the page  */
+	memset(page_address(page), 0xff, PAGE_CACHE_SIZE);
 	for (i = 0; i < blocks_per_page; i++) {
 		int group;
 		struct ext4_group_info *grinfo;
@@ -872,7 +874,6 @@ static int ext4_mb_init_cache(struct page *page, char *incore)
 			BUG_ON(incore == NULL);
 			mb_debug("put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
-			memset(data, 0xff, blocksize);
 			grinfo = ext4_get_group_info(sb, group);
 			grinfo->bb_fragments = 0;
 			memset(grinfo->bb_counters, 0,
-- 
1.6.1.rc1

