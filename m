From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/4] ext4: fold two if statements into one
Date: Wed, 26 Oct 2011 15:11:49 +0800
Message-ID: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49521 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab1JZJHs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 05:07:48 -0400
Received: by iaby12 with SMTP id y12so1511707iab.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 02:07:47 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f1ed90b..f887023 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4082,18 +4082,17 @@ got_allocated_blocks:
 		 */
 		reserved_clusters = get_reserved_cluster_alloc(inode,
 						map->m_lblk, allocated);
-		if (map->m_flags & EXT4_MAP_FROM_CLUSTER) {
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
+		if ((map->m_flags & EXT4_MAP_FROM_CLUSTER) &&
+		    reserved_clusters) {
+			/*
+			 * We have clusters reserved for this range.
+			 * But since we are not doing actual allocation
+			 * and are simply using blocks from previously
+			 * allocated cluster, we should release the
+			 * reservation and not claim quota.
+			 */
+			ext4_da_update_reserve_space(inode,
+					reserved_clusters, 0);
 		} else {
 			BUG_ON(allocated_clusters < reserved_clusters);
 			/* We will claim quota for all newly allocated blocks.*/
-- 
1.7.5.1

