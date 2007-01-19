From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [Resubmit][Patch 0/2] Persistent preallocation in ext4
Date: Fri, 19 Jan 2007 14:41:27 +0530
Message-ID: <20070119091127.GB28912@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
	suzuki@in.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:57869 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998AbXASJLh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Jan 2007 04:11:37 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0J9BVQg023367
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 04:11:31 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0J9BU8Z538074
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 02:11:30 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0J9BTVJ003298
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jan 2007 02:11:30 -0700
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20070117094658.GA17390@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 17, 2007 at 03:16:58PM +0530, Amit K. Arora wrote:
> The patches for e2fsprogs and fsx-linux are available with me. I can
> post them if anyone is interested to try/test the preallocation patches.
> Also, I have a small test program/tool written which can be used for
> unit testing.

Here is the patch to e2fsprogs-1.39, with patches for ext4 already
applied. It makes e2fsprogs tools recognize uninitialized extents. This
is only for testing purpose as of now and it might need some
fine-tuning, before it can be really be submitted.
This patch also enables "EXT_DEBUG" flag to display debug information
(e.g. extent details).

---
 lib/ext2fs/bmap.c         |    3 +-
 lib/ext2fs/ext4_extents.h |   12 +++++++++-
 lib/ext2fs/extents.c      |   55 ++++++++++++++++++++++++++++------------------
 3 files changed, 47 insertions(+), 23 deletions(-)

Index: e2fsprogs-1.39/lib/ext2fs/bmap.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/bmap.c	2006-12-19 11:53:48.000000000 +0530
+++ e2fsprogs-1.39/lib/ext2fs/bmap.c	2006-12-19 11:53:52.000000000 +0530
@@ -45,7 +45,8 @@
 		ex = EXT_FIRST_EXTENT(eh);
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			if ((ex->ee_block <= block) &&
-			    (block < ex->ee_block + ex->ee_len)) {
+			    (block < ex->ee_block + 
+			     ext4_ext_get_actual_len(ex))) {
 				*phys_blk = EXT4_EE_START(ex) +
 					(block - ex->ee_block);
 				return 0;
Index: e2fsprogs-1.39/lib/ext2fs/ext4_extents.h
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/ext4_extents.h	2006-12-19 11:53:48.000000000 +0530
+++ e2fsprogs-1.39/lib/ext2fs/ext4_extents.h	2006-12-19 15:55:32.000000000 +0530
@@ -37,7 +37,7 @@
  * if EXT_DEBUG is defined you can use 'extdebug' mount option
  * to get lots of info what's going on
  */
-//#define EXT_DEBUG
+#define EXT_DEBUG
 #ifdef EXT_DEBUG
 #define ext_debug(tree,fmt,a...) 			\
 do {							\
@@ -170,6 +170,16 @@
 
 #define EXT_ASSERT(__x__) if (!(__x__)) BUG();
 
+/*
+ * Macro-instructions used to handle (mark/unmark/check/create) unitialized
+ * extents. Applications can issue an IOCTL for preallocation, which results
+ * in assigning unitialized extents to the file
+ */
+#define EXT4_CREATE_UNINITIALIZED_EXT		2
+#define ext4_ext_mark_uninitialized(ext)	((ext)->ee_len |= 0x8000)
+#define ext4_ext_is_uninitialized(ext)  	((ext)->ee_len & 0x8000)
+#define ext4_ext_get_actual_len(ext)		((ext)->ee_len & 0x7FFF)
+
 
 /*
  * this structure is used to gather extents from the tree via ioctl
Index: e2fsprogs-1.39/lib/ext2fs/extents.c
===================================================================
--- e2fsprogs-1.39.orig/lib/ext2fs/extents.c	2006-12-19 11:53:48.000000000 +0530
+++ e2fsprogs-1.39/lib/ext2fs/extents.c	2006-12-19 11:55:03.000000000 +0530
@@ -36,9 +36,11 @@
 
 void show_extent(struct ext4_extent *ex)
 {
-	printf("extent: block=%u-%u len=%u start=%u start_hi=%u\n",
-	       ex->ee_block, ex->ee_block + ex->ee_len - 1,
-	       ex->ee_len, ex->ee_start, ex->ee_start_hi);
+	unsigned short ee_len = ext4_ext_get_actual_len(ex);
+	printf("extent[%c]: block=%u-%u len=%u start=%u start_hi=%u\n",
+		ext4_ext_is_uninitialized(ex) ? 'u' : 'i',
+		ex->ee_block, ex->ee_block + ee_len - 1, ee_len,
+		ex->ee_start, ex->ee_start_hi);
 }
 #else
 #define show_header(eh) do { } while (0)
@@ -75,7 +77,7 @@
 	if (EXT4_EE_START(ex) > EXT2_BLOCKS_COUNT(fs->super))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
-	if (ex->ee_len == 0)
+	if (ext4_ext_get_actual_len(ex) == 0)
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
 	if (ex_prev) {
@@ -84,13 +86,14 @@
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
 		/* extents must be in logical offset order */
-		if (ex->ee_block < ex_prev->ee_block + ex_prev->ee_len)
+		if (ex->ee_block < ex_prev->ee_block + 
+				ext4_ext_get_actual_len(ex_prev))
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
 		/* extents must not overlap physical blocks */
-		if ((EXT4_EE_START(ex) < 
-		     EXT4_EE_START(ex_prev) + ex_prev->ee_len) &&
-		    (EXT4_EE_START(ex) + ex->ee_len > EXT4_EE_START(ex_prev)))
+		if ((EXT4_EE_START(ex) < EXT4_EE_START(ex_prev) + 
+			ext4_ext_get_actual_len(ex_prev)) && (EXT4_EE_START(ex)
+			+ ext4_ext_get_actual_len(ex) > EXT4_EE_START(ex_prev)))
 			return EXT2_ET_EXTENT_LEAF_BAD;
 	}
 
@@ -98,7 +101,8 @@
 		if (ex->ee_block < ix->ei_block)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 
-		if (ix_len && ex->ee_block + ex->ee_len > ix->ei_block + ix_len)
+		if (ix_len && ex->ee_block + ext4_ext_get_actual_len(ex) > 
+							ix->ei_block + ix_len)
 			return EXT2_ET_EXTENT_LEAF_BAD;
 	}
 
