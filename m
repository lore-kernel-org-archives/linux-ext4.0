From: akpm@osdl.org
Subject: - ext4-fix-reservation-extension.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:05:44 -0800
Message-ID: <200612072305.kB7N5isF030173@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
To: cmm@us.ibm.com, hugh@veritas.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix reservation extension
has been removed from the -mm tree.  Its filename was
     ext4-fix-reservation-extension.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: fix reservation extension
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

 fs/ext4/balloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-fix-reservation-extension fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-fix-reservation-extension
+++ a/fs/ext4/balloc.c
@@ -1324,10 +1324,14 @@ ext4_try_to_allocate_with_rsv(struct sup
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

Patches currently in -mm which might be from cmm@us.ibm.com are

origin.patch
ext2-reservations.patch
ext2-fix-reservation-extension.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch

