From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 03/15] mke2fs: simplify inode table block counting
Date: Mon, 29 Nov 2010 17:55:05 +0900
Message-ID: <1291020917-8671-4-git-send-email-namhyung@gmail.com>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42577 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0K2Izb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 03:55:31 -0500
Received: by yxt3 with SMTP id 3so1359797yxt.19
        for <linux-ext4@vger.kernel.org>; Mon, 29 Nov 2010 00:55:31 -0800 (PST)
In-Reply-To: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Simplify counting of inode table blocks in a block group using
local variable 'ipb'. Otherwise the variable could be removed
because there was no user of it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 misc/mke2fs.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0980045..9fb5d5f 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -320,11 +320,8 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
 
 		if (lazy_flag) {
 			ipb = fs->blocksize / EXT2_INODE_SIZE(fs->super);
-			num = ((((fs->super->s_inodes_per_group -
-				  ext2fs_bg_itable_unused(fs, i)) *
-				 EXT2_INODE_SIZE(fs->super)) +
-				EXT2_BLOCK_SIZE(fs->super) - 1) /
-			       EXT2_BLOCK_SIZE(fs->super));
+			num = (fs->super->s_inodes_per_group -
+			       ext2fs_bg_itable_unused(fs, i) + ipb - 1) / ipb;
 		}
 		if (!lazy_flag || itable_zeroed) {
 			/* The kernel doesn't need to zero the itable blocks */
-- 
1.7.0.4

