From: akpm@osdl.org
Subject: [patch 228/354] ext3: fix reservation extension
Date: Wed, 06 Dec 2006 20:38:18 -0800
Message-ID: <200612070438.kB74cIf1029794@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, cmm@us.ibm.com, hugh@veritas.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47199 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968755AbWLGEjL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:39:11 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Mingming Cao <cmm@us.ibm.com>

Hugh Dickins wrote:
> Not found anything relevant, but I keep noticing these lines
> in ext2_try_to_allocate_with_rsv(), ext3 and ext4 similar:
>
> 		} else if (grp_goal > 0 &&
> 				(my_rsv->rsv_end - grp_goal + 1) < *count)
> 			try_to_extend_reservation(my_rsv, sb,
> 					*count-my_rsv->rsv_end + grp_goal - 1);
>
> They're wrong, a no-op in most groups, aren't they?  rsv_end is an
> absolute block number, whereas grp_goal is group-relative, so the
> calculation ought to bring in group_first_block?  Or I'm confused.
>

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-fix-reservation-extension fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-fix-reservation-extension
+++ a/fs/ext3/balloc.c
@@ -1307,10 +1307,14 @@ ext3_try_to_allocate_with_rsv(struct sup
 			if (!goal_in_my_reservation(&my_rsv->rsv_window,
 							grp_goal, group, sb))
 				grp_goal = -1;
-		} else if (grp_goal > 0 &&
-			  (my_rsv->rsv_end-grp_goal+1) < *count)
-			try_to_extend_reservation(my_rsv, sb,
-					*count-my_rsv->rsv_end + grp_goal - 1);
+		} else if (grp_goal > 0) {
+			int curr = my_rsv->rsv_end -
+					(grp_goal + group_first_block) + 1;
+
+			if (curr < *count)
+				try_to_extend_reservation(my_rsv, sb,
+							*count - curr);
+		}
 
 		if ((my_rsv->rsv_start > group_last_block) ||
 				(my_rsv->rsv_end < group_first_block)) {
_
