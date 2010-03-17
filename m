From: Steven Liu <lingjiujianke@gmail.com>
Subject: [PATCH] ext4: Fix coding style in fs/ext4/move_extent.c
Date: Wed, 17 Mar 2010 18:12:14 +0800
Message-ID: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: tytso@mit.edu, adilger@sun.com, linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61826 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0CQKMP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Mar 2010 06:12:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fix a code style in fs/ext4/move_extent.c

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 fs/ext4/move_extent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index aa5fe28..b399358 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -481,6 +481,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 	int depth = ext_depth(orig_inode);
 	int ret;

+	start_ext.ee_block = end_ext.ee_block = 0;
 	o_start = o_end = oext = orig_path[depth].p_ext;
 	oext_alen = ext4_ext_get_actual_len(oext);
 	start_ext.ee_len = end_ext.ee_len = 0;
-- 
1.6.0.3
