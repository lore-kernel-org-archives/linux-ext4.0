From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/18] e2fsck: always recheck an inode checksum failure
Date: Fri, 25 Jul 2014 17:35:06 -0700
Message-ID: <20140726003506.28334.70495.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17353 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaGZAfL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:35:11 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For all inodes that fail the initial checksum verification, always
re-verify the checksum at the end of inode sanity checks to see if the
user wants to simply fix the checksum.  (Obviously, this won't happen
either if the user chose to zap/fix the inode, or specified
strict_csums to wipe anything at the first sign of trouble.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |   48 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index d09b4eb..3734645 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -653,6 +653,29 @@ static void reserve_block_for_lnf_repair(e2fsck_t ctx)
 	ctx->lnf_repair_block = blk;
 }
 
+static void finish_processing_inode(e2fsck_t ctx, ext2_ino_t ino,
+				    struct problem_context *pctx,
+				    int failed_csum)
+{
+	if (!failed_csum)
+		return;
+
+	/*
+	 * If the inode failed the checksum and the user didn't
+	 * clear the inode, test the checksum again -- if it still
+	 * fails, ask the user if the checksum should be corrected.
+	 */
+	pctx->errcode = recheck_bad_inode_checksum(ctx->fs, ino, ctx, pctx);
+	if (pctx->errcode)
+		ctx->flags |= E2F_FLAG_ABORT;
+}
+#define FINISH_INODE_LOOP(ctx, ino, pctx, failed_csum) \
+	do { \
+		finish_processing_inode((ctx), (ino), (pctx), (failed_csum)); \
+		if ((ctx)->flags & E2F_FLAG_ABORT) \
+			return; \
+	} while (0)
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -865,6 +888,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				alloc_bb_map(ctx);
 			ext2fs_mark_inode_bitmap2(ctx->inode_bb_map, ino);
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		}
 		if (pctx.errcode &&
@@ -911,6 +935,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 				inlinedata_fs = 1;
 			} else if (!fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
 				e2fsck_clear_inode(ctx, ino, inode, 0, "pass1");
+				FINISH_INODE_LOOP(ctx, ino, &pctx,
+						  failed_csum);
 				continue;
 			}
 		}
@@ -945,6 +971,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				if (ino == EXT2_BAD_INO)
 					ext2fs_mark_inode_bitmap2(ctx->inode_used_map,
 								 ino);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 		}
@@ -1033,6 +1060,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			clear_problem_context(&pctx);
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		} else if (ino == EXT2_ROOT_INO) {
 			/*
@@ -1071,6 +1099,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							   "pass1");
 				}
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 			if ((inode->i_links_count ||
@@ -1098,6 +1127,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							"pass1");
 				}
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 			if ((inode->i_links_count ||
@@ -1133,6 +1163,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 				}
 			}
 			check_blocks(ctx, &pctx, block_buf);
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		}
 
@@ -1176,6 +1207,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							   "pass1");
 				}
 			}
+			FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 			continue;
 		}
 		/*
@@ -1274,6 +1306,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			} else if (ext2fs_inode_data_blocks(fs, inode) == 0) {
 				ctx->fs_fast_symlinks_count++;
 				check_blocks(ctx, &pctx, block_buf);
+				FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 				continue;
 			}
 		}
@@ -1310,19 +1343,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else
 			check_blocks(ctx, &pctx, block_buf);
 
-		/*
-		 * If the inode failed the checksum and the user didn't
-		 * clear the inode, test the checksum again -- if it still
-		 * fails, ask the user if the checksum should be corrected.
-		 */
-		if (failed_csum) {
-			pctx.errcode = recheck_bad_inode_checksum(fs, ino, ctx,
-								  &pctx);
-			if (pctx.errcode) {
-				ctx->flags |= E2F_FLAG_ABORT;
-				return;
-			}
-		}
+		FINISH_INODE_LOOP(ctx, ino, &pctx, failed_csum);
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto endit;
@@ -1427,6 +1448,7 @@ endit:
 	if ((ctx->flags & E2F_FLAG_SIGNAL_MASK) == 0)
 		print_resource_track(ctx, _("Pass 1"), &rtrack, ctx->fs->io);
 }
+#undef FINISH_INODE_LOOP
 
 /*
  * When the inode_scan routines call this callback at the end of the

