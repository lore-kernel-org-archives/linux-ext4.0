From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/21] e2fsck: use the correct block size when salvaging
 directories
Date: Mon, 04 Aug 2014 18:06:49 -0700
Message-ID: <20140805010649.2611.15991.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40458 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaHEBGy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:54 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that the directory salvaging operation is fed the block size,
teach pass 2 that it should use the size of the inline data if the
directory is inline_data.  Without this, it'll "fix" inline
directories by setting the rec_len to something approaching the FS
blocksize, which is clearly wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index d56b4c8..abf95bd 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -979,11 +979,17 @@ skip_checksum:
 
 		problem = 0;
 		if (!inline_data_size || dot_state > 1) {
+			size_t max_block_size = fs->blocksize - de_csum_size;
+
+			if (inline_data_size)
+				max_block_size = inline_data_size;
 			dirent = (struct ext2_dir_entry *) (buf + offset);
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 			cd->pctx.dirent = dirent;
 			cd->pctx.num = offset;
 			if (((offset + rec_len) > fs->blocksize) ||
+			    (inline_data_size > 0 &&
+			     (offset + rec_len) > inline_data_size) ||
 			    (rec_len < 12) ||
 			    ((rec_len % 4) != 0) ||
 			    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
@@ -991,8 +997,7 @@ skip_checksum:
 						&cd->pctx)) {
 					salvage_directory(fs, dirent, prev,
 							  &offset,
-							  fs->blocksize -
-							  de_csum_size);
+							  max_block_size);
 					dir_modified++;
 					continue;
 				} else

