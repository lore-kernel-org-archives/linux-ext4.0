From: Rakesh Pandit <rakesh@tuxera.com>
Subject: [PATCH] filefrag: fix -B option and extents calculation for FIBMAP
Date: Thu, 24 Jul 2014 13:05:40 +0300
Message-ID: <20140724100539.GA8061@hercules.tuxera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from nbl-ex10-fe01.nebula.fi ([188.117.32.121]:51021 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932901AbaGXKLL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 06:11:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

29758d2 broke -B option which is useful for filesystems not supporting
FIEMAP. Also, fix extents calculation for -B which is broken since
2508eaa7.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 misc/filefrag.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 820821b..bb060b6 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -331,9 +331,10 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 			fm_ext.fe_physical = block * st->st_blksize;
 			fm_ext.fe_length = 0;
 			(*num_extents)++;
-		} else if (verbose && last_block && (block != last_block + 1)) {
-			printf("Discontinuity: Block %ld is at %lu (was %lu)\n",
-			       i, block, last_block + 1);
+		} else if (last_block && (block != last_block + 1)) {
+			if (verbose)
+				printf("Discontinuity: Block %ld is at %lu (was "
+				       "%lu)\n", i, block, last_block + 1);
 			(*num_extents)++;
 		}
 		fm_ext.fe_length += st->st_blksize;
@@ -439,7 +440,7 @@ static int frag_report(const char *filename)
 		expected = 0;
 	}
 
-	if (rc < 0) {
+	if (force_bmap || rc < 0) {
 		expected = filefrag_fibmap(fd, blk_shift, &num_extents,
 					   &st, numblocks, is_ext2);
 		if (expected < 0) {
-- 
1.9.3

