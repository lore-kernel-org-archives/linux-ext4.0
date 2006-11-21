From: akpm@osdl.org
Subject: + ext4-fix-reservation-extension.patch added to -mm tree
Date: Tue, 21 Nov 2006 09:13:48 -0800
Message-ID: <200611211713.kALHDm6b031991@shell0.pdx.osdl.net>
Cc: cmm@us.ibm.com, hugh@veritas.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:4829 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1031230AbWKURRD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Nov 2006 12:17:03 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix reservation extension
has been added to the -mm tree.  Its filename is
     ext4-fix-reservation-extension.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

diff -puN fs/ext2/balloc.c~ext4-fix-reservation-extension fs/ext2/balloc.c
diff -puN fs/ext3/balloc.c~ext4-fix-reservation-extension fs/ext3/balloc.c
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
+			}
 
 		if ((my_rsv->rsv_start > group_last_block) ||
 				(my_rsv->rsv_end < group_first_block)) {
_

Patches currently in -mm which might be from cmm@us.ibm.com are

ext3-fix-reservation-extension.patch
ext4-fix-reservation-extension.patch
ext2-reservations.patch
ext2-fix-reservation-extension.patch
