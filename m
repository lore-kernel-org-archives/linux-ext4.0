From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 2/6] [64-bit] write_bitmaps(): blk_t -> blk64_t
Date: Fri, 01 May 2009 04:46:31 -0400
Message-ID: <15560.1241167591@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:43079 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbZEAIqS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:46:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

write_bitmaps() was truncating blocks numbers to 32 bits and therefore
writing at the wrong place on the disk.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/rw_bitmaps.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 5b504bf..da472a8 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -36,8 +36,8 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	errcode_t	retval;
 	char 		*block_buf, *inode_buf;
 	int		csum_flag = 0;
-	blk_t		blk;
-	blk_t		blk_itr = fs->super->s_first_data_block;
+	blk64_t		blk;
+	blk64_t		blk_itr = fs->super->s_first_data_block;
 	ext2_ino_t	ino_itr = 1;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
-- 
1.6.0.6

