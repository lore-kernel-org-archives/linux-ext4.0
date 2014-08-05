From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/21] e2fsck: be more careful in assuming inline_data
 inodes are directories
Date: Mon, 04 Aug 2014 18:07:03 -0700
Message-ID: <20140805010702.2611.4375.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHEBHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:07:07 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a file is marked inline_data but its i_size isn't a multiple of
four, it probably isn't an inline directory, because directory entries
have sizes that are multiples of four.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1a9e0d5..245a755 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -536,10 +536,17 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
 			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
 	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL)) {
+		int flags;
 		size_t size;
 
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

