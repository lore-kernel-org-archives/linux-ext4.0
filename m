From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 43/74] libext2fs: don't update the summary counts when doing
 implied cluster allocation
Date: Tue, 10 Dec 2013 17:23:06 -0800
Message-ID: <20131211012306.30655.51172.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26957 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3LKBXO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:23:14 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're appending a block to a directory file or the journal file,
and the new block is part of a cluster that has already been allocated
to the file (implied cluster allocation), don't update the bitmap or
the summary counts because that was performed when the cluster was
allocated.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
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
index 69ac135..d09c458 100644
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

