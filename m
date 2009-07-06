From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [PATCH 2/3] e2fsck: Fix loop counter properly
Date: Mon, 06 Jul 2009 17:15:24 +0900
Message-ID: <4A51B29C.6020703@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58518 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbZGFITc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jul 2009 04:19:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If unused range of the bitmap has an unmarked bit, check_[inode/block]_end()
marks all bits in the range. However, we know that the checked bits are marked.
So this patch fixes loop counter to mark from the unmarked bit.

Regards,
Kazuya Mio

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 pass5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index e660386..8154e1e 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -567,7 +567,7 @@ static void check_inode_end(e2fsck_t ctx)
 	for (i = save_inodes_count + 1; i <= end && i > save_inodes_count; i++) {
 		if (!ext2fs_test_inode_bitmap(fs->inode_map, i)) {
 			if (fix_problem(ctx, PR_5_INODE_BMAP_PADDING, &pctx)) {
-				for (i = save_inodes_count + 1; i <= end; i++)
+				for (; i <= end; i++)
 					ext2fs_mark_inode_bitmap(fs->inode_map,
 								 i);
 				ext2fs_mark_ib_dirty(fs);
@@ -612,7 +612,7 @@ static void check_block_end(e2fsck_t ctx)
 	for (i = save_blocks_count + 1; i <= end && i > save_blocks_count; i++) {
 		if (!ext2fs_test_block_bitmap(fs->block_map, i)) {
 			if (fix_problem(ctx, PR_5_BLOCK_BMAP_PADDING, &pctx)) {
-				for (i = save_blocks_count + 1; i <= end; i++)
+				for (; i <= end; i++)
 					ext2fs_mark_block_bitmap(fs->block_map,
 								 i);
 				ext2fs_mark_bb_dirty(fs);
