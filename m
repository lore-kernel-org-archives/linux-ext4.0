From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH v2] ext4: remove unused parameter "newblock" in convert_initialized_extent()
Date: Thu, 11 Feb 2016 00:09:04 +0800
Message-ID: <1455120544-17524-1-git-send-email-guaneryu@gmail.com>
References: <1455117406-15497-2-git-send-email-guaneryu@gmail.com>
Cc: tytso@mit.edu, Eryu Guan <guaneryu@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35037 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcBJQKZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2016 11:10:25 -0500
Received: by mail-pf0-f194.google.com with SMTP id w128so596723pfb.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2016 08:10:24 -0800 (PST)
In-Reply-To: <1455117406-15497-2-git-send-email-guaneryu@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The "newblock" parameter is not used in convert_initialized_extent(),
remove it.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

v2:
- Fix build error in v1, I tested the good patch and sent the wrong one...

 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0ffabaf..3753ceb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3928,7 +3928,7 @@ static int
 convert_initialized_extent(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map,
 			   struct ext4_ext_path **ppath, int flags,
-			   unsigned int allocated, ext4_fsblk_t newblock)
+			   unsigned int allocated)
 {
 	struct ext4_ext_path *path = *ppath;
 	struct ext4_extent *ex;
@@ -4347,7 +4347,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			    (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
 				allocated = convert_initialized_extent(
 						handle, inode, map, &path,
-						flags, allocated, newblock);
+						flags, allocated);
 				goto out2;
 			} else if (!ext4_ext_is_unwritten(ex))
 				goto out;
-- 
2.5.0

