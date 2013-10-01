From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 23/31] libext2fs: expanddir and mkjournal need not update the
 summary counts when performing an implied cluster allocation
Date: Mon, 30 Sep 2013 18:29:09 -0700
Message-ID: <20131001012909.28415.3283.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38071 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab3JAB3N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:29:13 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're appending a block to a directory file or the journal file, and the
new block is part of a cluster that has already been allocated to the file
(implied cluster allocation), don't update the bitmap or the summary counts
because that was performed when the cluster was allocated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/expanddir.c |    2 +-
 lib/ext2fs/mkjournal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 22558d6..09a15fa 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -55,6 +55,7 @@ static int expand_dir_proc(ext2_filsys	fs,
 			return BLOCK_ABORT;
 		}
 		es->newblocks++;
+		ext2fs_block_alloc_stats2(fs, new_blk, +1);
 	}
 	if (blockcnt > 0) {
 		retval = ext2fs_new_dir_block(fs, 0, 0, &block);
@@ -82,7 +83,6 @@ static int expand_dir_proc(ext2_filsys	fs,
 	}
 	ext2fs_free_mem(&block);
 	*blocknr = new_blk;
-	ext2fs_block_alloc_stats2(fs, new_blk, +1);
 
 	if (es->done)
 		return (BLOCK_CHANGED | BLOCK_ABORT);
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index c636a97..dd3c35b 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -250,6 +250,7 @@ static int mkjournal_proc(ext2_filsys	fs,
 			es->err = retval;
 			return BLOCK_ABORT;
 		}
+		ext2fs_block_alloc_stats2(fs, new_blk, +1);
 		es->newblocks++;
 	}
 	if (blockcnt >= 0)
@@ -285,7 +286,6 @@ static int mkjournal_proc(ext2_filsys	fs,
 		return BLOCK_ABORT;
 	}
 	*blocknr = es->goal = new_blk;
-	ext2fs_block_alloc_stats2(fs, new_blk, +1);
 
 	if (es->num_blocks == 0)
 		return (BLOCK_CHANGED | BLOCK_ABORT);

