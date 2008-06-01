From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 2/6] delalloc ENOSPC: estimate metadata blocks needed
	to reserve
Date: Sun, 01 Jun 2008 16:35:46 -0700
Message-ID: <1212363346.4368.65.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45557 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbYFAXfv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 1 Jun 2008 19:35:51 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51NZpYv004253
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:51 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51NZpLR144316
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51NZorM031693
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:50 -0400
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51NZo3F031686
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: delalloc --estimate need metadata blocks to reserve

From: Mingming cao <cmm@us.ibm.com>

Calculate the number of metadata blocks needed to allocate blocks
Worse case is one block per extent

Signed-off-by: Mingming cao <cmm@us.ibm.com>

---
 fs/ext4/ext4_extents.h |    1 +
 fs/ext4/extents.c      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

Index: linux-2.6.26-rc4/fs/ext4/ext4_extents.h
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/ext4_extents.h	2008-06-01 14:22:03.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/ext4_extents.h	2008-06-01 14:57:57.000000000 -0700
@@ -212,6 +212,7 @@ static inline int ext4_ext_get_actual_le
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
 
+extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
Index: linux-2.6.26-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/extents.c	2008-06-01 14:22:03.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/extents.c	2008-06-01 14:57:57.000000000 -0700
@@ -246,6 +246,36 @@ static int ext4_ext_space_root_idx(struc
 	return size;
 }
 
+/*
+ * Calculate the number of metadata blocks needed
+ * to allocate @blocks
+ * Worse case is one block per extent
+ */
+int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	int lcap, icap, rcap, leafs, idxs, num;
+	int newextents = blocks;
+
+	rcap = ext4_ext_space_root_idx(inode);
+	lcap = ext4_ext_space_block(inode);
+	icap = ext4_ext_space_block_idx(inode);
+
+	/* number of new leaf blocks needed */
+	num = leafs = (newextents + lcap - 1) / lcap;
+
+	/*
+	 * Worse case, we need separate index block(s)
+	 * to link all new leaf blocks
+	 */
+	idxs = (leafs + icap - 1) / icap;
+	do {
+	        num += idxs;
+	        idxs = (idxs + icap - 1) / icap;
+	} while (idxs > rcap);
+
+	return num;
+}
+
 static int
 ext4_ext_max_entries(struct inode *inode, int depth)
 {


