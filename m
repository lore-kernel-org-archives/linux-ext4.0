From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH V2 2/6] ext4: add a delayed extents tree in inode info
Date: Thu, 29 Sep 2011 13:08:42 +0800
Message-ID: <1317272926-13303-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, jeff.liu@oracle.com, achender@linux.vnet.ibm.com,
	adityakali@google.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61452 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1I2Glb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:41:31 -0400
Received: by mail-yx0-f174.google.com with SMTP id 31so323102yxl.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 23:41:31 -0700 (PDT)
In-Reply-To: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a delayed extents tree in inode info, so that
delayed extents can be look up quickly.  Without the tree
delayed extents are identified by looking up page cache.

With the tree, FIEMAP, SEEK_HOLE/DATA, bigalloc and writeout
path can be optimized a lot.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ccfa81f..d3c6b97 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -760,6 +760,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "delayed_extents.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -837,6 +839,9 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* delayed extents */
+	struct ext4_de_tree i_de_tree;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
-- 
1.7.5.1

