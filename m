From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: fix reference counting bug on block allocation error
Date: Wed,  6 Jul 2016 15:57:32 +0200
Message-ID: <1467813452-26763-1-git-send-email-vegard.nossum@oracle.com>
Cc: linux-ext4@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36540 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbcGFN5r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2016 09:57:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we hit this error when mounted with errors=continue or
errors=remount-ro:

    EXT4-fs error (device loop0): ext4_mb_mark_diskspace_used:2940: comm ext4.exe: Allocating blocks 5090-6081 which overlap fs metadata

then ext4_mb_new_blocks() will call ext4_mb_release_context() and try to
continue. However, ext4_mb_release_context() is the wrong thing to call
here since we are still actually using the allocation context.

Instead, handle it the same way that we handle other errors, except that
we retry the allocation instead of immediately returning an error (if we
were mounted with errors=continue, then ext4_mb_mark_diskspace_used()
should have fixed the original error and will either succeed or give a
different error; if we were mounted with errors=remount-ro, then it will
not be able to fix the original error and will raise a different error).

Fixes: 8556e8f3b6 ("ext4: Don't allow new groups to be added during block allocation")
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/mballoc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec..0370f76 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4514,11 +4514,7 @@ repeat:
 	if (likely(ac->ac_status == AC_STATUS_FOUND)) {
 		*errp = ext4_mb_mark_diskspace_used(ac, handle, reserv_clstrs);
 		if (*errp == -EAGAIN) {
-			/*
-			 * drop the reference that we took
-			 * in ext4_mb_use_best_found
-			 */
-			ext4_mb_release_context(ac);
+			ext4_discard_allocated_blocks(ac);
 			ac->ac_b_ex.fe_group = 0;
 			ac->ac_b_ex.fe_start = 0;
 			ac->ac_b_ex.fe_len = 0;
-- 
1.9.1

