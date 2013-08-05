From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] libext2fs: fix a coding style for EXT2_NO_MTAB_FILE
Date: Mon,  5 Aug 2013 13:02:43 +0800
Message-ID: <1375678963-7845-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45747 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3HEFCl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Aug 2013 01:02:41 -0400
Received: by mail-pd0-f171.google.com with SMTP id bv13so2755095pdb.30
        for <linux-ext4@vger.kernel.org>; Sun, 04 Aug 2013 22:02:41 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

When we define an error in lib/ext2fs/ext2_err.et.in, we will always use
EXT2_ET_* prefix for a new error.  But EXT2_NO_MTAB_FILE doesn't obey
this rule.  So fix it.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/ext2_err.et.in |    2 +-
 lib/ext2fs/ismounted.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index d20c6b7..de1b05b 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -416,7 +416,7 @@ ec	EXT2_ET_EXTENT_INVALID_LENGTH,
 ec	EXT2_ET_IO_CHANNEL_NO_SUPPORT_64,
 	"I/O Channel does not support 64-bit block numbers"
 
-ec	EXT2_NO_MTAB_FILE,
+ec	EXT2_ET_NO_MTAB_FILE,
 	"Can't check if filesystem is mounted due to missing mtab file"
 
 ec	EXT2_ET_CANT_USE_LEGACY_BITMAPS,
diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index 6a223df..3fe5c76 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -54,7 +54,7 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 
 	*mount_flags = 0;
 	if ((f = setmntent (mtab_file, "r")) == NULL)
-		return (errno == ENOENT ? EXT2_NO_MTAB_FILE : errno);
+		return (errno == ENOENT ? EXT2_ET_NO_MTAB_FILE : errno);
 	if (stat(file, &st_buf) == 0) {
 		if (S_ISBLK(st_buf.st_mode)) {
 #ifndef __GNU__ /* The GNU hurd is broken with respect to stat devices */
-- 
1.7.9.7

