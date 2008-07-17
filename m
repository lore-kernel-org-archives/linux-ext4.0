From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH][e2fsprogs] Fix inode table allocation with flexbg
Date: Thu, 17 Jul 2008 13:34:41 +0200
Message-ID: <1216294481.3136.18.camel@localhost>
References: <20080701084357.819339274@bull.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40024 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbYGQJdm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Jul 2008 05:33:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 0E34F1A192E
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 11:34:14 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 10364-10 for <linux-ext4@vger.kernel.org>;
 Thu, 17 Jul 2008 11:34:10 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 6B9541A1915
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 11:34:10 +0200 (CEST)
Received: from [129.183.101.222] (dhcp129183101222.frec.bull.fr [129.183.101.222])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 63E262728D
	for <linux-ext4@vger.kernel.org>; Thu, 17 Jul 2008 11:34:07 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Disordered inode tables may appear when inode_blocks_per_group is lesser
or equal to the number of groups in a flex group.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
This bug can be reproduced with:
 mkfs.ext4 -t ext4dev -G512 70G

In that case, you can see with dump2fs that inode tables for groups 510
and 511 are placed just after group 51's inode table instead of being 
placed after group 509's inode table.

 alloc_tables.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: e2fsprogs/lib/ext2fs/alloc_tables.c
===================================================================
--- e2fsprogs.orig/lib/ext2fs/alloc_tables.c	2008-07-17 10:33:56.000000000 +0200
+++ e2fsprogs/lib/ext2fs/alloc_tables.c	2008-07-17 10:46:49.000000000 +0200
@@ -34,9 +34,10 @@
  * tables can be allocated continously and in order.
  */
 static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
-			   ext2fs_block_bitmap bmap, int offset, int size)
+			   ext2fs_block_bitmap bmap, int offset, int size,
+			   int elem_size)
 {
-	int		flexbg, flexbg_size, elem_size;
+	int		flexbg, flexbg_size;
 	blk_t		last_blk, first_free = 0;
 	dgrp_t	       	last_grp;
 
@@ -54,10 +55,6 @@ static blk_t flexbg_offset(ext2_filsys f
 	 * search is still valid.
 	 */
 	if (start_blk && group % flexbg_size) {
-		if (size > flexbg_size)
-			elem_size = fs->inode_blocks_per_group;
-		else
-			elem_size = 1;
 		if (ext2fs_test_block_bitmap_range(bmap, start_blk + elem_size,
 						   size))
 			return start_blk + elem_size;
@@ -126,7 +123,7 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (group && fs->group_desc[group-1].bg_block_bitmap)
 			prev_block = fs->group_desc[group-1].bg_block_bitmap;
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
-						 0, rem_grps);
+						 0, rem_grps, 1);
 		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}
 
@@ -154,7 +151,7 @@ errcode_t ext2fs_allocate_group_table(ex
 		if (group && fs->group_desc[group-1].bg_inode_bitmap)
 			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
-						 flexbg_size, rem_grps);
+						 flexbg_size, rem_grps, 1);
 		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}
 
@@ -187,7 +184,8 @@ errcode_t ext2fs_allocate_group_table(ex
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 flexbg_size * 2,
 						 fs->inode_blocks_per_group *
-						 rem_grps);
+						 rem_grps,
+						 fs->inode_blocks_per_group);
 		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}

-- 

