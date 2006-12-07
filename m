From: akpm@osdl.org
Subject: [patch 348/354] ext3 balloc: use io_error label
Date: Wed, 06 Dec 2006 20:41:28 -0800
Message-ID: <200612070441.kB74fTLs030373@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, hugh@veritas.com, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47559 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968767AbWLGEli (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:41:38 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Hugh Dickins <hugh@veritas.com>

ext3_new_blocks has a nice io_error label for setting -EIO, so goto that in
the one place that doesn't already use it.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/balloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/ext3/balloc.c~ext3-balloc-use-io_error-label fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~ext3-balloc-use-io_error-label
+++ a/fs/ext3/balloc.c
@@ -1515,10 +1515,8 @@ retry_alloc:
 		if (group_no >= ngroups)
 			group_no = 0;
 		gdp = ext3_get_group_desc(sb, group_no, &gdp_bh);
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
