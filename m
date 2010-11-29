From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 05/15] libext2fs: fix dubious code in ext2fs_unmark_generic_bitmap()
Date: Mon, 29 Nov 2010 17:55:07 +0900
Message-ID: <1291020917-8671-6-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51817 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0K2Izf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:35 -0500
Received: by mail-gw0-f46.google.com with SMTP id 20so1866691gwj.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:34 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks like a copy & paste problem to me.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 lib/ext2fs/gen_bitmap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index eded435..3650013 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -217,7 +217,7 @@ int ext2fs_unmark_generic_bitmap(ext2fs_generic_bitmap bitmap,
 	if (!EXT2FS_IS_32_BITMAP(bitmap)) {
 		if (EXT2FS_IS_64_BITMAP(bitmap)) {
 			ext2fs_warn_bitmap32(bitmap, __func__);
-			return ext2fs_mark_generic_bmap(bitmap, bitno);
+			return ext2fs_unmark_generic_bmap(bitmap, bitno);
 		}
 #ifndef OMIT_COM_ERR
 		com_err(0, EXT2_ET_MAGIC_GENERIC_BITMAP,
-- 
1.7.0.4

