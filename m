From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/27] e2fsck: on BE,
 re-swap everything after a damaged dirent so salvage works correctly
Date: Sat, 16 Aug 2014 16:46:23 -0700
Message-ID: <20140816234623.11171.70133.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43391 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaHPXq1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:27 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On big-endian systems, if the dirent swap routine finds a rec_len that
it doesn't like, it continues processing the block as if rec_len == 8.
This means that the name field gets byte swapped, which means that
salvage will not detect the correct name length (unless the name has a
length that's an exact multiple of four bytes), and it'll discard the
entry (unnecessarily) and the rest of the dirent block.  Therefore,
swap the rest of the block back to disk order, run salvage, and
re-swap anything after the salvaged dirent.

The test case for this is f_inlinedata_repair if you run it on a BE
system.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 23310f1..0b9c5c5 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1058,9 +1058,47 @@ skip_checksum:
 			    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
 				if (fix_problem(ctx, PR_2_DIR_CORRUPTED,
 						&cd->pctx)) {
+#ifdef WORDS_BIGENDIAN
+					/*
+					 * On big-endian systems, if the dirent
+					 * swap routine finds a rec_len that it
+					 * doesn't like, it continues
+					 * processing the block as if rec_len
+					 * == 8.  This means that the name
+					 * field gets byte swapped, which means
+					 * that salvage will not detect the
+					 * correct name length (unless the name
+					 * has a length that's an exact
+					 * multiple of four bytes), and it'll
+					 * discard the entry (unnecessarily)
+					 * and the rest of the dirent block.
+					 * Therefore, swap the rest of the
+					 * block back to disk order, run
+					 * salvage, and re-swap anything after
+					 * the salvaged dirent.
+					 */
+					int need_reswab = 0;
+					if (rec_len < 8 || rec_len % 4) {
+						need_reswab = 1;
+						ext2fs_dirent_swab_in2(fs,
+							((char *)dirent) + 8,
+							max_block_size - offset - 8,
+							0);
+					}
+#endif
 					salvage_directory(fs, dirent, prev,
 							  &offset,
 							  max_block_size);
+#ifdef WORDS_BIGENDIAN
+					if (need_reswab) {
+						(void) ext2fs_get_rec_len(fs,
+							dirent, &rec_len);
+						ext2fs_dirent_swab_in2(fs,
+							((char *)dirent) + offset + rec_len,
+							max_block_size - offset - rec_len,
+							0);
+					}
+#endif
 					dir_modified++;
 					continue;
 				} else

