From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] mke2fs: avoid inode number error with large FS
Date: Mon, 12 Feb 2018 14:14:19 +0300
Message-ID: <20180212111419.25036-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55592 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754057AbeBLLOl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Feb 2018 06:14:41 -0500
Received: by mail-it0-f66.google.com with SMTP id b66so6193195itd.5
        for <linux-ext4@vger.kernel.org>; Mon, 12 Feb 2018 03:14:40 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexey Lyashkov <alexey.lyashkov@gmail.com>

Sometimes during system deployment customers are faced with system
formating problem for given inodes/bytes rate. User need to recalucate
this rate and start formating again.

This patch adds code that limit inodes count instead of error return,
to use all inodes in the filesystem.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-9501
Cray-bug-id: LUS-5250
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Signed-off-by: Alexey Lyashkov <alexey.lyashkov@gmail.com>
---
 misc/mke2fs.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index cfb10bc4..6fb0a717 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2457,14 +2457,11 @@ profile_error:
 		unsigned long long n;
 		n = ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
 		if (n > MAX_32_NUM) {
-			if (ext2fs_has_feature_64bit(&fs_param))
-				num_inodes = MAX_32_NUM;
-			else {
+			num_inodes = MAX_32_NUM;
+			if (!ext2fs_has_feature_64bit(&fs_param))
 				com_err(program_name, 0,
-					_("too many inodes (%llu), raise "
-					  "inode ratio?"), n);
-				exit(1);
-			}
+					_("too many inodes (%llu), reduced to "
+					  "%llu"), n, MAX_32_NUM);
 		}
 	} else if (num_inodes > MAX_32_NUM) {
 		com_err(program_name, 0,
-- 
2.14.3 (Apple Git-98)
