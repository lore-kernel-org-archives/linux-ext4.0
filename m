From: Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH] ext4: remove extra defination of ext4_new_blocks_old()
Date: Thu, 21 Feb 2008 17:40:12 -0800
Message-ID: <1203644412.3638.34.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51698 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760132AbYBVBkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Feb 2008 20:40:49 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1M1eklx017830
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 20:40:46 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1M1ekLa299360
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 20:40:46 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1M1ekmo024378
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 20:40:46 -0500
Received: from [9.47.17.70] (w-ming-laptop.beaverton.ibm.com [9.47.17.70])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m1M1ejZw022244
	for <linux-ext4@vger.kernel.org>; Thu, 21 Feb 2008 20:40:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_new_blocks_old() is already externed in ext4_fs.h, remove the extra
define from mballoc.c. Trivial cleanup, but this cause extra maintain work
if later we need to modify this function.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/mballoc.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6.25-rc2/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/mballoc.c	2008-02-21 17:23:26.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/mballoc.c	2008-02-21 17:23:54.000000000 -0800
@@ -576,8 +576,6 @@ static void ext4_mb_store_history(struct
 
 static struct proc_dir_entry *proc_root_ext4;
 struct buffer_head *read_block_bitmap(struct super_block *, ext4_group_t);
-ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
 
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
