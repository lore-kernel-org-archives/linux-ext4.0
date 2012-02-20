From: Haogang Chen <haogangchen@gmail.com>
Subject: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
Date: Mon, 20 Feb 2012 17:41:24 -0500
Message-ID: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
Cc: linux-kernel@vger.kernel.org, haogangchen@gmail.com
To: Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61809 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2BTWoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2012 17:44:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In alloc_flex_gd(), when flexbg_size is large, kmalloc size would
overflow and flex_gd->groups would point to a buffer smaller than
expected, causing OOB accesses when it is used.

Note that in ext4_resize_fs(), flexbg_size is calculated using
sbi->s_log_groups_per_flex, which is read from the disk and only bounded
to [1, 31]. The patch returns NULL for too large flexbg_size.

Signed-off-by: Haogang Chen <haogangchen@gmail.com>
---
 fs/ext4/resize.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index f9d948f..8601f4b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -161,6 +161,8 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long flexbg_size)
 	if (flex_gd == NULL)
 		goto out3;
 
+	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_flex_group_data))
+		goto out2;
 	flex_gd->count = flexbg_size;
 
 	flex_gd->groups = kmalloc(sizeof(struct ext4_new_group_data) *
-- 
1.7.5.4

