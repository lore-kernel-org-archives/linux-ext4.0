From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC][PATCH 1/6] delalloc ENOSPC: Add per-inode counters to store
	reserved blocks
Date: Sun, 01 Jun 2008 16:35:33 -0700
Message-ID: <1212363333.4368.64.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:43071 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328AbYFAXfl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Jun 2008 19:35:41 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m51NZdIQ013761
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 19:35:39 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m51NZcLs089686
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:35:38 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m51NZc0Z004317
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:35:38 -0600
Received: from [9.67.174.55] (wecm-9-67-174-55.wecm.ibm.com [9.67.174.55])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m51NZbC9004290
	for <linux-ext4@vger.kernel.org>; Sun, 1 Jun 2008 17:35:38 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: delalloc -- Adding per inode counters to store reserved blocks

From: Mingming cao <cmm@us.ibm.com>

Add per-inode counters to store number of resreved data blocks
and metadata blocks, due to delayed allocation.

Signed-off-by: Mingming cao <cmm@us.ibm.com>
---
 fs/ext4/ext4_i.h |    4 ++++
 fs/ext4/super.c  |    2 ++
 2 files changed, 6 insertions(+)

Index: linux-2.6.26-rc4/fs/ext4/ext4_i.h
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/ext4_i.h	2008-06-01 13:06:25.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/ext4_i.h	2008-06-01 14:26:14.000000000 -0700
@@ -162,6 +162,10 @@ struct ext4_inode_info {
 	/* mballoc */
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
+
+	/* allocation reservation info for delalloc */
+	unsigned long i_reserved_data_blocks;
+	unsigned long i_reserved_meta_blocks;
 };
 
 #endif	/* _EXT4_I */
Index: linux-2.6.26-rc4/fs/ext4/super.c
===================================================================
--- linux-2.6.26-rc4.orig/fs/ext4/super.c	2008-06-01 14:22:03.000000000 -0700
+++ linux-2.6.26-rc4/fs/ext4/super.c	2008-06-01 14:26:14.000000000 -0700
@@ -572,6 +572,8 @@ static struct inode *ext4_alloc_inode(st
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ei->i_reserved_data_blocks = 0;
+	ei->i_reserved_meta_blocks = 0;
 	return &ei->vfs_inode;
 }
 


