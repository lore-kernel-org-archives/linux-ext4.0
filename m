From: akpm@osdl.org
Subject: + ext4-balloc-reset-windowsz-when-full.patch added to -mm tree
Date: Wed, 29 Nov 2006 14:17:00 -0800
Message-ID: <200611292217.kATMH0cq013188@shell0.pdx.osdl.net>
Cc: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:64452 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1758871AbWK2WVF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Nov 2006 17:21:05 -0500
To: mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4 balloc: reset windowsz when full
has been added to the -mm tree.  Its filename is
     ext4-balloc-reset-windowsz-when-full.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4 balloc: reset windowsz when full
From: Hugh Dickins <hugh@veritas.com>

ext4_new_blocks should reset the reservation window size to 0 when squeezing
the last blocks out of an almost full filesystem, so the retry doesn't skip
any groups with less than half that free, reporting ENOSPC too soon.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/ext4/balloc.c~ext4-balloc-reset-windowsz-when-full fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-balloc-reset-windowsz-when-full
+++ a/fs/ext4/balloc.c
@@ -1566,6 +1566,7 @@ retry_alloc:
 	 */
 	if (my_rsv) {
 		my_rsv = NULL;
+		windowsz = 0;
 		group_no = goal_group;
 		goto retry_alloc;
 	}
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
ext4-balloc-reset-windowsz-when-full.patch
ext4-balloc-fix-off-by-one-against-grp_goal.patch
ext4-balloc-fix-off-by-one-against-rsv_end.patch
ext4-balloc-say-rb_entry-not-list_entry.patch
ext4-balloc-use-io_error-label.patch
ext4-balloc-fix-_with_rsv-freeze.patch
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
