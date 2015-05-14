From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: remove unused function prototype from ext4.h
Date: Thu, 14 May 2015 18:43:53 -0400
Message-ID: <1431643433-24741-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37364 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965140AbbENWn5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2015 18:43:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext4_extent_tree_init() function hasn't been in the ext4 code for
a long time ago, except in an unused function prototype in ext4.h

Google-Bug-Id: 4530137
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 009a059..9a83f14 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2889,7 +2889,6 @@ extern int ext4_map_blocks(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map, int flags);
 extern int ext4_ext_calc_metadata_amount(struct inode *inode,
 					 ext4_lblk_t lblocks);
-extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
-- 
2.3.0

