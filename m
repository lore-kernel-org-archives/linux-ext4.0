From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] e2fsck: fix printf conversion specs in ea_refcount.c
Date: Mon, 16 Dec 2013 21:36:39 -0500
Message-ID: <20131217023639.GB2173@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qe0-f42.google.com ([209.85.128.42]:62097 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LQCgo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 21:36:44 -0500
Received: by mail-qe0-f42.google.com with SMTP id b4so4719267qen.29
        for <linux-ext4@vger.kernel.org>; Mon, 16 Dec 2013 18:36:43 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 130e961a6fb9d38997c83c6397cf9ddb5ed2491f changed the type
used to represent block numbers in ea_refcount.c from blk_t to blk64_t
to add support for 64 bit extended attribute refcounting.  We also
need to adjust printf conversion specs that now don't match their new
blk64_t arguments.  This will silence compiler warnings seen when
"make check" is run and will avoid truncation of printed values.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 e2fsck/ea_refcount.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index 3836c5d..fcfaf49 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -310,7 +310,8 @@ errcode_t ea_refcount_validate(ext2_refcount_t refcount, FILE *out)
 	}
 	for (i=1; i < refcount->count; i++) {
 		if (refcount->list[i-1].ea_blk >= refcount->list[i].ea_blk) {
-			fprintf(out, "%s: list[%d].blk=%u, list[%d].blk=%u\n",
+			fprintf(out,
+				"%s: list[%d].blk=%llu, list[%d].blk=%llu\n",
 				bad, i-1, refcount->list[i-1].ea_blk,
 				i, refcount->list[i].ea_blk);
 			ret = EXT2_ET_INVALID_ARGUMENT;
@@ -396,20 +397,20 @@ int main(int argc, char **argv)
 		case BCODE_STORE:
 			blk = (blk_t) bcode_program[i++];
 			arg = bcode_program[i++];
-			printf("Storing blk %u with value %d\n", blk, arg);
+			printf("Storing blk %llu with value %d\n", blk, arg);
 			retval = ea_refcount_store(refcount, blk, arg);
 			if (retval)
 				com_err("ea_refcount_store", retval,
-					"while storing blk %u", blk);
+					"while storing blk %llu", blk);
 			break;
 		case BCODE_FETCH:
 			blk = (blk_t) bcode_program[i++];
 			retval = ea_refcount_fetch(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_fetch", retval,
-					"while fetching blk %u", blk);
+					"while fetching blk %llu", blk);
 			else
-				printf("bcode_fetch(%u) returns %d\n",
+				printf("bcode_fetch(%llu) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_INCR:
@@ -417,9 +418,9 @@ int main(int argc, char **argv)
 			retval = ea_refcount_increment(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_increment", retval,
-					"while incrementing blk %u", blk);
+					"while incrementing blk %llu", blk);
 			else
-				printf("bcode_increment(%u) returns %d\n",
+				printf("bcode_increment(%llu) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_DECR:
@@ -427,9 +428,9 @@ int main(int argc, char **argv)
 			retval = ea_refcount_decrement(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_decrement", retval,
-					"while decrementing blk %u", blk);
+					"while decrementing blk %llu", blk);
 			else
-				printf("bcode_decrement(%u) returns %d\n",
+				printf("bcode_decrement(%llu) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_VALIDATE:
@@ -446,7 +447,7 @@ int main(int argc, char **argv)
 				blk = ea_refcount_intr_next(refcount, &arg);
 				if (!blk)
 					break;
-				printf("\tblk=%u, count=%d\n", blk, arg);
+				printf("\tblk=%llu, count=%d\n", blk, arg);
 			}
 			break;
 		case BCODE_COLLAPSE:
-- 
1.8.3.2

