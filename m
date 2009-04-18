From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 1/2][64-BIT] blk_t -> blk64_t in read_bitmaps().
Date: Sat, 18 Apr 2009 02:05:04 -0400
Message-ID: <30393.1240034704@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:45408
	"EHLO QMTA13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbZDRGKk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 02:10:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck -n -f on a brand-new, never-mounted 32TiB filesystem was
detecting a lot of "Block bitmap differences". This change makes them
go away (there are are still more problems however: the run finds used
blocks in one BLOCK_UNINIT group and a free block mismatch.)

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/rw_bitmaps.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index cee6142..5b504bf 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -144,9 +144,9 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	int csum_flag = 0;
 	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
 	unsigned int	cnt;
-	blk_t	blk;
-	blk_t	blk_itr = fs->super->s_first_data_block;
-	blk_t   blk_cnt;
+	blk64_t	blk;
+	blk64_t	blk_itr = fs->super->s_first_data_block;
+	blk64_t   blk_cnt;
 	ext2_ino_t ino_itr = 1;
 	ext2_ino_t ino_cnt;
 
-- 
1.6.0.6

