From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 2/2 bigalloc] e2fsprogs: use s_log_block_size to decide s_first_data_block in ext2fs_initialize
Date: Fri,  5 Aug 2011 12:27:51 +0800
Message-ID: <1312518471-30714-2-git-send-email-hao.bigrat@gmail.com>
References: <1312518471-30714-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50570 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab1HEE2E (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2011 00:28:04 -0400
Received: by ywn13 with SMTP id 13so1476293ywn.19
        for <linux-ext4@vger.kernel.org>; Thu, 04 Aug 2011 21:28:03 -0700 (PDT)
In-Reply-To: <1312518471-30714-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

After mke2fs with 1024 block size:

#misc/mke2fs -m 0 -O ^resize_inode,extent,meta_bg,bigalloc -b 1024 /dev/sda

kernel reports:

[74687.352702] EXT4-fs (loop0): ext4_check_descriptors: Inode bitmap for group 0 not in group (block 524288)!
[74687.355534] EXT4-fs (loop0): group descriptors corrupted!

when mount /dev/sda.

The reason is mke2fs set s_first_data_block to 0 by mistake just because
s_log_cluster_size is 4 when s_log_block_size==0.

This patch is based on "next" branch of e2fsprogs.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 lib/ext2fs/initialize.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index ccc2dee..c2344a0 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -155,7 +155,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	} else
 		super->s_log_cluster_size = super->s_log_block_size;
 
-	set_field(s_first_data_block, super->s_log_cluster_size ? 0 : 1);
+	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, 0);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
 	set_field(s_feature_compat, 0);
-- 
1.7.3.2

