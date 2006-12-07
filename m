From: akpm@osdl.org
Subject: - ext4-balloc-use-io_error-label.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:14:49 -0800
Message-ID: <200612072314.kB7NEn02030657@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163879AbWLGXPn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Dec 2006 18:15:43 -0500
To: hugh@veritas.com, cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4 balloc: use io_error label
has been removed from the -mm tree.  Its filename was
     ext4-balloc-use-io_error-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4 balloc: use io_error label
From: Hugh Dickins <hugh@veritas.com>

ext4_new_blocks has a nice io_error label for setting -EIO, so goto that in
the one place that doesn't already use it.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-balloc-use-io_error-label fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-balloc-use-io_error-label
+++ a/fs/ext4/balloc.c
@@ -1529,10 +1529,8 @@ retry_alloc:
 		if (group_no >= ngroups)
 			group_no = 0;
 		gdp = ext4_get_group_desc(sb, group_no, &gdp_bh);
-		if (!gdp) {
-			*errp = -EIO;
-			goto out;
-		}
+		if (!gdp)
+			goto io_error;
 		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
 		/*
 		 * skip this group if the number of
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
