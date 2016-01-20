From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: trim unused params from convert_initialized_extent()
Date: Wed, 20 Jan 2016 15:19:23 -0500
Message-ID: <20160120201923.GA2650@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36816 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbcATUTk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jan 2016 15:19:40 -0500
Received: by mail-qg0-f44.google.com with SMTP id e32so15769324qgf.3
        for <linux-ext4@vger.kernel.org>; Wed, 20 Jan 2016 12:19:40 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The flags and newblock parameters are unused.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index b52fea3..0288b47 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3927,8 +3927,8 @@ get_reserved_cluster_alloc(struct inode *inode, ext4_lblk_t lblk_start,
 static int
 convert_initialized_extent(handle_t *handle, struct inode *inode,
 			   struct ext4_map_blocks *map,
-			   struct ext4_ext_path **ppath, int flags,
-			   unsigned int allocated, ext4_fsblk_t newblock)
+			   struct ext4_ext_path **ppath,
+			   unsigned int allocated)
 {
 	struct ext4_ext_path *path = *ppath;
 	struct ext4_extent *ex;
@@ -4347,7 +4347,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			    (flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN)) {
 				allocated = convert_initialized_extent(
 						handle, inode, map, &path,
-						flags, allocated, newblock);
+						allocated);
 				goto out2;
 			} else if (!ext4_ext_is_unwritten(ex))
 				goto out;
-- 
2.1.4

