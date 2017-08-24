From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] libext2fs: Skip start_blk adjustment when stride and flex_bg is set
Date: Thu, 24 Aug 2017 15:35:39 +0200
Message-ID: <1503581739-6385-2-git-send-email-lczerner@redhat.com>
References: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751112AbdHXNfr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Aug 2017 09:35:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E82D11F56A
        for <linux-ext4@vger.kernel.org>; Thu, 24 Aug 2017 13:35:46 +0000 (UTC)
In-Reply-To: <1503581739-6385-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently some stride optimization is done in
ext2fs_allocate_group_table() by adjusting start_blk block where we
start allocating block, or inode bitmaps.

However in flex_bg case this is currently useless since the values are
going to be overridden anyway. Moreover in flex_bg case the group might
already be full and the stride optimization will fail. As a result file
system resize might fail needlessly in some situations.

It can be shown by this example:

mke2fs -b 1024 -i 1024 -E stride=8192 -t ext4 /dev/loop0 1024000
resize2fs /dev/loop0 102400000
resize2fs 1.43.5 (04-Aug-2017)
Resizing the filesystem on /dev/loop0 to 102400000 (1k) blocks.
./resize/resize2fs: Could not allocate block in ext2 filesystem while trying to resize /dev/loop0
Please run 'e2fsck -fy /dev/loop0' to fix the filesystem
after the aborted resize operation.

Fix this by not doing the stride adjustment in case of flex_bg.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 lib/ext2fs/alloc_tables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 407283f..0a36630 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -107,7 +107,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	/*
 	 * Allocate the block and inode bitmaps, if necessary
 	 */
-	if (fs->stride) {
+	if (fs->stride && !flexbg_size) {
 		retval = ext2fs_get_free_blocks2(fs, group_blk, last_blk,
 						 1, bmap, &start_blk);
 		if (retval)
-- 
2.7.5
