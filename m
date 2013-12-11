From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 64/74] Subject: [PATCH] fuse2fs: support allocating uninit
 blocks in fallocate
Date: Tue, 10 Dec 2013 17:25:25 -0800
Message-ID: <20131211012525.30655.65703.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43903 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3LKBZb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:25:31 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new ext2fs_bmap2 flag to allocate uninitialized extents
when doing fallocate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/fuse2fs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 317032c..105c54f 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -2798,8 +2798,8 @@ static int fallocate_helper(struct fuse_file_info *fp, int mode, off_t offset,
 	/* Allocate a bunch of blocks */
 	end = (offset + len - 1) / fs->blocksize;
 	for (blk = offset / fs->blocksize; blk <= end; blk++) {
-		err = ext2fs_bmap2(fs, fh->ino, NULL, NULL, BMAP_ALLOC, blk,
-				   0, &x);
+		err = ext2fs_bmap2(fs, fh->ino, NULL, NULL,
+				   BMAP_ALLOC | BMAP_UNINIT, blk, 0, &x);
 		if (err)
 			return translate_error(fs, fh->ino, err);
 	}
@@ -3164,6 +3164,9 @@ static int __translate_error(ext2_filsys fs, errcode_t err, ext2_ino_t ino,
 	case EXT2_ET_EA_KEY_NOT_FOUND:
 		ret = -ENODATA;
 		break;
+	case EXT2_ET_UNIMPLEMENTED:
+		ret = -EOPNOTSUPP;
+		break;
 	default:
 		is_err = 1;
 		ret = -EIO;

