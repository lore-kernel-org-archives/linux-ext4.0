From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: fix potential buffer overflow in closefs()
Date: Sat, 14 Feb 2015 19:51:37 -0500
Message-ID: <1423961497-9715-1-git-send-email-tytso@mit.edu>
Cc: nnk@google.com, keescook@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47092 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbbBOAwI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 14 Feb 2015 19:52:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The bug fix in f66e6ce4446: "libext2fs: avoid buffer overflow if
s_first_meta_bg is too big" had a typo in the fix for
ext2fs_closefs().  In practice most of the security exposure was from
the openfs path, since this meant if there was a carefully crafted
file system, buffer overrun would be triggered when the file system was
opened.

However, if corrupted file system didn't trip over some corruption
check, and then the file system was modified via tune2fs or debugfs,
such that the superblock was marked dirty and then written out via the
closefs() path, it's possible that the buffer overrun could be
triggered when the file system is closed.

Also clear up a signed vs unsigned warning while we're at it.

Thanks to Nick Kralevich <nnk@google.com> for asking me to look at
compiler warning in the code in question, which led me to notice the
bug in f66e6ce4446.

Addresses: CVE-2015-1572

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/closefs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 1f99113..ab5b2fb 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -287,7 +287,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	dgrp_t		j;
 #endif
 	char	*group_ptr;
-	int	old_desc_blocks;
+	blk64_t	old_desc_blocks;
 	struct ext2fs_numeric_progress_struct progress;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
@@ -346,7 +346,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	group_ptr = (char *) group_shadow;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
 		old_desc_blocks = fs->super->s_first_meta_bg;
-		if (old_desc_blocks > fs->super->s_first_meta_bg)
+		if (old_desc_blocks > fs->desc_blocks)
 			old_desc_blocks = fs->desc_blocks;
 	} else
 		old_desc_blocks = fs->desc_blocks;
-- 
2.1.0

