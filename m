From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] ext4: teach resize report old blocks count correctly
Date: Wed,  1 Feb 2012 11:01:30 +0800
Message-ID: <1328065291-13607-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org, dsd@laptop.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2DAMBI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 1 Apr 2012 08:01:08 -0400
Received: by iagz16 with SMTP id z16so2911633iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 01 Apr 2012 05:01:08 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

o_blocks_count should not be changed, becasuse it is used later when
reporting old blocks count in debug mode.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 59fa0be..601fea1 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1654,8 +1654,7 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	    es->s_log_groups_per_flex)
 		flexbg_size = 1 << es->s_log_groups_per_flex;
 
-	o_blocks_count = ext4_blocks_count(es);
-	if (o_blocks_count == n_blocks_count)
+	if (ext4_blocks_count(es) == n_blocks_count)
 		goto out;
 
 	flex_gd = alloc_flex_gd(flexbg_size);
-- 
1.7.5.1

