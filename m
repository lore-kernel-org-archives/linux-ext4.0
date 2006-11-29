From: akpm@osdl.org
Subject: + ext3-balloc-fix-off-by-one-against-grp_goal.patch added to -mm tree
Date: Wed, 29 Nov 2006 14:12:36 -0800
Message-ID: <200611292212.kATMCaCk012975@shell0.pdx.osdl.net>
Cc: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:30402 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758854AbWK2WNE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 17:13:04 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3 balloc: fix off-by-one against grp_goal
has been added to the -mm tree.  Its filename is
     ext3-balloc-fix-off-by-one-against-grp_goal.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3 balloc: fix off-by-one against grp_goal
From: Hugh Dickins <hugh@veritas.com>

grp_goal 0 is a genuine goal (unlike -1), so ext3_try_to_allocate_with_rsv
should treat it as such.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

Patches currently in -mm which might be from hugh@veritas.com are

git-powerpc.patch
__unmap_hugepage_range-add-comment.patch
shared-page-table-for-hugetlb-page-v4.patch
htlb-forget-rss-with-pt-sharing.patch
mlock-cleanup.patch
always-print-out-the-header-line-in-proc-swaps.patch
reject-corrupt-swapfiles-earlier.patch
kill-install_file_ptes-pte_val.patch
honour-mnt_noexec-for-access.patch
ext3-fix-reservation-extension.patch
ext4-fix-reservation-extension.patch
ext3-balloc-reset-windowsz-when-full.patch
ext3-balloc-fix-off-by-one-against-grp_goal.patch
ext3-balloc-fix-off-by-one-against-rsv_end.patch
ext3-balloc-say-rb_entry-not-list_entry.patch
ext3-balloc-use-io_error-label.patch
ext2-reservations.patch
ext2-balloc-fix-_with_rsv-freeze.patch
ext2-balloc-reset-windowsz-when-full.patch
ext2-balloc-fix-off-by-one-against-rsv_end.patch
ext2-balloc-fix-off-by-one-against-grp_goal.patch
ext2-balloc-say-rb_entry-not-list_entry.patch
ext2-balloc-use-io_error-label.patch
generic-bug-implementation.patch
generic-bug-implementation-handle-bug=n.patch
generic-bug-for-i386.patch
generic-bug-for-x86-64.patch
bug-test-1.patch
tty-switch-to-ktermios-powerpc-fix.patch
