From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 16/18] e2fsck: leave room for checksum structure when
 salvaging a directory
Date: Fri, 25 Jul 2014 17:35:18 -0700
Message-ID: <20140726003518.28334.33196.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17392 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaGZAfX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:35:23 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're salvaging a directory, leave room at the end of the block
for the checksum entry so that e2fsck can write the checksummed dir
block out later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 9394a29..925d1a2 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -665,7 +665,8 @@ clear_and_exit:
 static void salvage_directory(ext2_filsys fs,
 			      struct ext2_dir_entry *dirent,
 			      struct ext2_dir_entry *prev,
-			      unsigned int *offset)
+			      unsigned int *offset,
+			      unsigned int block_len)
 {
 	char	*cp = (char *) dirent;
 	int left;
@@ -673,7 +674,7 @@ static void salvage_directory(ext2_filsys fs,
 	unsigned int name_len = ext2fs_dirent_name_len(dirent);
 
 	(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
-	left = fs->blocksize - *offset - rec_len;
+	left = block_len - *offset - rec_len;
 
 	/*
 	 * Special case of directory entry of size 8: copy what's left
@@ -703,7 +704,7 @@ static void salvage_directory(ext2_filsys fs,
 	 * previous directory entry absorb the invalid one.
 	 */
 	if (prev && rec_len && (rec_len % 4) == 0 &&
-	    (*offset + rec_len <= fs->blocksize)) {
+	    (*offset + rec_len <= block_len)) {
 		(void) ext2fs_get_rec_len(fs, prev, &prev_rec_len);
 		prev_rec_len += rec_len;
 		(void) ext2fs_set_rec_len(fs, prev_rec_len, prev);
@@ -718,11 +719,11 @@ static void salvage_directory(ext2_filsys fs,
 	 */
 	if (prev) {
 		(void) ext2fs_get_rec_len(fs, prev, &prev_rec_len);
-		prev_rec_len += fs->blocksize - *offset;
+		prev_rec_len += block_len - *offset;
 		(void) ext2fs_set_rec_len(fs, prev_rec_len, prev);
 		*offset = fs->blocksize;
 	} else {
-		rec_len = fs->blocksize - *offset;
+		rec_len = block_len - *offset;
 		(void) ext2fs_set_rec_len(fs, rec_len, dirent);
 		ext2fs_dirent_set_name_len(dirent, 0);
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
@@ -995,8 +996,12 @@ skip_checksum:
 			    (rec_len < 12) ||
 			    ((rec_len % 4) != 0) ||
 			    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
-				if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
-					salvage_directory(fs, dirent, prev, &offset);
+				if (fix_problem(ctx, PR_2_DIR_CORRUPTED,
+						&cd->pctx)) {
+					salvage_directory(fs, dirent, prev,
+							  &offset,
+							  fs->blocksize -
+							  de_csum_size);
 					dir_modified++;
 					continue;
 				} else

