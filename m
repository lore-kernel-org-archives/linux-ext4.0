From: akpm@osdl.org
Subject: - ext4-fix-credit-calculation-in-ext4_ext_calc_credits_for_insert.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:14 -0800
Message-ID: <200612072317.kB7NHE5C030908@shell0.pdx.osdl.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53800 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163829AbWLGXRW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:22 -0500
To: johann.lombardi@bull.net, alex@clusterfs.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext4: fix credit calculation in ext4_ext_calc_credits_for_insert
has been removed from the -mm tree.  Its filename was
     ext4-fix-credit-calculation-in-ext4_ext_calc_credits_for_insert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4: fix credit calculation in ext4_ext_calc_credits_for_insert
From: Johann Lombardi <johann.lombardi@bull.net>

Fix a nit in ext4_ext_calc_credits_for_insert().  Besides, credits for the
new root are already added in the index split accounting.

Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>
Signed-off-by: Alex Tomas <alex@clusterfs.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/ext4/extents.c~ext4-fix-credit-calculation-in-ext4_ext_calc_credits_for_insert fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-fix-credit-calculation-in-ext4_ext_calc_credits_for_insert
+++ a/fs/ext4/extents.c
@@ -1531,16 +1531,17 @@ int inline ext4_ext_calc_credits_for_ins
 
 	/*
 	 * tree can be full, so it would need to grow in depth:
-	 * allocation + old root + new root
+	 * we need one credit to modify old root, credits for
+	 * new root will be added in split accounting
 	 */
-	needed += 2 + 1 + 1;
+	needed += 1;
 
 	/*
 	 * Index split can happen, we would need:
 	 *    allocate intermediate indexes (bitmap + group)
 	 *  + change two blocks at each level, but root (already included)
 	 */
-	needed = (depth * 2) + (depth * 2);
+	needed += (depth * 2) + (depth * 2);
 
 	/* any allocation modifies superblock */
 	needed += 1;
_

Patches currently in -mm which might be from johann.lombardi@bull.net are

origin.patch
