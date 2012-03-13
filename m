From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/3] ext4: s_freeclusters_counter should not tranform to unit of block before assigning to "free_clusters" in ext4_has_free_cluste
Date: Tue, 13 Mar 2012 19:38:16 +0800
Message-ID: <1331638698-14796-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <hao.bigrat@gmail.com>, Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59593 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab2CMLia (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Mar 2012 07:38:30 -0400
Received: by iagz16 with SMTP id z16so671109iag.19
        for <linux-ext4@vger.kernel.org>; Tue, 13 Mar 2012 04:38:29 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Creating 4-byte files until ENOSPC in a delay-allocation and bigalloc ext4 fs and then sync it, the dmseg will report like:

	[  482.154538] EXT4-fs (sdb6): delayed block allocation failed for inode 1664 at logical offset 0 with max blocks 1 with error -28
	[  482.154540] EXT4-fs (sdb6): This should not happen!! Data will be lost

The reason is ext4_has_free_clusters reporting wrong result. Actually, the unit of sbi->s_dirtyclusters_counter is block, so we should tranform it to cluster for argument "dirty_clusters", just like "free_clusters".

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f9e2cd8..2c518f8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -426,7 +426,7 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 
 	if (free_clusters - (nclusters + root_clusters + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
-		free_clusters  = EXT4_C2B(sbi, percpu_counter_sum_positive(fcc));
+		free_clusters  = percpu_counter_sum_positive(fcc);
 		dirty_clusters = percpu_counter_sum_positive(dcc);
 	}
 	/* Check whether we have space after accounting for current
-- 
1.7.3.2

