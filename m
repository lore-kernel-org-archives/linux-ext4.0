From: akpm@osdl.org
Subject: + ext3-balloc-say-rb_entry-not-list_entry.patch added to -mm tree
Date: Wed, 29 Nov 2006 14:12:40 -0800
Message-ID: <200611292212.kATMCes8012988@shell0.pdx.osdl.net>
Cc: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:27587 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758857AbWK2WQZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 17:16:25 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3 balloc: say rb_entry not list_entry
has been added to the -mm tree.  Its filename is
     ext3-balloc-say-rb_entry-not-list_entry.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3 balloc: say rb_entry not list_entry
From: Hugh Dickins <hugh@veritas.com>

The reservations tree is an rb_tree not a list, so it's less confusing to use
rb_entry() than list_entry() - though they're both just container_of().

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-balloc-say-rb_entry-not-list_entry fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-say-rb_entry-not-list_entry
+++ a/fs/ext3/balloc.c
@@ -144,7 +144,7 @@ restart:
 
 	printk("Block Allocation Reservation Windows Map (%s):\n", fn);
 	while (n) {
-		rsv = list_entry(n, struct ext3_reserve_window_node, rsv_node);
+		rsv = rb_entry(n, struct ext3_reserve_window_node, rsv_node);
 		if (verbose)
 			printk("reservation window 0x%p "
 			       "start:  %lu, end:  %lu\n",
@@ -949,7 +949,7 @@ static int find_next_reservable_window(
 
 		prev = rsv;
 		next = rb_next(&rsv->rsv_node);
-		rsv = list_entry(next,struct ext3_reserve_window_node,rsv_node);
+		rsv = rb_entry(next,struct ext3_reserve_window_node,rsv_node);
 
 		/*
 		 * Reached the last reservation, we can just append to the
@@ -1193,7 +1193,7 @@ static void try_to_extend_reservation(st
 	if (!next)
 		my_rsv->rsv_end += size;
 	else {
-		next_rsv = list_entry(next, struct ext3_reserve_window_node, rsv_node);
+		next_rsv = rb_entry(next, struct ext3_reserve_window_node, rsv_node);
 
 		if ((next_rsv->rsv_start - my_rsv->rsv_end - 1) >= size)
 			my_rsv->rsv_end += size;
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
