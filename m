From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 6/6][64-bit] __u32 -> __u64 in ba_resize_bmap() and  blk_t -> blk64_t  in ext2fs_check_desc()
Date: Fri, 01 May 2009 04:47:26 -0400
Message-ID: <15592.1241167646@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:55949
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbZEAIrM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:47:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Both of these were found by code inspection while chasing the
ext2fs_get_free_blocks2() problem. I have not seen a problem arising
from them, but they look like bugs to me.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/blkmap64_ba.c |    2 +-
 lib/ext2fs/check_desc.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index f7f7097..b9e0e90 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -124,7 +124,7 @@ static errcode_t ba_resize_bmap(ext2fs_generic_bitmap64 bmap,
 	ext2fs_ba_private bp = (ext2fs_ba_private) bmap->private;
 	errcode_t	retval;
 	size_t		size, new_size;
-	__u32		bitno;
+	__u64		bitno;
 
 	/*
 	 * If we're expanding the bitmap, make sure all of the new
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 6a969e0..e812c9f 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -36,7 +36,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 	dgrp_t i;
 	blk64_t first_block = fs->super->s_first_data_block;
 	blk64_t last_block = ext2fs_blocks_count(fs->super)-1;
-	blk_t blk, b;
+	blk64_t blk, b;
 	int j;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
-- 
1.6.0.6

