From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 3/6] [64-bit] mke2fs 64-bit miscellaneous fixes.
Date: Fri, 01 May 2009 04:46:41 -0400
Message-ID: <15569.1241167601@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, Theodore Ts'o <tytso@mit.edu>,
	Valerie Aurora <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:57324 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610AbZEAIqj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 May 2009 04:46:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the code that was supposed to zero the last 16 blocks of the
volume: in the case of volumes larger than 2^32 blocks, various
conversions were conspiring to produce a range other than the intended
one.

Fix show_stats() for block numbers >= 2^32: blk_t -> blk64_t and printf
format.

Change int_log{2,10}() to take 64-bit arguments. Also change the int_log10()
implementation in progress.c in the same way.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/progress.c |    2 +-
 misc/mke2fs.c         |   14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/progress.c b/lib/ext2fs/progress.c
index ff298d6..c8ee70c 100644
--- a/lib/ext2fs/progress.c
+++ b/lib/ext2fs/progress.c
@@ -13,7 +13,7 @@
 #include "ext2fs.h"
 #include "ext2fsP.h"
 
-static int int_log10(unsigned int arg)
+static int int_log10(unsigned long long int arg)
 {
 	int	l;
 
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9c3f736..1f52b72 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -116,7 +116,7 @@ static void usage(void)
 	exit(1);
 }
 
-static int int_log2(int arg)
+static int int_log2(unsigned long long arg)
 {
 	int	l = 0;
 
@@ -128,7 +128,7 @@ static int int_log2(int arg)
 	return l;
 }
 
-static int int_log10(unsigned int arg)
+static int int_log10(unsigned long long arg)
 {
 	int	l;
 
@@ -546,7 +546,7 @@ static void show_stats(ext2_filsys fs)
 	struct ext2_super_block *s = fs->super;
 	char 			buf[80];
         char                    *os;
-	blk_t			group_block;
+	blk64_t			group_block;
 	dgrp_t			i;
 	int			need, col_left;
 
@@ -604,7 +604,7 @@ static void show_stats(ext2_filsys fs)
 			col_left = 72;
 		}
 		col_left -= need;
-		printf("%u", group_block);
+		printf("%llu", group_block);
 	}
 	printf("\n\n");
 }
@@ -1999,9 +1999,9 @@ int main (int argc, char *argv[])
 		fs->flags &= ~(EXT2_FLAG_IB_DIRTY|EXT2_FLAG_BB_DIRTY);
 	} else {
 		/* rsv must be a power of two (64kB is MD RAID sb alignment) */
-		unsigned int rsv = 65536 / fs->blocksize;
-		unsigned long long blocks = ext2fs_blocks_count(fs->super);
-		unsigned long start;
+		blk64_t rsv = 65536 / fs->blocksize;
+		blk64_t blocks = ext2fs_blocks_count(fs->super);
+		blk64_t start;
 		blk64_t ret_blk;
 
 #ifdef ZAP_BOOTBLOCK
-- 
1.6.0.6

