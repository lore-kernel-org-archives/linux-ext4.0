From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/5] e2fsck: print the current and expected block group checksums
Date: Sun, 18 Mar 2012 15:52:45 -0400
Message-ID: <1332100368-2683-3-git-send-email-tytso@mit.edu>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40346 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
In-Reply-To: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/message.c                  |   10 ++++++++--
 e2fsck/problem.c                  |    2 +-
 e2fsck/problem.h                  |    1 +
 e2fsck/super.c                    |    2 ++
 tests/f_illitable_flexbg/expect.1 |    2 +-
 tests/f_unused_itable/expect.1    |    4 ++--
 6 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 1a91044..6274824 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -500,13 +500,19 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 	case 'T':
 		print_time(e2fsck_ctx ? e2fsck_ctx->now : time(0));
 		break;
+	case 'x':
+		printf("0x%0*x", width, ctx->csum1);
+		break;
 	case 'X':
 #ifdef EXT2_NO_64_TYPE
-		printf("0x%*x", width, ctx->num);
+		printf("0x%0*x", width, ctx->num);
 #else
-		printf("0x%*llx", width, (long long)ctx->num);
+		printf("0x%0*llx", width, (long long)ctx->num);
 #endif
 		break;
+	case 'y':
+		printf("0x%0*x", width, ctx->csum2);
+		break;
 	default:
 	no_context:
 		printf("%%%c", ch);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c66c6be..53e8e11 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -354,7 +354,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* group descriptor N checksum is invalid. */
 	{ PR_0_GDT_CSUM,
-	  N_("@g descriptor %g checksum is invalid.  "),
+	  N_("@g descriptor %g checksum is %04x, should be %04y.  "),
 	     PROMPT_FIX, PR_LATCH_BG_CHECKSUM },
 
 	/* group descriptor N marked uninitialized without feature set. */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f2bd414..5c1579d 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -19,6 +19,7 @@ struct problem_context {
 	blk64_t	blk, blk2;
 	e2_blkcnt_t	blkcount;
 	int		group;
+	__u32		csum1, csum2;
 	__u64	num;
 	const char *str;
 };
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 3397d77..6c18d0e 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -635,6 +635,8 @@ void check_super_block(e2fsck_t ctx)
 
 		should_be = 0;
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
+			pctx.csum1 = ext2fs_bg_checksum(fs, i);
+			pctx.csum2 = ext2fs_group_desc_csum(fs, i);
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
 				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
diff --git a/tests/f_illitable_flexbg/expect.1 b/tests/f_illitable_flexbg/expect.1
index af30bd4..2d54728 100644
--- a/tests/f_illitable_flexbg/expect.1
+++ b/tests/f_illitable_flexbg/expect.1
@@ -8,7 +8,7 @@ Relocating group 1's inode table to 142...
 Restarting e2fsck from the beginning...
 One or more block group descriptor checksums are invalid.  Fix? yes
 
-Group descriptor 1 checksum is invalid.  FIXED.
+Group descriptor 1 checksum is 0x1cee, should be 0xf809.  FIXED.
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
diff --git a/tests/f_unused_itable/expect.1 b/tests/f_unused_itable/expect.1
index 08a9700..a4da987 100644
--- a/tests/f_unused_itable/expect.1
+++ b/tests/f_unused_itable/expect.1
@@ -9,8 +9,8 @@ Fix? yes
 Restarting e2fsck from the beginning...
 One or more block group descriptor checksums are invalid.  Fix? yes
 
-Group descriptor 0 checksum is invalid.  FIXED.
-Group descriptor 1 checksum is invalid.  FIXED.
+Group descriptor 0 checksum is 0x289d, should be 0x788a.  FIXED.
+Group descriptor 1 checksum is 0xfaab, should be 0x3a9a.  FIXED.
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
-- 
1.7.9.107.g97f9a

