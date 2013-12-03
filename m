From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 08/10] e2fsck: add support for 64-bit extended attribute block refcounting
Date: Tue,  3 Dec 2013 00:10:16 -0500
Message-ID: <1386047418-32431-9-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35859 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab3LCFK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:27 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have a 64-bit file system with extended attribute blocks, e2fsck
would not correctly handle EA blocks that were located beyond the
32-bit block number boundary.  Fix this by teaching
e2fsck/ea_refcount.c to use 64-bit block numbers.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.h      | 11 +++++------
 e2fsck/ea_refcount.c | 18 +++++++++---------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 3c4f832..913a596 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -435,17 +435,16 @@ extern struct dx_dir_info *e2fsck_dx_dir_info_iter(e2fsck_t ctx, int *control);
 /* ea_refcount.c */
 extern errcode_t ea_refcount_create(int size, ext2_refcount_t *ret);
 extern void ea_refcount_free(ext2_refcount_t refcount);
-extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
-				   int *ret);
+extern errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk, int *ret);
 extern errcode_t ea_refcount_increment(ext2_refcount_t refcount,
-				       blk_t blk, int *ret);
+				       blk64_t blk, int *ret);
 extern errcode_t ea_refcount_decrement(ext2_refcount_t refcount,
-				       blk_t blk, int *ret);
+				       blk64_t blk, int *ret);
 extern errcode_t ea_refcount_store(ext2_refcount_t refcount,
-				   blk_t blk, int count);
+				   blk64_t blk, int count);
 extern blk_t ext2fs_get_refcount_size(ext2_refcount_t refcount);
 extern void ea_refcount_intr_begin(ext2_refcount_t refcount);
-extern blk_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
+extern blk64_t ea_refcount_intr_next(ext2_refcount_t refcount, int *ret);
 
 /* ehandler.c */
 extern const char *ehandler_operation(const char *op);
diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index e66e636..3836c5d 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -25,7 +25,7 @@
  * checked, its bit is set in the block_ea_map bitmap.
  */
 struct ea_refcount_el {
-	blk_t	ea_blk;
+	blk64_t	ea_blk;
 	int	ea_count;
 };
 
@@ -111,7 +111,7 @@ static void refcount_collapse(ext2_refcount_t refcount)
  * 	specified position.
  */
 static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
-						 blk_t blk, int pos)
+						 blk64_t blk, int pos)
 {
 	struct ea_refcount_el 	*el;
 	errcode_t		retval;
@@ -153,7 +153,7 @@ static struct ea_refcount_el *insert_refcount_el(ext2_refcount_t refcount,
  * 	and we can't find an entry, create one in the sorted list.
  */
 static struct ea_refcount_el *get_refcount_el(ext2_refcount_t refcount,
-					      blk_t blk, int create)
+					      blk64_t blk, int create)
 {
 	int	low, high, mid;
 
@@ -206,7 +206,7 @@ retry:
 	return 0;
 }
 
-errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
+errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk64_t blk,
 				int *ret)
 {
 	struct ea_refcount_el	*el;
@@ -220,7 +220,7 @@ errcode_t ea_refcount_fetch(ext2_refcount_t refcount, blk_t blk,
 	return 0;
 }
 
-errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk_t blk, int *ret)
+errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk64_t blk, int *ret)
 {
 	struct ea_refcount_el	*el;
 
@@ -234,7 +234,7 @@ errcode_t ea_refcount_increment(ext2_refcount_t refcount, blk_t blk, int *ret)
 	return 0;
 }
 
-errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk_t blk, int *ret)
+errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk64_t blk, int *ret)
 {
 	struct ea_refcount_el	*el;
 
@@ -249,7 +249,7 @@ errcode_t ea_refcount_decrement(ext2_refcount_t refcount, blk_t blk, int *ret)
 	return 0;
 }
 
-errcode_t ea_refcount_store(ext2_refcount_t refcount, blk_t blk, int count)
+errcode_t ea_refcount_store(ext2_refcount_t refcount, blk64_t blk, int count)
 {
 	struct ea_refcount_el	*el;
 
@@ -277,7 +277,7 @@ void ea_refcount_intr_begin(ext2_refcount_t refcount)
 }
 
 
-blk_t ea_refcount_intr_next(ext2_refcount_t refcount,
+blk64_t ea_refcount_intr_next(ext2_refcount_t refcount,
 				int *ret)
 {
 	struct ea_refcount_el	*list;
@@ -370,7 +370,7 @@ int main(int argc, char **argv)
 	int	i = 0;
 	ext2_refcount_t refcount;
 	int		size, arg;
-	blk_t		blk;
+	blk64_t		blk;
 	errcode_t	retval;
 
 	while (1) {
-- 
1.8.5.rc3.362.gdf10213

