From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 05/12] e2fsck: generalize ea_refcount
Date: Mon, 26 Jun 2017 06:43:41 -0700
Message-ID: <20170626134348.1240-5-tahsin@google.com>
References: <20170626134348.1240-1-tahsin@google.com>
Cc: Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:35861 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdFZNoC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Jun 2017 09:44:02 -0400
Received: by mail-pf0-f171.google.com with SMTP id q86so719890pfl.3
        for <linux-ext4@vger.kernel.org>; Mon, 26 Jun 2017 06:44:02 -0700 (PDT)
In-Reply-To: <20170626134348.1240-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ea_refcount is only used to track ea block refcounts. By
generalizing it, we could use it for ea quota tracking and also
ea_inode refcounts.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 e2fsck/e2fsck.h      |  21 ++++---
 e2fsck/ea_refcount.c | 160 +++++++++++++++++++++++++++------------------------
 e2fsck/pass1.c       |   4 +-
 3 files changed, 99 insertions(+), 86 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index c19cdfdd733e..f9285d01978c 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -466,18 +466,23 @@ extern int e2fsck_get_num_dx_dirinfo(e2fsck_t ctx);
 extern struct dx_dir_info *e2fsck_dx_dir_info_iter(e2fsck_t ctx, int *control);
 
 /* ea_refcount.c */
-extern errcode_t ea_refcount_create(int size, ext2_refcount_t *ret);
+typedef __u64 ea_key_t;
+typedef __u64 ea_value_t;
+
+extern errcode_t ea_refcount_create(size_t size, ext2_refcount_t *ret);
 extern void ea_refcount_free(ext2_refcount_t refcount);
-extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk, int *ret);
+extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, ea_key_t ea_key,
+				   ea_value_t *ret);
 extern errcode_t ea_refcount_increment(ext2_refcount_t refcount,
-				       blk64_t blk, int *ret);
+				       ea_key_t ea_key, ea_value_t *ret);
 extern errcode_t ea_refcount_decrement(ext2_refcount_t refcount,
-				       blk64_t blk, int *ret);
-extern errcode_t ea_refcount_store(ext2_refcount_t refcount,
-				   blk64_t blk, int count);
-extern blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
+				       ea_key_t ea_key, ea_value_t *ret);
+extern errcode_t ea_refcount_store(ext2_refcount_t refcount, ea_key_t ea_key,
+				   ea_value_t count);
+extern size_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
 extern void ea_refcount_intr_begin(ext2_refcount_t refcount);
-extern blk64_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
+extern ea_key_t ea_refcount_intr_next(ext2_refcount_t refcount,
+				      ea_value_t *ret);
 
 /* ehandler.c */
 extern const char *ehandler_operation(const char *op);
diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index fcfaf4970ece..ecb198640c69 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -25,14 +25,15 @@
  * checked, its bit is set in the block_ea_map bitmap.
  */
 struct ea_refcount_el {
-	blk64_t	ea_blk;
-	int	ea_count;
+	/* ea_key could either be an inode number or block number. */
+	ea_key_t	ea_key;
+	ea_value_t	ea_value;
 };
 
 struct ea_refcount {
-	blk_t		count;
-	blk_t		size;
-	blk_t		cursor;
+	size_t		count;
+	size_t		size;
+	size_t		cursor;
 	struct ea_refcount_el	*list;
 };
 
@@ -46,7 +47,7 @@ void ea_refcount_free(ext2_refcount_t refcount)
 	ext2fs_free_mem(&refcount);
 }
 
