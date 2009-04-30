From: akpm@linux-foundation.org
Subject: + fiemap-fix-problem-with-setting-fiemap_extent_last.patch added to -mm tree
Date: Thu, 30 Apr 2009 15:41:05 -0700
Message-ID: <200904302241.n3UMf5IL001855@imap1.linux-foundation.org>
Cc: jbacik@redhat.com, Joel.Becker@oracle.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, sandeen@redhat.com, stable@kernel.org,
	swhiteho@redhat.com, xfs-masters@oss.sgi.com
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbZD3WsT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Apr 2009 18:48:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     fiemap: fix problem with setting FIEMAP_EXTENT_LAST
has been added to the -mm tree.  Its filename is
     fiemap-fix-problem-with-setting-fiemap_extent_last.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fiemap: fix problem with setting FIEMAP_EXTENT_LAST
From: Josef Bacik <jbacik@redhat.com>

Fix a problem where the generic block based fiemap stuff would not
properly set FIEMAP_EXTENT_LAST on the last extent.  I've reworked things
to keep track if we go past the EOF, and mark the last extent properly. 
The problem was reported by and tested by Eric Sandeen.

Tested-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Josef Bacik <jbacik@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: <xfs-masters@oss.sgi.com>
Cc: <linux-btrfs@vger.kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <Joel.Becker@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |   75 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 20 deletions(-)

diff -puN fs/ioctl.c~fiemap-fix-problem-with-setting-fiemap_extent_last fs/ioctl.c
--- a/fs/ioctl.c~fiemap-fix-problem-with-setting-fiemap_extent_last
+++ a/fs/ioctl.c
@@ -258,7 +258,7 @@ int __generic_block_fiemap(struct inode 
 	long long length = 0, map_len = 0;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
-	int ret = 0;
+	int ret = 0, past_eof = 0, whole_file = 0;
 
 	if ((ret = fiemap_check_flags(fieinfo, FIEMAP_FLAG_SYNC)))
 		return ret;
@@ -266,6 +266,9 @@ int __generic_block_fiemap(struct inode 
 	start_blk = logical_to_blk(inode, start);
 
 	length = (long long)min_t(u64, len, i_size_read(inode));
+	if (length < len)
+		whole_file = 1;
+
 	map_len = length;
 
 	do {
@@ -282,11 +285,26 @@ int __generic_block_fiemap(struct inode 
 
 		/* HOLE */
 		if (!buffer_mapped(&tmp)) {
+			length -= blk_to_logical(inode, 1);
+			start_blk++;
+
+			/*
+			 * we want to handle the case where there is an
+			 * allocated block at the front of the file, and then
+			 * nothing but holes up to the end of the file properly,
+			 * to make sure that extent at the front gets properly
+			 * marked with FIEMAP_EXTENT_LAST
+			 */
+			if (!past_eof &&
+			    blk_to_logical(inode, start_blk) >=
+			    blk_to_logical(inode, 0)+i_size_read(inode))
+				past_eof = 1;
+
 			/*
 			 * first hole after going past the EOF, this is our
 			 * last extent
 			 */
-			if (length <= 0) {
+			if (past_eof && size) {
 				flags = FIEMAP_EXTENT_MERGED|FIEMAP_EXTENT_LAST;
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
@@ -294,15 +312,37 @@ int __generic_block_fiemap(struct inode 
 				break;
 			}
 
-			length -= blk_to_logical(inode, 1);
-
 			/* if we have holes up to/past EOF then we're done */
-			if (length <= 0)
+			if (length <= 0 || past_eof)
 				break;
-
-			start_blk++;
 		} else {
-			if (length <= 0 && size) {
+			/*
+			 * we have gone over the length of what we wanted to
+			 * map, and it wasn't the entire file, so add the extent
+			 * we got last time and exit.
+			 *
+			 * This is for the case where say we want to map all the
+			 * way up to the second to the last block in a file, but
+			 * the last block is a hole, making the second to last
+			 * block FIEMAP_EXTENT_LAST.  In this case we want to
+			 * see if there is a hole after the second to last block
+			 * so we can mark it properly.  If we found data after
+			 * we exceeded the length we were requesting, then we
+			 * are good to go, just add the extent to the fieinfo
+			 * and break
+			 */
+			if (length <= 0 && !whole_file) {
+				ret = fiemap_fill_next_extent(fieinfo, logical,
+							      phys, size,
+							      flags);
+				break;
+			}
+
+			/*
+			 * if size != 0 then we know we already have an extent
+			 * to add, so add it.
+			 */
+			if (size) {
 				ret = fiemap_fill_next_extent(fieinfo, logical,
 							      phys, size,
 							      flags);
@@ -319,19 +359,14 @@ int __generic_block_fiemap(struct inode 
 			start_blk += logical_to_blk(inode, size);
 
 			/*
-			 * if we are past the EOF we need to loop again to see
-			 * if there is a hole so we can mark this extent as the
-			 * last one, and if not keep mapping things until we
-			 * find a hole, or we run out of slots in the extent
-			 * array
+			 * If we are past the EOF, then we need to make sure as
+			 * soon as we find a hole that the last extent we found
+			 * is marked with FIEMAP_EXTENT_LAST
 			 */
-			if (length <= 0)
-				continue;
