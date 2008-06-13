From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [Take2 PATCH 06/10][e2fsprogs] Add 64-bit alloc interface.
Date: Fri, 13 Jun 2008 15:50:07 -0500
Message-ID: <20080613155007.4afee412@rx8>
References: <20080521175325.18810.25160.stgit@gara>
	<20080521175404.18810.86928.stgit@gara>
	<20080613143144.1679c75f@rx8>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60024 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYFMUuN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 16:50:13 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5DKoAi3031121
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 16:50:10 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5DKo9i9229882
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 16:50:10 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5DKo9S9008341
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 16:50:09 -0400
In-Reply-To: <20080613143144.1679c75f@rx8>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 13 Jun 2008 14:31:44 -0500
"Jose R. Santos" <jrs@us.ibm.com> wrote:

> On Wed, 21 May 2008 12:54:04 -0500
> "Jose R. Santos" <jrs@us.ibm.com> wrote:
> 
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > Add 64-bit alloc interface.
> > 
> > Add new ext2fs_new_block2(), ext2fs_get_free_blocks2() and
> > ext2fs_alloc_block2() that take and return blk64_t.
> > 
> > Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
> > --
> > 
> >  lib/ext2fs/alloc.c  |   59
> > +++++++++++++++++++++++++++++++++++++++++----------
> > lib/ext2fs/ext2fs.h |    8 +++++++ 2 files changed, 55
> > insertions(+), 12 deletions(-)
> 
> Hi Ted,
> 
> This patch seems like it was added incorrectly into the pu branch.
> None of the changes to alloc.c show up.
> 
> Commit: db1856299023306583f6ca8bcb450c01735da8cb
> 
> Thanks
> 
> -JRS

Looks like this was caused by a conflict with Commit:
f5c562e2324a8950d659ebfc8db4356121d6104e.  Fix patch bellow

-JRS

commit 397367a12d29703e9a056770c2ce39cbaa585a70
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Fri Jun 13 15:37:55 2008 -0500

Add 64-bit alloc interface.

Add new ext2fs_new_block2(), ext2fs_get_free_blocks2() and
ext2fs_alloc_block2() that take and return blk64_t.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

lib/ext2fs/alloc.c  |   59 +++++++++++++++++++++++++++++++++++++++++----------
lib/ext2fs/ext2fs.h |    8 +++++++
2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index f8d8a5f..38db123 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -73,10 +73,10 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
  * Stupid algorithm --- we now just search forward starting from the
  * goal.  Should put in a smarter one someday....
  */
-errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
-			   ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
+			   ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	i;
+	blk64_t	i;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -88,6 +88,7 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 		goal = fs->super->s_first_data_block;
 	i = goal;
 	do {
+		/* FIXME-64 */
 		if (!ext2fs_fast_test_block_bitmap(map, i)) {
 			*ret = i;
 			return 0;
@@ -99,15 +100,26 @@ errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
 
+errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
+			   ext2fs_block_bitmap map, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t val;
+	retval = ext2fs_new_block2(fs, goal, map, &val);
+	if (!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
 /*
  * This function zeros out the allocated block, and updates all of the
  * appropriate filesystem records.
  */
-errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
-			     char *block_buf, blk_t *ret)
+errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
+			     char *block_buf, blk64_t *ret)
 {
 	errcode_t	retval;
-	blk_t		block;
+	blk64_t		block;
 	char		*buf = 0;
 
 	if (!block_buf) {
@@ -119,29 +131,27 @@ errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 	memset(block_buf, 0, fs->blocksize);
 
 	if (fs->get_alloc_block) {
-		blk64_t	new;
-
-		retval = (fs->get_alloc_block)(fs, (blk64_t) goal, &new);
+		retval = (fs->get_alloc_block)(fs, goal, &block);
 		if (retval)
 			goto fail;
-		block = (blk_t) new;
 	} else {
 		if (!fs->block_map) {
+			/* FIXME-64 */
 			retval = ext2fs_read_block_bitmap(fs);
 			if (retval)
 				goto fail;
 		}
 
-		retval = ext2fs_new_block(fs, goal, 0, &block);
+		retval = ext2fs_new_block2(fs, goal, 0, &block);
 		if (retval)
 			goto fail;
 	}
 
-	retval = io_channel_write_blk(fs->io, block, 1, block_buf);
+	retval = io_channel_write_blk64(fs->io, block, 1, block_buf);
 	if (retval)
 		goto fail;
 	
-	ext2fs_block_alloc_stats(fs, block, +1);
+	ext2fs_block_alloc_stats2(fs, block, +1);
 	*ret = block;
 
 fail:
@@ -150,10 +160,21 @@ fail:
 	return retval;
 }
 
-errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
-				 int num, ext2fs_block_bitmap map, blk_t *ret)
+errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
+			     char *block_buf, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t	val;
+	retval = ext2fs_alloc_block2(fs, goal, block_buf, &val);
+	if (!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
+errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
+				 int num, ext2fs_block_bitmap map, blk64_t *ret)
 {
-	blk_t	b = start;
+	blk64_t	b = start;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -170,6 +191,7 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	do {
 		if (b+num-1 > fs->super->s_blocks_count)
 			b = fs->super->s_first_data_block;
+		/* FIXME-64 */
 		if (ext2fs_fast_test_block_bitmap_range(map, b, num)) {
 			*ret = b;
 			return 0;
@@ -179,6 +201,17 @@ errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
 	return EXT2_ET_BLOCK_ALLOC_FAIL;
 }
 
+errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start, blk_t finish,
+				 int num, ext2fs_block_bitmap map, blk_t *ret)
+{
+	errcode_t retval;
+	blk64_t val;
+	retval = ext2fs_get_free_blocks2(fs, start, finish, num, map, &val);
+	if(!retval)
+		*ret = (blk_t) val;
+	return retval;
+}
+
 void ext2fs_set_alloc_block_callback(ext2_filsys fs, 
 				     errcode_t (*func)(ext2_filsys fs,
 						       blk64_t goal,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e256a97..32e17e0 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -554,12 +554,20 @@ extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
 				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
 extern errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
 				  ext2fs_block_bitmap map, blk_t *ret);
+extern errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
+				   ext2fs_block_bitmap map, blk64_t *ret);
 extern errcode_t ext2fs_get_free_blocks(ext2_filsys fs, blk_t start,
 					blk_t finish, int num,
 					ext2fs_block_bitmap map,
 					blk_t *ret);
+extern errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start,
+					 blk64_t finish, int num,
+					 ext2fs_block_bitmap map,
+					 blk64_t *ret);
 extern errcode_t ext2fs_alloc_block(ext2_filsys fs, blk_t goal,
 				    char *block_buf, blk_t *ret);
+extern errcode_t ext2fs_alloc_block2(ext2_filsys fs, blk64_t goal,
+				     char *block_buf, blk64_t *ret);
 extern void ext2fs_set_alloc_block_callback(ext2_filsys fs, 
 					    errcode_t (*func)(ext2_filsys fs,
 							      blk64_t goal,
