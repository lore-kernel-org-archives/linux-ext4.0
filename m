From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] e2fsck: detect holes in extent-mapped directories
Date: Sun, 29 Nov 2009 15:33:25 -0500
Message-ID: <1259526809-23697-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35128 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbZK2Udp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 Nov 2009 15:33:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Directories are not allowed to be sparse; the code for scanning
extent-mapped directories was not calling ext2fs_add_dir_block() for
missing directory blocks, so we weren't catching this form of file
system corruption.  Fix this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index d2021dd..a241c23 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1725,6 +1725,16 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			}
 			pb->fragmented = 1;
 		}
+		while (is_dir && ++pb->last_db_block < extent.e_lblk) {
+			pctx->errcode = ext2fs_add_dir_block(ctx->fs->dblist,
+							     pb->ino, 0,
+							     pb->last_db_block);
+			if (pctx->errcode) {
+				pctx->blk = 0;
+				pctx->num = pb->last_db_block;
+				goto failed_add_dir_block;
+			}
+		}
 		for (blk = extent.e_pblk, blockcnt = extent.e_lblk, i = 0;
 		     i < extent.e_len;
 		     blk++, blockcnt++, i++) {
@@ -1735,6 +1745,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				if (pctx->errcode) {
 					pctx->blk = blk;
 					pctx->num = blockcnt;
+				failed_add_dir_block:
 					fix_problem(ctx, PR_1_ADD_DBLOCK, pctx);
 					/* Should never get here */
 					ctx->flags |= E2F_FLAG_ABORT;
@@ -1742,6 +1753,8 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 				}
 			}
 		}
+		if (is_dir && extent.e_len > 0)
+			pb->last_db_block = blockcnt - 1;
 		pb->num_blocks += extent.e_len;
 		pb->previous_block = extent.e_pblk + extent.e_len - 1;
 		start_block = extent.e_lblk + extent.e_len - 1;
-- 
1.6.5.216.g5288a.dirty

