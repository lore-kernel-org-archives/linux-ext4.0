From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] misc: quiet minor compiler errors
Date: Wed, 27 Jul 2011 22:42:36 -0600
Message-ID: <1311828156-31419-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61622 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1G1Emk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Jul 2011 00:42:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several compiler errors are quieted:
- zero-length gnu_printf format string
- unused variable
- uninitalized variable (though it isn't actually used for anything)

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/ea_refcount.c |   30 ++++++++++++++----------------
 e2fsck/problem.c     |    1 +
 e2fsck/region.c      |    2 +-
 misc/tune2fs.c       |    2 +-
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index b10cfff..ece10c2 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -406,8 +406,8 @@ int main(int argc, char **argv)
 			size = bcode_program[i++];
 			retval = ea_refcount_create(size, &refcount);
 			if (retval) {
-				com_err("ea_refcount_create",
-					retval, "");
+				com_err("ea_refcount_create", retval,
+					"while creating size %d", size);
 				exit(1);
 			} else
 				printf("Creating refcount with size %d\n",
@@ -421,35 +421,35 @@ int main(int argc, char **argv)
 		case BCODE_STORE:
 			blk = (blk_t) bcode_program[i++];
 			arg = bcode_program[i++];
-			retval = ea_refcount_store(refcount, blk, arg);
 			printf("Storing blk %u with value %d\n", blk, arg);
+			retval = ea_refcount_store(refcount, blk, arg);
 			if (retval)
-				com_err("ea_refcount_store", retval, "");
+				com_err("ea_refcount_store", retval,
+					"while storing blk %u", blk);
 			break;
 		case BCODE_FETCH:
 			blk = (blk_t) bcode_program[i++];
 			retval = ea_refcount_fetch(refcount, blk, &arg);
 			if (retval)
-				com_err("ea_refcount_fetch", retval, "");
+				com_err("ea_refcount_fetch", retval,
+					"while fetching blk %u", blk);
 			else
 				printf("bcode_fetch(%u) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_INCR:
 			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_increment(refcount, blk,
-							   &arg);
+			retval = ea_refcount_increment(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_increment", retval,
-					"");
+					"while incrementing blk %u", blk);
 			else
 				printf("bcode_increment(%u) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_DECR:
 			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_decrement(refcount, blk,
-							   &arg);
+			retval = ea_refcount_decrement(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_decrement", retval,
 					"while decrementing blk %u", blk);
@@ -460,20 +460,18 @@ int main(int argc, char **argv)
 		case BCODE_VALIDATE:
 			retval = ea_refcount_validate(refcount, stderr);
 			if (retval)
-				com_err("ea_refcount_validate",
-					retval, "");
+				com_err("ea_refcount_validate", retval,
+					"while validating");
 			else
 				printf("Refcount validation OK.\n");
 			break;
 		case BCODE_LIST:
 			ea_refcount_intr_begin(refcount);
 			while (1) {
-				blk = ea_refcount_intr_next(refcount,
-								&arg);
+				blk = ea_refcount_intr_next(refcount, &arg);
 				if (!blk)
 					break;
-				printf("\tblk=%u, count=%d\n", blk,
-				       arg);
+				printf("\tblk=%u, count=%d\n", blk, arg);
 			}
 			break;
 		case BCODE_COLLAPSE:
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c5bebf8..eab9fe2 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1958,6 +1958,7 @@ int main(int argc, char *argv[])
 	e2fsck_t ctx;
 	int rc;
 
+	memset(&ctx, 0, sizeof(ctx)); /* just to quiet compiler */
 	rc = verify_problem_table(ctx);
 	if (rc == 0)
 		printf("e2fsck problem table verified\n");
diff --git a/e2fsck/region.c b/e2fsck/region.c
index e50c8a4..85c1ac7 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -172,7 +172,7 @@ int main(int argc, char **argv)
 {
 	region_t	r;
 	int		pc = 0, ret;
-	region_addr_t	start, end, len;
+	region_addr_t	start, end;
 
 
 	while (1) {
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5bf5187..9e369ec 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1864,7 +1864,7 @@ retry_open:
 		printf(_("Setting stripe width to %d\n"), stripe_width);
 	}
 	if (ext_mount_opts) {
-		strncpy(fs->super->s_mount_opts, ext_mount_opts,
+		strncpy((char *)(fs->super->s_mount_opts), ext_mount_opts,
 			sizeof(fs->super->s_mount_opts));
 		fs->super->s_mount_opts[sizeof(fs->super->s_mount_opts)-1] = 0;
 		ext2fs_mark_super_dirty(fs);
-- 
1.7.3.4

