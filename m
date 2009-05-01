From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 5/6] [64-bit] (blk_t) cast in ext2fs_new_block2()
Date: Fri, 01 May 2009 04:47:17 -0400
Message-ID: <15586.1241167637@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:55949
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbZEAIrE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:47:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Found by code inspection after similar gratuitous cast in
ext2fs_get_free_blocks2() (first patch in this series).

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 9f11673..a7c8860 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -170,7 +170,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 					   (i - fs->super->s_first_data_block) /
 					   EXT2_BLOCKS_PER_GROUP(fs->super));
 
-		if (!ext2fs_fast_test_block_bitmap2(map, (blk_t) i)) {
+		if (!ext2fs_fast_test_block_bitmap2(map, i)) {
 			*ret = i;
 			return 0;
 		}
-- 
1.6.0.6

