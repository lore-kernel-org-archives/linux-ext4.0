From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/31] Define an error code for block bitmap checksum failures
Date: Mon, 30 Sep 2013 18:27:02 -0700
Message-ID: <20131001012702.28415.85146.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3JAB1H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:07 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Apparently libext2fs didn't have an error code defined for block bitmap
checksum errors, so add one.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/rw_bitmaps.c   |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index de1b05b..d100acd 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -476,4 +476,7 @@ ec	EXT2_ET_MMP_CSUM_INVALID,
 ec	EXT2_ET_FILE_EXISTS,
 	"Ext2 file already exists"
 
+ec	EXT2_ET_BLOCK_BITMAP_CSUM_INVALID,
+	"Block bitmap checksum does not match bitmap"
+
 	end
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index cc14aaf..386cbeb 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -275,7 +275,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				    !ext2fs_block_bitmap_csum_verify(fs, i,
 						block_bitmap, block_nbytes)) {
 					retval =
-					EXT2_ET_BLOCK_BITMAP_READ;
+					EXT2_ET_BLOCK_BITMAP_CSUM_INVALID;
 					goto cleanup;
 				}
 			} else

