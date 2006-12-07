From: akpm@osdl.org
Subject: [patch 273/354] ext4 balloc: reset windowsz when full
Date: Wed, 06 Dec 2006 20:39:18 -0800
Message-ID: <200612070439.kB74dITq029997@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47617 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968770AbWLGEmj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:42:39 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
 1 file changed, 1 insertion(+)

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
