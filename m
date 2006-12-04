From: Johann Lombardi <johann.lombardi@bull.net>
Subject: [PATCH] ext4: fix credit calculation in ext4_ext_calc_credits_for_insert
Date: Mon, 4 Dec 2006 18:21:42 +0100
Message-ID: <20061204172142.GD7492@lombardij>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: akpm@osdl.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57757 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbWLDRVZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2006 12:21:25 -0500
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello,

The patch below fixes a nit in ext4_ext_calc_credits_for_insert().
Besides, credits for the new root are already added in the index split
accounting.

Johann

Signed-off-by: Johann Lombardi <johann.lombardi@bull.net>
Signed-off-by: Alex Tomas <alex@clusterfs.com>
---

Index: linux-2.6.19/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.orig/fs/ext4/extents.c	2006-12-04 16:59:41.760257656 +0100
+++ linux-2.6.19/fs/ext4/extents.c	2006-12-04 17:04:35.566592304 +0100
@@ -1534,16 +1534,17 @@ int inline ext4_ext_calc_credits_for_ins
 
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
