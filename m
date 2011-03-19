From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC 11/12] ext4: tune mballoc's default group prealloc size for bigalloc file systems
Date: Sat, 19 Mar 2011 17:28:36 -0400
Message-ID: <1300570117-24048-12-git-send-email-tytso@mit.edu>
References: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52238 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757597Ab1CSVhX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 19 Mar 2011 17:37:23 -0400
In-Reply-To: <1300570117-24048-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The default group preallocation size had been previously set to 512
blocks/clusters, regardless of the block/cluster size.  This is
probably too big for large cluster sizes.  So adjust the default so
that it is 2 megabytes or 32 clusters, whichever is larger.
---
 fs/ext4/mballoc.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 02f099f..ad4a6eb 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2529,7 +2529,20 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	sbi->s_mb_stats = MB_DEFAULT_STATS;
 	sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
 	sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
-	sbi->s_mb_group_prealloc = MB_DEFAULT_GROUP_PREALLOC;
+	/*
+	 * The default group preallocation is 512, which for 4k block
+	 * sizes translates to 2 megabytes.  However for bigalloc file
+	 * systems, this is probably too big (i.e, if the cluster size
+	 * is 1 megabyte, then group preallocation size becomes half a
+	 * gigabyte!).  As a default, we will keep a two megabyte
+	 * group pralloc size for cluster sizes up to 64k, and after
+	 * that, we will force a minimum group preallocation size of
+	 * 32 clusters.  This translates to 8 megs when the cluster
+	 * size is 256k, and 32 megs when the cluster size is 1 meg,
+	 * which seems reasonable as a default.
+	 */
+	sbi->s_mb_group_prealloc = max(MB_DEFAULT_GROUP_PREALLOC >>
+				       sbi->s_cluster_bits, 32);
 
 	sbi->s_locality_groups = alloc_percpu(struct ext4_locality_group);
 	if (sbi->s_locality_groups == NULL) {
-- 
1.7.3.1

