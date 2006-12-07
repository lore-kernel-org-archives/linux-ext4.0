From: akpm@osdl.org
Subject: [patch 349/354] ext3 balloc: fix _with_rsv freeze
Date: Wed, 06 Dec 2006 20:41:30 -0800
Message-ID: <200612070441.kB74fVK9030377@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968784AbWLGEpe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:45:34 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

Port fix to the off-by-one in find_next_usable_block's memscan from ext2 to
ext3; but it didn't cause a serious problem for ext3 because the additional
ext3_test_allocatable check rescued it from the error.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
