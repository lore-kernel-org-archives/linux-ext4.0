From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/10] libext2fs: adjust the description when copying a bitmap
Date: Sun, 18 Dec 2011 01:42:37 -0500
Message-ID: <1324190558-7436-10-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50570 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Label the copy of a bitmap as "copy of ..." so that the bitmap's
description is more descriptive.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/gen_bitmap64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 7b066a2..9dcca03 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -212,12 +212,12 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
 
 	descr = src->description;
 	if (descr) {
-		retval = ext2fs_get_mem(strlen(descr)+1, &new_descr);
+		retval = ext2fs_get_mem(strlen(descr)+10, &new_descr);
 		if (retval) {
 			ext2fs_free_mem(&new_bmap);
 			return retval;
 		}
-		strcpy(new_descr, descr);
+		sprintf(new_descr, "copy of %s", descr);
 		new_bmap->description = new_descr;
 	}
 
-- 
1.7.8.11.gefc1f.dirty

