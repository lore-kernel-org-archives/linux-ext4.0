From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: fix build warning on Big Endian systems in closefs.c
Date: Sun,  4 Jun 2017 19:31:59 -0400
Message-ID: <20170604233159.28890-1-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42512 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751147AbdFDXcD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 4 Jun 2017 19:32:03 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/closefs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 76444c05..1d4d5b7f 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -282,7 +282,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	unsigned long	fs_state;
 	__u32		feature_incompat;
 	struct ext2_super_block *super_shadow = 0;
-	struct ext2_group_desc *group_shadow = 0;
+	struct opaque_ext2_group_desc *group_shadow = 0;
 #ifdef WORDS_BIGENDIAN
 	struct ext2_group_desc *gdp;
 	dgrp_t		j;
@@ -343,7 +343,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	}
 #else
 	super_shadow = fs->super;
-	group_shadow = ext2fs_group_desc(fs, fs->group_desc, 0);
+	group_shadow = fs->group_desc;
 #endif
 
 	/*
-- 
2.11.0.rc0.7.gbe5a750
