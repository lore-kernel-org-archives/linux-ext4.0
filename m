From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 15/23] ext4: tune mballoc's default group prealloc size for bigalloc file systems
Date: Wed,  6 Jul 2011 12:35:58 -0400
Message-ID: <1309970166-11770-16-git-send-email-tytso@mit.edu>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33492 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1GFQgJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 12:36:09 -0400
In-Reply-To: <1309970166-11770-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The default group preallocation size had been previously set to 512
blocks/clusters, regardless of the block/cluster size.  This is
probably too big for large cluster sizes.  So adjust the default so
that it is 2 megabytes or 32 clusters, whichever is larger.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/mballoc.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 48172a1..2d23d0a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -126,7 +126,8 @@
  * list. In case of inode preallocation we follow a list of heuristics
  * based on file size. This can be found in ext4_mb_normalize_request. If
  * we are doing a group prealloc we try to normalize the request to
- * sbi->s_mb_group_prealloc. Default value of s_mb_group_prealloc is
+ * sbi->s_mb_group_prealloc.  The default value of s_mb_group_prealloc is
+ * dependent on the cluster size; for non-bigalloc file systems, it is
  * 512 blocks. This can be tuned via
  * /sys/fs/ext4/<partition/mb_group_prealloc. The value is represented in
  * terms of number of blocks. If we have mounted the file system with -O
@@ -2471,7 +2472,20 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
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
1.7.4.1.22.gec8e1.dirty