-errcode_t ea_refcount_create(int size, ext2_refcount_t *ret)
+errcode_t ea_refcount_create(size_t size, ext2_refcount_t *ret)
 {
 	ext2_refcount_t	refcount;
 	errcode_t	retval;
@@ -60,9 +61,9 @@ errcode_t ea_refcount_create(int size, ext2_refcount_t *ret)
 	if (!size)
 		size = 500;
 	refcount->size = size;
-	bytes = (size_t) (size * sizeof(struct ea_refcount_el));
+	bytes = size * sizeof(struct ea_refcount_el);
 #ifdef DEBUG
-	printf("Refcount allocated %d entries, %d bytes.\n",
+	printf("Refcount allocated %zu entries, %zu bytes.\n",
 	       refcount->size, bytes);
 #endif
 	retval = ext2fs_get_mem(bytes, &refcount->list);
@@ -92,14 +93,14 @@ static void refcount_collapse(ext2_refcount_t refcount)
 
 	list = refcount->list;
 	for (i = 0, j = 0; i < refcount->count; i++) {
-		if (list[i].ea_count) {
+		if (list[i].ea_value) {
 			if (i != j)
 				list[j] = list[i];
 			j++;
 		}
 	}
 #if defined(DEBUG) || defined(TEST_PROGRAM)
-	printf("Refcount_collapse: size was %d, now %d\n",
+	printf("Refcount_collapse: size was %zu, now %d\n",
 	       refcount->count, j);
 #endif
 	refcount->count = j;
@@ -111,11 +112,11 @@ static void refcount_collapse(ext2_refcount_t refcount)
  * 	specified position.
  */
 static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
-						 blk64_t blk, int pos)
+						 ea_key_t ea_key, int pos)
 {
 	struct ea_refcount_el 	*el;
 	errcode_t		retval;
-	blk_t			new_size = 0;
+	size_t			new_size = 0;
 	int			num;
 
 	if (refcount->count >= refcount->size) {
@@ -141,8 +142,8 @@ static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
 	}
 	refcount->count++;
 	el = &refcount->list[pos];
-	el->ea_count = 0;
-	el->ea_blk = blk;
+	el->ea_key = ea_key;
+	el->ea_value = 0;
 	return el;
 }
 
@@ -153,7 +154,7 @@ static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
  * 	and we can't find an entry, create one in the sorted list.
  */
 static struct ea_refcount_el *get_refcount_el(ext2_refcount_t refcount,
-					      blk64_t blk, int create)
+					      ea_key_t ea_key, int create)
 {
 	int	low, high, mid;
 
@@ -163,11 +164,11 @@ retry:
 	low = 0;
 	high = (int) refcount->count-1;
 	if (create && ((refcount->count == 0) ||
-		       (blk > refcount->list[high].ea_blk))) {
+		       (ea_key > refcount->list[high].ea_key))) {
 		if (refcount->count >= refcount->size)
 			refcount_collapse(refcount);
 
-		return insert_refcount_el(refcount, blk,
+		return insert_refcount_el(refcount, ea_key,
 					  (unsigned) refcount->count);
 	}
 	if (refcount->count == 0)
@@ -175,18 +176,18 @@ retry:
 
 	if (refcount->cursor >= refcount->count)
 		refcount->cursor = 0;
-	if (blk == refcount->list[refcount->cursor].ea_blk)
+	if (ea_key == refcount->list[refcount->cursor].ea_key)
 		return &refcount->list[refcount->cursor++];
 #ifdef DEBUG
-	printf("Non-cursor get_refcount_el: %u\n", blk);
+	printf("Non-cursor get_refcount_el: %u\n", ea_key);
 #endif
 	while (low <= high) {
 		mid = (low+high)/2;
-		if (blk == refcount->list[mid].ea_blk) {
+		if (ea_key == refcount->list[mid].ea_key) {
 			refcount->cursor = mid+1;
 			return &refcount->list[mid];
 		}
-		if (blk < refcount->list[mid].ea_blk)
+		if (ea_key < refcount->list[mid].ea_key)
 			high = mid-1;
 		else
 			low = mid+1;
@@ -201,69 +202,72 @@ retry:
 			if (refcount->count < refcount->size)
 				goto retry;
 		}
-		return insert_refcount_el(refcount, blk, low);
+		return insert_refcount_el(refcount, ea_key, low);
 	}
 	return 0;
 }
 
-errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk,
-				int *ret)
+errcode_t ea_refcount_fetch(ext2_refcount_t refcount, ea_key_t ea_key,
+			    ea_value_t *ret)
 {
 	struct ea_refcount_el	*el;
 
-	el = get_refcount_el(refcount, blk, 0);
+	el = get_refcount_el(refcount, ea_key, 0);
 	if (!el) {
 		*ret = 0;
 		return 0;
 	}
-	*ret = el->ea_count;
+	*ret = el->ea_value;
 	return 0;
 }
 
-errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk64_t blk, int *ret)
+errcode_t ea_refcount_increment(ext2_refcount_t refcount, ea_key_t ea_key,
+				ea_value_t *ret)
 {
 	struct ea_refcount_el	*el;
 
-	el = get_refcount_el(refcount, blk, 1);
+	el = get_refcount_el(refcount, ea_key, 1);
 	if (!el)
 		return EXT2_ET_NO_MEMORY;
-	el->ea_count++;
+	el->ea_value++;
 
 	if (ret)
-		*ret = el->ea_count;
+		*ret = el->ea_value;
 	return 0;
 }
 
-errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk64_t blk, int *ret)
+errcode_t ea_refcount_decrement(ext2_refcount_t refcount, ea_key_t ea_key,
+				ea_value_t *ret)
 {
 	struct ea_refcount_el	*el;
 
-	el = get_refcount_el(refcount, blk, 0);
-	if (!el || el->ea_count == 0)
+	el = get_refcount_el(refcount, ea_key, 0);
+	if (!el || el->ea_value == 0)
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	el->ea_count--;
+	el->ea_value--;
 
 	if (ret)
-		*ret = el->ea_count;
+		*ret = el->ea_value;
 	return 0;
 }
 
-errcode_t ea_refcount_store(ext2_refcount_t refcount, blk64_t blk, int count)
+errcode_t ea_refcount_store(ext2_refcount_t refcount, ea_key_t ea_key,
+			    ea_value_t ea_value)
 {
 	struct ea_refcount_el	*el;
 
 	/*
 	 * Get the refcount element
 	 */
-	el = get_refcount_el(refcount, blk, count ? 1 : 0);
+	el = get_refcount_el(refcount, ea_key, ea_value ? 1 : 0);
 	if (!el)
-		return count ? EXT2_ET_NO_MEMORY : 0;
-	el->ea_count = count;
+		return ea_value ? EXT2_ET_NO_MEMORY : 0;
+	el->ea_value = ea_value;
 	return 0;
 }
 
-blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
+size_t ext2fs_get_refcount_size(ext2_refcount_t refcount)
 {
 	if (!refcount)
 		return 0;
@@ -276,9 +280,8 @@ void ea_refcount_intr_begin(ext2_refcount_t refcount)
 	refcount->cursor = 0;
 }
 
-
-blk64_t ea_refcount_intr_next(ext2_refcount_t refcount,
-				int *ret)
+ea_key_t ea_refcount_intr_next(ext2_refcount_t refcount,
+				ea_value_t *ret)
 {
 	struct ea_refcount_el	*list;
 
@@ -286,10 +289,10 @@ blk64_t ea_refcount_intr_next(ext2_refcount_t refcount,
 		if (refcount->cursor >= refcount->count)
 			return 0;
 		list = refcount->list;
-		if (list[refcount->cursor].ea_count) {
+		if (list[refcount->cursor].ea_value) {
 			if (ret)
-				*ret = list[refcount->cursor].ea_count;
-			return list[refcount->cursor++].ea_blk;
+				*ret = list[refcount->cursor].ea_value;
+			return list[refcount->cursor++].ea_key;
 		}
 		refcount->cursor++;
 	}
@@ -309,11 +312,11 @@ errcode_t ea_refcount_validate(ext2_refcount_t refcount, FILE *out)
 		return EXT2_ET_INVALID_ARGUMENT;
 	}
 	for (i=1; i < refcount->count; i++) {
-		if (refcount->list[i-1].ea_blk >= refcount->list[i].ea_blk) {
+		if (refcount->list[i-1].ea_key >= refcount->list[i].ea_key) {
 			fprintf(out,
-				"%s: list[%d].blk=%llu, list[%d].blk=%llu\n",
-				bad, i-1, refcount->list[i-1].ea_blk,
-				i, refcount->list[i].ea_blk);
+				"%s: list[%d].ea_key=%llu, list[%d].ea_key=%llu\n",
+				bad, i-1, refcount->list[i-1].ea_key, i,
+				refcount->list[i].ea_key);
 			ret = EXT2_ET_INVALID_ARGUMENT;
 		}
 	}
@@ -370,8 +373,9 @@ int main(int argc, char **argv)
 {
 	int	i = 0;
 	ext2_refcount_t refcount;
-	int		size, arg;
-	blk64_t		blk;
+	size_t		size;
+	ea_key_t	ea_key;
+	ea_value_t	arg;
 	errcode_t	retval;
 
 	while (1) {
@@ -383,10 +387,10 @@ int main(int argc, char **argv)
 			retval = ea_refcount_create(size, &refcount);
 			if (retval) {
 				com_err("ea_refcount_create", retval,
-					"while creating size %d", size);
+					"while creating size %zu", size);
 				exit(1);
 			} else
-				printf("Creating refcount with size %d\n",
+				printf("Creating refcount with size %zu\n",
 				       size);
 			break;
 		case BCODE_FREE:
@@ -395,43 +399,46 @@ int main(int argc, char **argv)
 			printf("Freeing refcount\n");
 			break;
 		case BCODE_STORE:
-			blk = (blk_t) bcode_program[i++];
+			ea_key = (size_t) bcode_program[i++];
 			arg = bcode_program[i++];
-			printf("Storing blk %llu with value %d\n", blk, arg);
-			retval = ea_refcount_store(refcount, blk, arg);
+			printf("Storing ea_key %llu with value %llu\n", ea_key,
+			       arg);
+			retval = ea_refcount_store(refcount, ea_key, arg);
 			if (retval)
 				com_err("ea_refcount_store", retval,
-					"while storing blk %llu", blk);
+					"while storing ea_key %llu", ea_key);
 			break;
 		case BCODE_FETCH:
-			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_fetch(refcount, blk, &arg);
+			ea_key = (size_t) bcode_program[i++];
+			retval = ea_refcount_fetch(refcount, ea_key, &arg);
 			if (retval)
 				com_err("ea_refcount_fetch", retval,
-					"while fetching blk %llu", blk);
+					"while fetching ea_key %llu", ea_key);
 			else
-				printf("bcode_fetch(%llu) returns %d\n",
-				       blk, arg);
+				printf("bcode_fetch(%llu) returns %llu\n",
+				       ea_key, arg);
 			break;
 		case BCODE_INCR:
-			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_increment(refcount, blk, &arg);
+			ea_key = (size_t) bcode_program[i++];
+			retval = ea_refcount_increment(refcount, ea_key, &arg);
 			if (retval)
 				com_err("ea_refcount_increment", retval,
-					"while incrementing blk %llu", blk);
+					"while incrementing ea_key %llu",
+					ea_key);
 			else