@@ -144,6 +148,7 @@
 {
 	int entry = ex - EXT_FIRST_EXTENT(eh);
 	struct ext4_extent *ex_new = ex + 1;
+	unsigned uninitialized=0;
 
 	if (entry < 0 || entry > eh->eh_entries)
 		return EXT2_ET_EXTENT_LEAF_BAD;
@@ -151,18 +156,25 @@
 	if (eh->eh_entries >= eh->eh_max)
 		return EXT2_ET_EXTENT_NO_SPACE;
 
-	if (count > ex->ee_len)
+	if (count > ext4_ext_get_actual_len(ex))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
-	if (count > ex->ee_len)
+	if (count > ext4_ext_get_actual_len(ex))
 		return EXT2_ET_EXTENT_LEAF_BAD;
 
+	if(ext4_ext_is_uninitialized(ex))
+		uninitialized=1;
+
 	memmove(ex_new, ex, (eh->eh_entries - entry) * sizeof(*ex));
 	++eh->eh_entries;
 
 	ex->ee_len = count;
 	ex_new->ee_len -= count;
 	ex_new->ee_block += count;
+	if(uninitialized) {
+		ext4_ext_mark_uninitialized(ex);
+		ext4_ext_mark_uninitialized(ex_new);
+	}
 	EXT4_EE_START_SET(ex_new, EXT4_EE_START(ex_new) + count);
 
 	return 0;
@@ -195,7 +207,7 @@
 		ex = EXT_FIRST_EXTENT(eh);
 		for (i = 0; i < eh->eh_entries; i++, ex++) {
 			show_extent(ex);
-			for (j = 0; j < ex->ee_len; j++) {
+			for (j = 0; j < ext4_ext_get_actual_len(ex); j++) {
 				block_address = EXT4_EE_START(ex) + j;
 				flags = (*ctx->func)(ctx->fs, &block_address,
 						     (ex->ee_block + j),
@@ -216,15 +228,15 @@
 #endif
 
 				if (ex_prev &&
-				    block_address ==
-				    EXT4_EE_START(ex_prev) + ex_prev->ee_len &&
-				    ex->ee_block + j ==
-				    ex_prev->ee_block + ex_prev->ee_len) {
+				    block_address == EXT4_EE_START(ex_prev) +
+				    ext4_ext_get_actual_len(ex_prev) &&
+				    ex->ee_block + j == ex_prev->ee_block + 
+				    ext4_ext_get_actual_len(ex_prev)) {
 					/* can merge block with prev extent */
 					ex_prev->ee_len++;
 
 					ex->ee_len--;
-					if (ex->ee_len == 0) {
+					if (ext4_ext_get_actual_len(ex) == 0) {
 						/* no blocks left in this one */
 						ext2fs_extent_remove(eh, ex);
 						i--; ex--;
@@ -238,7 +250,7 @@
 					}
 					ret |= BLOCK_CHANGED;
 
-				} else if (ex->ee_len == 1) {
+				} else if (ext4_ext_get_actual_len(ex) == 1) {
 					/* single-block extent is easy -
 					 * change extent directly */
 					EXT4_EE_START_SET(ex, block_address);
@@ -250,7 +262,8 @@
 					ret |= BLOCK_ABORT | BLOCK_ERROR;
 					return ret;
 
-				} else if (j > 0 && (ex + 1)->ee_len > 1 &&
+				} else if (j > 0 && 
+					   ext4_ext_get_actual_len(ex + 1) > 1 &&
 					   ext2fs_extent_split(eh, ex + 1, 1)) {
 					/* split after new block failed */
 					/* No multi-level split yet */
@@ -258,7 +271,7 @@
 					return ret;
 
 				} else if (j == 0) {
-					if (ex->ee_len != 1) {
+					if (ext4_ext_get_actual_len(ex) != 1) {
 						/* this is an internal error */
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;
@@ -269,7 +282,7 @@
 				} else {
 					ex++;
 					i++;
-					if (ex->ee_len != 1) {
+					if (ext4_ext_get_actual_len(ex) != 1) {
 						/* this is an internal error */
 						ret |= BLOCK_ABORT |BLOCK_ERROR;
 						return ret;

 
--
Regards,
Amit Arora
