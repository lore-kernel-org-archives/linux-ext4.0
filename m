From: akpm@osdl.org
Subject: - ext4-balloc-fix-_with_rsv-freeze.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:14:51 -0800
Message-ID: <200612072314.kB7NEpS0030661@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53509 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163916AbWLGXPH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:07 -0500
To: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4 balloc: fix _with_rsv freeze
has been removed from the -mm tree.  Its filename was
     ext4-balloc-fix-_with_rsv-freeze.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4 balloc: fix _with_rsv freeze
From: Hugh Dickins <hugh@veritas.com>

Port fix to the off-by-one in find_next_usable_block's memscan from ext2 to
ext4; but it didn't cause a serious problem for ext4 because the additional
ext4_test_allocatable check rescued it from the error.

[akpm@osdl.org: build fix]
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/balloc.c~ext4-balloc-fix-_with_rsv-freeze fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-balloc-fix-_with_rsv-freeze
+++ a/fs/ext4/balloc.c
@@ -747,7 +747,7 @@ find_next_usable_block(ext4_grpblk_t sta
 		here = 0;
 
 	p = ((char *)bh->b_data) + (here >> 3);
-	r = memscan(p, 0, (maxblocks - here + 7) >> 3);
+	r = memscan(p, 0, ((maxblocks + 7) >> 3) - (here >> 3));
 	next = (r - ((char *)bh->b_data)) << 3;
 
 	if (next < maxblocks && next >= start && ext4_test_allocatable(next, bh))
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
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
