From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 3/6] Rename de patch3 from de to se scheme
Date: Fri,  9 Mar 2012 21:41:22 -0700
Message-ID: <1331354485-18515-4-git-send-email-achender@linux.vnet.ibm.com>
References: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48378 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2CJEky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 23:40:54 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 23:40:53 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 47A776E804B
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 23:40:51 -0500 (EST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4eo3f291454
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 23:40:51 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4eowV030529
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:50 -0700
In-Reply-To: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames changes introduced by patch
"[PATCH_V3_3_6]_ext4_initialize_delayed_extent_tree "

All code referencing "delayed extents" or "de" are changed to
"status extents" or "se"

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 e76253b... e6e2415... M	fs/ext4/super.c
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e76253b..e6e2415 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -899,7 +899,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-	ext4_de_init_tree(&ei->i_de_tree);
+	ext4_se_init_tree(&ei->i_se_tree);
 	ei->i_reserved_data_blocks = 0;
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
-- 
1.7.1

