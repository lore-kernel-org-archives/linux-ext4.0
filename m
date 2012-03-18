From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/5] e2fsck: add support for field widths in messages using %-expansion
Date: Sun, 18 Mar 2012 15:52:44 -0400
Message-ID: <1332100368-2683-2-git-send-email-tytso@mit.edu>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40342 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756150Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
In-Reply-To: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This will come in handy when printing checksums, some of which are
32-bit and some of which are 16-bit.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/message.c |   60 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 4dab1a4..1a91044 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -397,7 +397,7 @@ static _INLINE_ void expand_dirent_expression(ext2_filsys fs, char ch,
 }
 
 static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
-					       int *first,
+					       int width, int *first,
 					       struct problem_context *ctx)
 {
 	e2fsck_t e2fsck_ctx = fs ? (e2fsck_t) fs->priv_data : NULL;
@@ -412,9 +412,9 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 		break;
 	case 'b':
 #ifdef EXT2_NO_64_TYPE
-		printf("%u", (unsigned long) ctx->blk);
+		printf("%*u", width, (unsigned long) ctx->blk);
 #else
-		printf("%llu", (unsigned long long) ctx->blk);
+		printf("%*llu", width, (unsigned long long) ctx->blk);
 #endif
 		break;
 	case 'B':
@@ -441,31 +441,31 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 		break;
 	case 'c':
 #ifdef EXT2_NO_64_TYPE
-		printf("%u", (unsigned long) ctx->blk2);
+		printf("%*u", width, (unsigned long) ctx->blk2);
 #else
-		printf("%llu", (unsigned long long) ctx->blk2);
+		printf("%*llu", width, (unsigned long long) ctx->blk2);
 #endif
 		break;
 	case 'd':
-		printf("%u", ctx->dir);
+		printf("%*u", width, ctx->dir);
 		break;
 	case 'g':
-		printf("%d", ctx->group);
+		printf("%*d", width, ctx->group);
 		break;
 	case 'i':
-		printf("%u", ctx->ino);
+		printf("%*u", width, ctx->ino);
 		break;
 	case 'j':
-		printf("%u", ctx->ino2);
+		printf("%*u", width, ctx->ino2);
 		break;
 	case 'm':
-		printf("%s", error_message(ctx->errcode));
+		printf("%*s", width, error_message(ctx->errcode));
 		break;
 	case 'N':
 #ifdef EXT2_NO_64_TYPE
-		printf("%u", ctx->num);
+		printf("%*u", width, ctx->num);
 #else
-		printf("%llu", (long long)ctx->num);
+		printf("%*llu", width, (long long)ctx->num);
 #endif
 		break;
 	case 'p':
@@ -483,16 +483,16 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 		break;
 	case 'r':
 #ifdef EXT2_NO_64_TYPE
-		printf("%d", ctx->blkcount);
+		printf("%*d", width, ctx->blkcount);
 #else
-		printf("%lld", (long long) ctx->blkcount);
+		printf("%*lld", width, (long long) ctx->blkcount);
 #endif
 		break;
 	case 'S':
 		printf("%u", get_backup_sb(NULL, fs, NULL, NULL));
 		break;
 	case 's':
-		printf("%s", ctx->str ? ctx->str : "NULL");
+		printf("%*s", width, ctx->str ? ctx->str : "NULL");
 		break;
 	case 't':
 		print_time((time_t) ctx->num);
@@ -502,9 +502,9 @@ static _INLINE_ void expand_percent_expression(ext2_filsys fs, char ch,
 		break;
 	case 'X':
 #ifdef EXT2_NO_64_TYPE
-		printf("0x%x", ctx->num);
+		printf("0x%*x", width, ctx->num);
 #else
-		printf("0x%llx", (long long)ctx->num);
+		printf("0x%*llx", width, (long long)ctx->num);
 #endif
 		break;
 	default:
@@ -520,22 +520,30 @@ void print_e2fsck_message(e2fsck_t ctx, const char *msg,
 {
 	ext2_filsys fs = ctx->fs;
 	const char *	cp;
-	int		i;
+	int		i, width;
 
 	e2fsck_clear_progbar(ctx);
 	for (cp = msg; *cp; cp++) {
 		if (cp[0] == '@') {
 			cp++;
 			expand_at_expression(ctx, *cp, pctx, &first, recurse);
-		} else if (cp[0] == '%' && cp[1] == 'I') {
-			cp += 2;
-			expand_inode_expression(fs, *cp, pctx);
-		} else if (cp[0] == '%' && cp[1] == 'D') {
-			cp += 2;
-			expand_dirent_expression(fs, *cp, pctx);
-		} else if ((cp[0] == '%')) {
+		} else if (cp[0] == '%') {
 			cp++;
-			expand_percent_expression(fs, *cp, &first, pctx);
+			width = 0;
+			while (isdigit(cp[0])) {
+				width = (width * 10) + cp[0] - '0';
+				cp++;
+			}
+			if (cp[0] == 'I') {
+				cp++;
+				expand_inode_expression(fs, *cp, pctx);
+			} else if (cp[0] == 'D') {
+				cp++;
+				expand_dirent_expression(fs, *cp, pctx);
+			} else {
+				expand_percent_expression(fs, *cp, width,
+							  &first, pctx);
+			}
 		} else {
 			for (i=0; cp[i]; i++)
 				if ((cp[i] == '@') || cp[i] == '%')
-- 
1.7.9.107.g97f9a

