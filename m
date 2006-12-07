From: akpm@osdl.org
Subject: [patch 278/354] ext4 balloc: fix _with_rsv freeze
Date: Wed, 06 Dec 2006 20:39:26 -0800
Message-ID: <200612070439.kB74dQsw030024@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47296 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968760AbWLGEjx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:39:53 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
