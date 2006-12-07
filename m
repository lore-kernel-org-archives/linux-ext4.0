From: akpm@osdl.org
Subject: [patch 345/354] ext3 balloc: fix off-by-one against grp_goal
Date: Wed, 06 Dec 2006 20:41:25 -0800
Message-ID: <200612070441.kB74fPhP030356@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968777AbWLGElw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:41:52 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

grp_goal 0 is a genuine goal (unlike -1), so ext3_try_to_allocate_with_rsv
should treat it as such.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-balloc-fix-off-by-one-against-grp_goal fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-fix-off-by-one-against-grp_goal
+++ a/fs/ext3/balloc.c
@@ -1271,7 +1271,7 @@ ext3_try_to_allocate_with_rsv(struct sup
 	}
 	/*
 	 * grp_goal is a group relative block number (if there is a goal)
-	 * 0 < grp_goal < EXT3_BLOCKS_PER_GROUP(sb)
+	 * 0 <= grp_goal < EXT3_BLOCKS_PER_GROUP(sb)
 	 * first block is a filesystem wide block number
 	 * first block is the block number of the first block in this group
 	 */
@@ -1307,7 +1307,7 @@ ext3_try_to_allocate_with_rsv(struct sup
 			if (!goal_in_my_reservation(&my_rsv->rsv_window,
 							grp_goal, group, sb))
 				grp_goal = -1;
-		} else if (grp_goal > 0) {
+		} else if (grp_goal >= 0) {
 			int curr = my_rsv->rsv_end -
 					(grp_goal + group_first_block) + 1;
 
_
