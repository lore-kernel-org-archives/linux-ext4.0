From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4: let ext4_ext_rm_leaf work with EXT_DEBUG defined
Date: Tue,  1 Nov 2011 11:24:26 +0800
Message-ID: <1320117866-16571-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: dmonakhov@openvz.org, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37211 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1KAFa5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 01:30:57 -0400
Received: by iaby12 with SMTP id y12so7945580iab.19
        for <linux-ext4@vger.kernel.org>; Mon, 31 Oct 2011 22:30:56 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Var block is removed by commit 750c9c47, so ex_ee_block is used
instead.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2798945..4b10b58 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2424,7 +2424,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		if (err)
 			goto out;
 
-		ext_debug("new extent: %u:%u:%llu\n", block, num,
+		ext_debug("new extent: %u:%u:%llu\n", ex_ee_block, num,
 				ext4_ext_pblock(ex));
 		ex--;
 		ex_ee_block = le32_to_cpu(ex->ee_block);
-- 
1.7.5.1

