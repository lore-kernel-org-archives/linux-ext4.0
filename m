From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH 2/5] ext4: add a delayed extents list in inode
Date: Tue, 30 Aug 2011 17:00:18 +0800
Message-ID: <1314694821-17213-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, adityakali@google.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38263 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1H3Jnn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 05:43:43 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so10017235pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 02:43:42 -0700 (PDT)
In-Reply-To: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a delayed extents list in inode, so that
delayed extents can be look up quickly.  Without the tree
delayed extents are identified by looking up page cache.

With the list, FIEMAP, SEEK_HOLE/DATA, bigalloc and writeout
path can be optimized a lot.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h  |    5 +++++
 fs/ext4/super.c |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b4bff1a..6c5bfd6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -759,6 +759,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "delayed_extents.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -836,6 +838,9 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* delayed_extents.c */
+	struct ext4_delayed_info i_delayed_info;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c3e3a80..f0b6fe6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -880,6 +880,8 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	ei->vfs_inode.i_data.writeback_index = 0;
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
+	memset(&ei->i_delayed_info, 0, sizeof(struct ext4_delayed_info));
+	INIT_LIST_HEAD(&ei->i_delayed_info.de_list);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
 	ei->i_reserved_data_blocks = 0;
-- 
1.7.5.1

