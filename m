From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: s_dirtyclusters_counter should tranform to unit of cluster before assigning to "dirty_clusters" in ext4_has_free_clusters()
Date: Wed,  1 Feb 2012 11:17:50 +0800
Message-ID: <1328066270-4461-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47333 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824Ab2BADSE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 31 Jan 2012 22:18:04 -0500
Received: by obcva7 with SMTP id va7so730079obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 31 Jan 2012 19:18:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Creating 4-byte files until ENOSPC in a delay-allocation and bigalloc ext4 fs and then sync it, the dmseg will report like:

	[  482.154538] EXT4-fs (sdb6): delayed block allocation failed for inode 1664 at logical offset 0 with max blocks 1 with error -28
	[  482.154540] EXT4-fs (sdb6): This should not happen!! Data will be lost

The reason is ext4_has_free_clusters reporting wrong result. Actually, the unit of sbi->s_dirtyclusters_counter is block, so we should tranform it to cluster for argument "dirty_clusters", just like "free_clusters".

Cc: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/balloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index f9e2cd8..8ff10c4 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -427,7 +427,7 @@ static int ext4_has_free_clusters(struct ext4_sb_info *sbi,
 	if (free_clusters - (nclusters + root_clusters + dirty_clusters) <
 					EXT4_FREECLUSTERS_WATERMARK) {
 		free_clusters  = EXT4_C2B(sbi, percpu_counter_sum_positive(fcc));
-		dirty_clusters = percpu_counter_sum_positive(dcc);
+		dirty_clusters = EXT4_C2B(sbi, percpu_counter_sum_positive(dcc));
 	}
 	/* Check whether we have space after accounting for current
 	 * dirty clusters & root reserved clusters.
-- 
1.7.4.1

