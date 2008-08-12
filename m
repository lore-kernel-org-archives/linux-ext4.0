From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 6/6 ]Ext4 journal credits reservation fixes for defrag
Date: Tue, 12 Aug 2008 09:37:14 -0700
Message-ID: <1218559034.6766.58.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
	 <1216774311.6505.4.camel@mingming-laptop>
	 <20080723074226.GA15091@skywalker>
	 <1217032947.6394.2.camel@mingming-laptop>
	 <1218558190.6766.37.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>
To: tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39629 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYHLQh5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2008 12:37:57 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7CGbuEX009572
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:37:56 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CGbuoW227158
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:37:56 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CGbtk3025578
	for <linux-ext4@vger.kernel.org>; Tue, 12 Aug 2008 12:37:56 -0400
In-Reply-To: <1218558190.6766.37.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

defrag part change. This patch should be merged with
ext4-online-defrag-alloc-contiguous-blks.patch

Cc: Akira Fujita <a-fujita@rs.jp.nec.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
Index: linux-2.6.27-rc1/fs/ext4/defrag.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/ext4/defrag.c	2008-08-11 17:15:49.000000000 -0700
+++ linux-2.6.27-rc1/fs/ext4/defrag.c	2008-08-11 19:46:59.000000000 -0700
@@ -186,9 +186,9 @@ ext4_defrag_alloc_blocks(handle_t *handl
 	struct buffer_head *bh = NULL;
 	int err, i, credits = 0;
 
-	credits = ext4_ext_calc_credits_for_insert(dest_inode, dest_path);
-	err = ext4_ext_journal_restart(handle,
-				credits + EXT4_TRANS_META_BLOCKS);
+	credits = ext4_ext_calc_credits_for_single_extent(dest_inode,
+							  ar->len, dest_path);
+	err = ext4_ext_journal_restart(handle, credits);
 	if (err)
 		return err;
 