-				printf("bcode_increment(%llu) returns %d\n",
-				       blk, arg);
+				printf("bcode_increment(%llu) returns %llu\n",
+				       ea_key, arg);
 			break;
 		case BCODE_DECR:
-			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_decrement(refcount, blk, &arg);
+			ea_key = (size_t) bcode_program[i++];
+			retval = ea_refcount_decrement(refcount, ea_key, &arg);
 			if (retval)
 				com_err("ea_refcount_decrement", retval,
-					"while decrementing blk %llu", blk);
+					"while decrementing ea_key %llu",
+					ea_key);
 			else
-				printf("bcode_decrement(%llu) returns %d\n",
-				       blk, arg);
+				printf("bcode_decrement(%llu) returns %llu\n",
+				       ea_key, arg);
 			break;
 		case BCODE_VALIDATE:
 			retval = ea_refcount_validate(refcount, stderr);
@@ -444,10 +451,11 @@ int main(int argc, char **argv)
 		case BCODE_LIST:
 			ea_refcount_intr_begin(refcount);
 			while (1) {
-				blk = ea_refcount_intr_next(refcount, &arg);
-				if (!blk)
+				ea_key = ea_refcount_intr_next(refcount, &arg);
+				if (!ea_key)
 					break;
-				printf("\tblk=%llu, count=%d\n", blk, arg);
+				printf("\tea_key=%llu, count=%llu\n", ea_key,
+				       arg);
 			}
 			break;
 		case BCODE_COLLAPSE:
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 1532fd2067f2..9ee2c5e89a61 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2269,7 +2269,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 	ext2_filsys			fs = ctx->fs;
 	blk64_t				blk;
 	__u32				should_be;
-	int				count;
+	ea_value_t			count;
 
 	clear_problem_context(&pctx);
 
@@ -2286,7 +2286,7 @@ static void adjust_extattr_refcount(e2fsck_t ctx, ext2_refcount_t refcount,
 		}
 		header = (struct ext2_ext_attr_header *) block_buf;
 		pctx.blkcount = header->h_refcount;
-		should_be = header->h_refcount + adjust_sign * count;
+		should_be = header->h_refcount + adjust_sign * (int)count;
 		pctx.num = should_be;
 		if (fix_problem(ctx, PR_1_EXTATTR_REFCOUNT, &pctx)) {
 			header->h_refcount = should_be;
-- 
2.13.1.611.g7e3b11ae1-goog
