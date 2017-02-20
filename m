From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] libext2fs: readahead for meta_bg
Date: Mon, 20 Feb 2017 13:03:45 +0300
Message-ID: <1487585025-16654-1-git-send-email-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca, alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34719 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752589AbdBTKdC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Feb 2017 05:33:02 -0500
Received: by mail-pf0-f195.google.com with SMTP id o64so8768023pfb.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Feb 2017 02:33:02 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@seagate.com>

There are ~37k of random IOs with meta_bg option on 300T target.
Debugfs requires 20 minutes to be started. Enabling readahead for
group blocks metadata save time dramatically. Only 12s to start.

Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
---
 lib/ext2fs/openfs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index ba501e6..f158b0a 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -399,6 +399,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 #endif
 		dest += fs->blocksize*first_meta_bg;
 	}
+
+	for (i = first_meta_bg ; i < fs->desc_blocks; i++) {
+		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
+		io_channel_cache_readahead(fs->io, blk, 1);
+	}
+
 	for (i=first_meta_bg ; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
 		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
-- 
1.7.1
