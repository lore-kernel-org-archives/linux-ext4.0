From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext2fs: fix ext2fs_warn_bitmap32() return warning
Date: Fri, 10 Jun 2011 00:11:30 -0600
Message-ID: <1307686290-11008-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5199 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab1FJGLb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 02:11:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This was reported as "control reaches end of non-void function",
but comparing to other similar functions it should be a void
function.  Since it is only declared in the "private" ext2fsP.h
header, it should be OK to change the function prototype.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/ext2fsP.h      |    2 +-
 lib/ext2fs/gen_bitmap64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2fsP.h b/lib/ext2fs/ext2fsP.h
index ab9ee76..b182d7f 100644
--- a/lib/ext2fs/ext2fsP.h
+++ b/lib/ext2fs/ext2fsP.h
@@ -138,6 +138,6 @@ extern errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bitmap,
 extern errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bitmap,
 					       __u64 start, unsigned int num,
 					       void *out);
-extern int ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap, const char *func);
+extern void ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap,const char *func);
 
 extern int ext2fs_mem_is_zero(const char *mem, size_t len);
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 94809cd..294194c 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -548,7 +548,7 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 	bmap->bitmap_ops->unmark_bmap_extent(bmap, block, num);
 }
 
-int ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap, const char *func)
+void ext2fs_warn_bitmap32(ext2fs_generic_bitmap bitmap, const char *func)
 {
 #ifndef OMIT_COM_ERR
 	if (bitmap && bitmap->description)
-- 
1.7.3.4

