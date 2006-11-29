From: akpm@osdl.org
Subject: + ext3-balloc-fix-_with_rsv-freeze.patch added to -mm tree
Date: Wed, 29 Nov 2006 14:14:04 -0800
Message-ID: <200611292214.kATME4I8013043@shell0.pdx.osdl.net>
Cc: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37577 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758890AbWK2WeF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 17:34:05 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3 balloc: fix _with_rsv freeze
has been added to the -mm tree.  Its filename is
     ext3-balloc-fix-_with_rsv-freeze.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext3 balloc: fix _with_rsv freeze
From: Hugh Dickins <hugh@veritas.com>

After several days of testing ext3 with reservations, it got caught inside
ext3_try_to_allocate_with_rsv: alloc_new_reservation repeatedly succeeding
on the window [12cff,12d0e], ext3_try_to_allocate repeatedly failing to
find the free block guaranteed to be included (unless there's contention).

Fix the range to find_next_usable_block's memscan: the scan from "here"
(0xcfe) up to (but excluding) "maxblocks" (0xd0e) needs to scan 3 bytes not
2 (the relevant bytes of bitmap in this case being f7 df ff - none 00, but
the premature cutoff implying that the last was found 00).

Is this a problem for mainline ext3?  No, because the "size" in its memscan
is always EXT2_BLOCKS_PER_GROUP(sb), which mkfs.ext3 requires to be a
multiple of 8.  Is this a problem for ext3 or ext4?  No, because they have
an additional extN_test_allocatable test which rescues them from the error.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/balloc.c~ext3-balloc-fix-_with_rsv-freeze fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-fix-_with_rsv-freeze
+++ a/fs/ext3/balloc.c
@@ -730,7 +730,7 @@ find_next_usable_block(ext3_grpblk_t sta
 		here = 0;
 
 	p = ((char *)bh->b_data) + (here >> 3);
-	r = memscan(p, 0, (maxblocks - here + 7) >> 3);
+	r = memscan(p, 0, ((maxblocks + 7) >> 3) - (here >> 3));
 	next = (r - ((char *)bh->b_data)) << 3;
 
 	if (next < maxblocks && next >= start && ext3_test_allocatable(next, bh))
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
ext3-balloc-fix-_with_rsv-freeze.patch
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
