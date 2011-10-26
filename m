From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/4] ext4: let AGGRESSIVE_TEST brace code only related to itself
Date: Wed, 26 Oct 2011 15:11:51 +0800
Message-ID: <1319613112-16807-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49041 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab1JZJHz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Oct 2011 05:07:55 -0400
Received: by gyb13 with SMTP id 13so1345278gyb.19
        for <linux-ext4@vger.kernel.org>; Wed, 26 Oct 2011 02:07:55 -0700 (PDT)
In-Reply-To: <1319613112-16807-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8b09a47..49b4e28 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -182,12 +182,12 @@ static inline int ext4_ext_space_block(struct inode *inode, int check)
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
+	if (!check) {
 		if (size > 6)
 			size = 6;
-#endif
 	}
+#endif
 	return size;
 }
 
@@ -197,12 +197,12 @@ static inline int ext4_ext_space_block_idx(struct inode *inode, int check)
 
 	size = (inode->i_sb->s_blocksize - sizeof(struct ext4_extent_header))
 			/ sizeof(struct ext4_extent_idx);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
+	if (!check) {
 		if (size > 5)
 			size = 5;
-#endif
 	}
+#endif
 	return size;
 }
 
@@ -213,12 +213,12 @@ static inline int ext4_ext_space_root(struct inode *inode, int check)
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
+	if (!check) {
 		if (size > 3)
 			size = 3;
-#endif
 	}
+#endif
 	return size;
 }
 
@@ -229,12 +229,12 @@ static inline int ext4_ext_space_root_idx(struct inode *inode, int check)
 	size = sizeof(EXT4_I(inode)->i_data);
 	size -= sizeof(struct ext4_extent_header);
 	size /= sizeof(struct ext4_extent_idx);
-	if (!check) {
 #ifdef AGGRESSIVE_TEST
+	if (!check) {
 		if (size > 4)
 			size = 4;
-#endif
 	}
+#endif
 	return size;
 }
 
-- 
1.7.5.1

