From: akpm@osdl.org
Subject: [patch 344/354] ext3 balloc: reset windowsz when full
Date: Wed, 06 Dec 2006 20:41:23 -0800
Message-ID: <200612070441.kB74fNgo030352@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968787AbWLGEru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:47:50 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

ext3_new_blocks should reset the reservation window size to 0 when squeezing
the last blocks out of an almost full filesystem, so the retry doesn't skip
any groups with less than half that free, reporting ENOSPC too soon.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ext3/balloc.c~ext3-balloc-reset-windowsz-when-full fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-reset-windowsz-when-full
+++ a/fs/ext3/balloc.c
@@ -1552,6 +1552,7 @@ retry_alloc:
 	 */
 	if (my_rsv) {
 		my_rsv = NULL;
+		windowsz = 0;
 		group_no = goal_group;
 		goto retry_alloc;
 	}
_
