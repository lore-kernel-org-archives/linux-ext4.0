From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: don't consume reserved space when allocating partial
 cluster
Date: Mon, 16 Mar 2015 21:20:09 -0400
Message-ID: <20150317012009.GA5870@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35653 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbbCQBUN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Mar 2015 21:20:13 -0400
Received: by qcbkw5 with SMTP id kw5so61120120qcb.2
        for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2015 18:20:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When xfstests' auto group is run on a bigalloc filesystem with a
4.0-rc3 kernel, e2fsck failures and kernel warnings occur for some
tests. e2fsck reports incorrect iblocks values, and the warnings
indicate that the space reserved by delayed allocation is being
overdrawn at allocation time.

Some of these errors occur because the reserved space is incorrectly
decreased by one cluster when ext4_ext_map_blocks satisfies an
allocation request by using an unused portion of a previously allocated
cluster.  Because a cluster's worth of reserved space was already
removed when it was first allocated, it should not be removed again.

This patch appears to correct the e2fsck failure reported for
generic/232 and the kernel warnings produced by ext4/001, generic/009,
and generic/033.  Failures and warnings for some other tests remain to
be addressed.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bed4308..554190e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4535,19 +4535,7 @@ got_allocated_blocks:
 		 */
 		reserved_clusters = get_reserved_cluster_alloc(inode,
 						map->m_lblk, allocated);
-		if (map_from_cluster) {
-			if (reserved_clusters) {
-				/*
-				 * We have clusters reserved for this range.
-				 * But since we are not doing actual allocation
-				 * and are simply using blocks from previously
-				 * allocated cluster, we should release the
-				 * reservation and not claim quota.
-				 */
-				ext4_da_update_reserve_space(inode,
-						reserved_clusters, 0);
-			}
-		} else {
+		if (!map_from_cluster) {
 			BUG_ON(allocated_clusters < reserved_clusters);
 			if (reserved_clusters < allocated_clusters) {
 				struct ext4_inode_info *ei = EXT4_I(inode);
-- 
2.1.0

