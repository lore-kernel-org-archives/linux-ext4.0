From: akpm@osdl.org
Subject: [patch 346/354] ext3 balloc: fix off-by-one against rsv_end
Date: Wed, 06 Dec 2006 20:41:25 -0800
Message-ID: <200612070441.kB74fQ1B030360@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47783 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968780AbWLGEoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:44:44 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

rsv_end is the last block within the reservation, so alloc_new_reservation
should accept start_block == rsv_end as success.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/balloc.c~ext3-balloc-fix-off-by-one-against-rsv_end fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-fix-off-by-one-against-rsv_end
+++ a/fs/ext3/balloc.c
@@ -1148,7 +1148,7 @@ retry:
 	 * check if the first free block is within the
 	 * free space we just reserved
 	 */
-	if (start_block >= my_rsv->rsv_start && start_block < my_rsv->rsv_end)
+	if (start_block >= my_rsv->rsv_start && start_block <= my_rsv->rsv_end)
 		return 0;		/* success */
 	/*
 	 * if the first free bit we found is out of the reservable space
_
