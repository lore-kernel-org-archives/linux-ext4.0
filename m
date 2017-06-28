From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] e2fsck: remove #ifdef EXT2_NO_64_TYPE blocks
Date: Tue, 27 Jun 2017 18:22:40 -0700
Message-ID: <20170628012240.9141-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33245 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbdF1BWp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jun 2017 21:22:45 -0400
Received: by mail-pg0-f42.google.com with SMTP id f127so23750848pgc.0
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jun 2017 18:22:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT2_NO_64_TYPE is not defined anywhere. It appears to be a
historical artifact.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/message.c | 42 ++----------------------------------------
 1 file changed, 2 insertions(+), 40 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index 525f4a1e7628..46522d10fbb1 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -280,17 +280,8 @@ static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 	case 's':
 		if (LINUX_S_ISDIR(inode->i_mode))
 			fprintf(f, "%u", inode->i_size);
-		else {
-#ifdef EXT2_NO_64_TYPE
-			if (inode->i_size_high)
-				fprintf(f, "0x%x%08x", inode->i_size_high,
-					inode->i_size);
-			else
-				fprintf(f, "%u", inode->i_size);
-#else
+		else
 			fprintf(f, "%llu", EXT2_I_SIZE(inode));
-#endif
-		}
 		break;
 	case 'S':
 		fprintf(f, "%u", large_inode->i_extra_isize);
@@ -411,11 +402,7 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fputc('%', f);
 		break;
 	case 'b':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "%*u", width, (unsigned long) ctx->blk);
-#else
 		fprintf(f, "%*llu", width, (unsigned long long) ctx->blk);
-#endif
 		break;
 	case 'B':
 		if (ctx->blkcount == BLOCK_COUNT_IND)
@@ -431,20 +418,11 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		if (*first && islower(m[0]))
 			fputc(toupper(*m++), f);
 		fputs(m, f);
-		if (ctx->blkcount >= 0) {
-#ifdef EXT2_NO_64_TYPE
-			fprintf(f, "%d", ctx->blkcount);
-#else
+		if (ctx->blkcount >= 0)
 			fprintf(f, "%lld", (long long) ctx->blkcount);
-#endif
-		}
 		break;
 	case 'c':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "%*u", width, (unsigned long) ctx->blk2);
-#else
 		fprintf(f, "%*llu", width, (unsigned long long) ctx->blk2);
-#endif
 		break;
 	case 'd':
 		fprintf(f, "%*u", width, ctx->dir);
@@ -462,18 +440,10 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "%*s", width, error_message(ctx->errcode));
 		break;
 	case 'N':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "%*u", width, ctx->num);
-#else
 		fprintf(f, "%*llu", width, (long long)ctx->num);
-#endif
 		break;
 	case 'n':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "%*u", width, ctx->num2);
-#else
 		fprintf(f, "%*llu", width, (long long)ctx->num2);
-#endif
 		break;
 	case 'p':
 		print_pathname(f, fs, ctx->ino, 0);
@@ -489,11 +459,7 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		print_pathname(f, fs, ctx->dir, ctx->ino);
 		break;
 	case 'r':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "%*d", width, ctx->blkcount);
-#else
 		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
-#endif
 		break;
 	case 'S':
 		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
@@ -511,11 +477,7 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "0x%0*x", width, ctx->csum1);
 		break;
 	case 'X':
-#ifdef EXT2_NO_64_TYPE
-		fprintf(f, "0x%0*x", width, ctx->num);
-#else
 		fprintf(f, "0x%0*llx", width, (long long)ctx->num);
-#endif
 		break;
 	case 'y':
 		fprintf(f, "0x%0*x", width, ctx->csum2);
-- 
2.13.2.725.g09c95d1e9-goog
