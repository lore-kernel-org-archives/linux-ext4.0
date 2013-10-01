From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/31] e2fsprogs: Less critical fixes to use the appropriate
 blk*t types
Date: Mon, 30 Sep 2013 18:28:05 -0700
Message-ID: <20131001012805.28415.80896.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3JAB2K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:28:10 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

More fixing of places where raw data types (int, long, etc.) stood in for blk_t
and blk64_t.  Also fix some sites where we should probably be using blk64_t.
These fixes aren't as critical as the previous patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/brel.h    |   18 +++++++++---------
 lib/ext2fs/brel_ma.c |   24 ++++++++++++------------
 lib/ext2fs/irel.h    |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/lib/ext2fs/brel.h b/lib/ext2fs/brel.h
index a0dd5b9..9fdddd4 100644
--- a/lib/ext2fs/brel.h
+++ b/lib/ext2fs/brel.h
@@ -10,11 +10,11 @@
  */
 
 struct ext2_block_relocate_entry {
-	blk_t	new;
+	blk64_t	new;
 	__s16	offset;
 	__u16	flags;
 	union {
-		blk_t		block_ref;
+		blk64_t		block_ref;
 		ext2_ino_t	inode_ref;
 	} owner;
 };
@@ -28,19 +28,19 @@ typedef struct ext2_block_relocation_table *ext2_brel;
 struct ext2_block_relocation_table {
 	__u32	magic;
 	char	*name;
-	blk_t	current;
+	blk64_t	current;
 	void	*priv_data;
 
 	/*
 	 * Add a block relocation entry.
 	 */
-	errcode_t (*put)(ext2_brel brel, blk_t old,
+	errcode_t (*put)(ext2_brel brel, blk64_t old,
 			      struct ext2_block_relocate_entry *ent);
 
 	/*
 	 * Get a block relocation entry.
 	 */
-	errcode_t (*get)(ext2_brel brel, blk_t old,
+	errcode_t (*get)(ext2_brel brel, blk64_t old,
 			      struct ext2_block_relocate_entry *ent);
 
 	/*
@@ -52,19 +52,19 @@ struct ext2_block_relocation_table {
 	 * The iterator function for the inode relocation entries.
 	 * Returns an inode number of 0 when out of entries.
 	 */
-	errcode_t (*next)(ext2_brel brel, blk_t *old,
+	errcode_t (*next)(ext2_brel brel, blk64_t *old,
 			  struct ext2_block_relocate_entry *ent);
 
 	/*
 	 * Move the inode relocation table from one block number to
 	 * another.
 	 */
-	errcode_t (*move)(ext2_brel brel, blk_t old, blk_t new);
+	errcode_t (*move)(ext2_brel brel, blk64_t old, blk_t new);
 
 	/*
 	 * Remove a block relocation entry.
 	 */
-	errcode_t (*delete)(ext2_brel brel, blk_t old);
+	errcode_t (*delete)(ext2_brel brel, blk64_t old);
 
 
 	/*
@@ -73,7 +73,7 @@ struct ext2_block_relocation_table {
 	errcode_t (*free)(ext2_brel brel);
 };
 
-errcode_t ext2fs_brel_memarray_create(char *name, blk_t max_block,
+errcode_t ext2fs_brel_memarray_create(char *name, blk64_t max_block,
 				    ext2_brel *brel);
 
 #define ext2fs_brel_put(brel, old, ent) ((brel)->put((brel), old, ent))
diff --git a/lib/ext2fs/brel_ma.c b/lib/ext2fs/brel_ma.c
index e8a8280..a12afae 100644
--- a/lib/ext2fs/brel_ma.c
+++ b/lib/ext2fs/brel_ma.c
@@ -27,24 +27,24 @@
 #include "ext2fs.h"
 #include "brel.h"
 
-static errcode_t bma_put(ext2_brel brel, blk_t old,
+static errcode_t bma_put(ext2_brel brel, blk64_t old,
 			struct ext2_block_relocate_entry *ent);
-static errcode_t bma_get(ext2_brel brel, blk_t old,
+static errcode_t bma_get(ext2_brel brel, blk64_t old,
 			struct ext2_block_relocate_entry *ent);
 static errcode_t bma_start_iter(ext2_brel brel);
-static errcode_t bma_next(ext2_brel brel, blk_t *old,
+static errcode_t bma_next(ext2_brel brel, blk64_t *old,
 			 struct ext2_block_relocate_entry *ent);
-static errcode_t bma_move(ext2_brel brel, blk_t old, blk_t new);
-static errcode_t bma_delete(ext2_brel brel, blk_t old);
+static errcode_t bma_move(ext2_brel brel, blk64_t old, blk64_t new);
+static errcode_t bma_delete(ext2_brel brel, blk64_t old);
 static errcode_t bma_free(ext2_brel brel);
 
 struct brel_ma {
 	__u32 magic;
-	blk_t max_block;
+	blk64_t max_block;
 	struct ext2_block_relocate_entry *entries;
 };
 
-errcode_t ext2fs_brel_memarray_create(char *name, blk_t max_block,
+errcode_t ext2fs_brel_memarray_create(char *name, blk64_t max_block,
 				      ext2_brel *new_brel)
 {
 	ext2_brel		brel = 0;
@@ -102,7 +102,7 @@ errout:
 	return retval;
 }
 
-static errcode_t bma_put(ext2_brel brel, blk_t old,
+static errcode_t bma_put(ext2_brel brel, blk64_t old,
 			struct ext2_block_relocate_entry *ent)
 {
 	struct brel_ma 	*ma;
@@ -114,7 +114,7 @@ static errcode_t bma_put(ext2_brel brel, blk_t old,
 	return 0;
 }
 
-static errcode_t bma_get(ext2_brel brel, blk_t old,
+static errcode_t bma_get(ext2_brel brel, blk64_t old,
 			struct ext2_block_relocate_entry *ent)
 {
 	struct brel_ma 	*ma;
@@ -134,7 +134,7 @@ static errcode_t bma_start_iter(ext2_brel brel)
 	return 0;
 }
 
-static errcode_t bma_next(ext2_brel brel, blk_t *old,
+static errcode_t bma_next(ext2_brel brel, blk64_t *old,
 			  struct ext2_block_relocate_entry *ent)
 {
 	struct brel_ma 	*ma;
@@ -151,7 +151,7 @@ static errcode_t bma_next(ext2_brel brel, blk_t *old,
 	return 0;
 }
 
-static errcode_t bma_move(ext2_brel brel, blk_t old, blk_t new)
+static errcode_t bma_move(ext2_brel brel, blk64_t old, blk64_t new)
 {
 	struct brel_ma 	*ma;
 
@@ -165,7 +165,7 @@ static errcode_t bma_move(ext2_brel brel, blk_t old, blk_t new)
 	return 0;
 }
 
-static errcode_t bma_delete(ext2_brel brel, blk_t old)
+static errcode_t bma_delete(ext2_brel brel, blk64_t old)
 {
 	struct brel_ma 	*ma;
 
diff --git a/lib/ext2fs/irel.h b/lib/ext2fs/irel.h
index 9a4958b..8aaa2d2 100644
--- a/lib/ext2fs/irel.h
+++ b/lib/ext2fs/irel.h
@@ -10,7 +10,7 @@
  */
 
 struct ext2_inode_reference {
-	blk_t	block;
+	blk64_t	block;
 	__u16 offset;
 };
 

