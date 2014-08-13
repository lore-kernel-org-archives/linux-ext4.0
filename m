From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] filefrag: fix extent count calculation when using FIBMAP
Date: Wed, 13 Aug 2014 16:03:44 -0400
Message-ID: <1407960224-987-1-git-send-email-tytso@mit.edu>
Cc: 1356496@bugs.launchpad.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58939 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaHMUDv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Aug 2014 16:03:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The extent count calculation works correctly with the FIBMAP ioctl in
verbose (-v) mode, but without the verbose option, the calculation was
broken because we weren't properly updating the fm_ext data structures
in non-verbose mode.

Addresses-Launchpad-Bug: #1356496

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/filefrag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index d71bf43..c1a8684 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -329,16 +329,17 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 			print_extent_info(&fm_ext, *num_extents - 1,
 					  (last_block + 1) * st->st_blksize,
 					  blk_shift, st);
-			fm_ext.fe_logical = logical;
-			fm_ext.fe_physical = block * st->st_blksize;
 			fm_ext.fe_length = 0;
 			(*num_extents)++;
 		} else if (last_block && (block != last_block + 1)) {
 			if (verbose)
 				printf("Discontinuity: Block %ld is at %lu (was "
 				       "%lu)\n", i, block, last_block + 1);
+			fm_ext.fe_length = 0;
 			(*num_extents)++;
 		}
+		fm_ext.fe_logical = logical;
+		fm_ext.fe_physical = block * st->st_blksize;
 		fm_ext.fe_length += st->st_blksize;
 		last_block = block;
 	}
-- 
2.0.0

