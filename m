From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/19] e2fsck: never free critical metadata blocks in the
 block found map
Date: Fri, 01 Aug 2014 11:11:53 -0700
Message-ID: <20140801181153.12496.71297.stgit@birch.djwong.org>
References: <20140801181139.12496.14390.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32887 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHASL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 14:11:58 -0400
In-Reply-To: <20140801181139.12496.14390.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't allow critical metadata blocks to be marked free in the block
found map.  This can theoretically happen on an FS where a first
inode's ETB/indirect map block is in the inode table, the first inode
is itself unclonable (and thus gets deleted) and there are enough
crosslinked files before and after the first inode to use up all the
free blocks during pass 1b.

(I do actually have a test FS image but it's 256M and it proved very
difficult to craft a bite-sized test case that actually hit this bug.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 26fe60c..e7a6acd 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3356,6 +3356,13 @@ static void e2fsck_block_alloc_stats(ext2_filsys fs, blk64_t blk, int inuse)
 {
 	e2fsck_t ctx = (e2fsck_t) fs->priv_data;
 
+	/* Never free a critical metadata block */
+	if (ctx->block_found_map &&
+	    ctx->block_metadata_map &&
+	    inuse < 0 &&
+	    ext2fs_test_block_bitmap2(ctx->block_metadata_map, blk))
+		return;
+
 	if (ctx->block_found_map) {
 		if (inuse > 0)
 			ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);

