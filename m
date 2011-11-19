From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Date: Sun, 20 Nov 2011 07:48:44 +0900
Message-ID: <1321742924-3189-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58884 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab1KSWsz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 17:48:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If group info caches set to SLAB_MEM_SPREAD flags, the allocation is spread evenly over all the memory nodes when using cpuset.
It is useful because group info caches are long lived.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/ext4/mballoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..7aacbbe 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2407,7 +2407,8 @@ static int ext4_groupinfo_create_slab(size_t size)
 				bb_counters[blocksize_bits + 2]);
 
 	cachep = kmem_cache_create(ext4_groupinfo_slab_names[cache_index],
-					slab_size, 0, SLAB_RECLAIM_ACCOUNT,
+					slab_size, 0, SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD,
 					NULL);
 
 	ext4_groupinfo_caches[cache_index] = cachep;
-- 
1.7.4.4

