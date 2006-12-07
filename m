From: akpm@osdl.org
Subject: [patch 326/354] ext4: fix credit calculation in ext4_ext_calc_credits_for_insert
Date: Wed, 06 Dec 2006 20:40:46 -0800
Message-ID: <200612070440.kB74elHt030245@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, johann.lombardi@bull.net, alex@clusterfs.com,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47459 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968762AbWLGEky (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:40:54 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

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
