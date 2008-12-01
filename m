From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 4/4] ext4: Init the complete page while building buddy cache
Date: Mon,  1 Dec 2008 19:13:46 +0530
Message-ID: <1228139026-22736-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1228139026-22736-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1228139026-22736-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1228139026-22736-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:54106 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYLANoA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 08:44:00 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id mB1DhwCJ010564
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:58 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB1Dhxm61187996
	for <linux-ext4@vger.kernel.org>; Mon, 1 Dec 2008 19:13:59 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id mB1DhugW015953
	for <linux-ext4@vger.kernel.org>; Tue, 2 Dec 2008 00:43:57 +1100
In-Reply-To: <1228139026-22736-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to init the complete page during buddy cache init
by setting the contents to '1'. This ensures that during
resize when we increment the s_groups_count we don't hit
the erros as below.

EXT4-fs error (device sdb1): ext4_mb_mark_diskspace_used:
	Allocating block 1040385 in system zone of 127 group

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8f33691..01c86f3 100644
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
-- 
1.6.0.4.735.gea4f

