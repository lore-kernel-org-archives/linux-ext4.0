From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/14] filefrag: fix broken extent emulation and
 uninitialized variables
Date: Wed, 13 May 2015 17:21:34 -0700
Message-ID: <20150514002134.10785.61003.stgit@birch.djwong.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934516AbbENAVi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 May 2015 20:21:38 -0400
In-Reply-To: <20150514002108.10785.85860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This started with the fm_ext being uninitialized, but upon closer
analysis I discovered that forcing extent emulation in FIBMAP mode
was reporting an extent for every block in the file.  Fix both
problems.

The Coverity bug was 1297512.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/filefrag.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/misc/filefrag.c b/misc/filefrag.c
index c1a8684..3b104c6 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -287,8 +287,8 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 	const long		bpib = st->st_blksize / 4;
 	int			count;
 
+	memset(&fm_ext, 0, sizeof(fm_ext));
 	if (force_extent) {
-		memset(&fm_ext, 0, sizeof(fm_ext));
 		fm_ext.fe_flags = FIEMAP_EXTENT_MERGED;
 	}
 
@@ -331,15 +331,17 @@ static int filefrag_fibmap(int fd, int blk_shift, int *num_extents,
 					  blk_shift, st);
 			fm_ext.fe_length = 0;
 			(*num_extents)++;
+			fm_ext.fe_logical = logical;
+			fm_ext.fe_physical = block * st->st_blksize;
 		} else if (last_block && (block != last_block + 1)) {
 			if (verbose)
 				printf("Discontinuity: Block %ld is at %lu (was "
 				       "%lu)\n", i, block, last_block + 1);
 			fm_ext.fe_length = 0;
 			(*num_extents)++;
+			fm_ext.fe_logical = logical;
+			fm_ext.fe_physical = block * st->st_blksize;
 		}
-		fm_ext.fe_logical = logical;
-		fm_ext.fe_physical = block * st->st_blksize;
 		fm_ext.fe_length += st->st_blksize;
 		last_block = block;
 	}

