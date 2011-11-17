From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/6] ext4: remove unnecessary var in ext4_ext_insert_extent
Date: Thu, 17 Nov 2011 10:03:20 +0800
Message-ID: <1321495405-9583-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38853 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1KQEbu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 23:31:50 -0500
Received: by iage36 with SMTP id e36so1594550iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Nov 2011 20:31:50 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Var(uninitialized) is not necessary.  As the comment says,
two extent are either initialized or uninitialized.  So
checking newext is ok.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..6b4a558 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1665,7 +1665,6 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err;
 	ext4_lblk_t next;
-	unsigned uninitialized = 0;
 	int flags = 0;
 
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
@@ -1698,11 +1697,9 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 		 * both extents are uninitialized, or both aren't. Thus we
 		 * need to check only one of them here.
 		 */
-		if (ext4_ext_is_uninitialized(ex))
-			uninitialized = 1;
 		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 					+ ext4_ext_get_actual_len(newext));
-		if (uninitialized)
+		if (ext4_ext_is_uninitialized(newext))
 			ext4_ext_mark_uninitialized(ex);
 		eh = path[depth].p_hdr;
 		nearex = ex;
-- 
1.7.5.1

