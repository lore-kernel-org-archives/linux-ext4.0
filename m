From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 19/21] e2fsck: be more careful in assuming inline_data
 inodes are directories
Date: Fri, 8 Aug 2014 09:22:58 -0700
Message-ID: <20140808162258.GA11191@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
 <20140805010702.2611.4375.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44803 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbaHHQXD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 12:23:03 -0400
Content-Disposition: inline
In-Reply-To: <20140805010702.2611.4375.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a file is marked inline_data but its i_size isn't a multiple of
four, it probably isn't an inline directory, because directory entries
have sizes that are multiples of four.

v2: Don't add unnecessary variables.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ce373f3..8cff18d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -540,6 +540,12 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 
 		if (ext2fs_inline_data_size(ctx->fs, pctx->ino, &size))
 			return;
+		/*
+		 * If the size isn't a multiple of 4, it's probably not a
+		 * directory??
+		 */
+		if (size & 3)
+			return;
 		/* device files never have a "system.data" entry */
 		goto isdir;
 	} else if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) {
