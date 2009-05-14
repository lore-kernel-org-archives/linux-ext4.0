From: Greg KH <gregkh@suse.de>
Subject: [patch 01/51] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Date: Thu, 14 May 2009 15:32:36 -0700
Message-ID: <20090514223520.343106419@mini.kroah.org>
References: <20090514223235.348540705@mini.kroah.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Josef Bacik <jbacik@redhat.com>,
	<linux-ext4@vger.kernel.org>, <xfs-masters@oss.sgi.com>,
	<linux-btrfs@vger.kernel.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <Joel.Becker@oracle.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51390 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbZENWly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 May 2009 18:41:54 -0400
Content-Disposition: inline; filename=fiemap-fix-problem-with-setting-fiemap_extent_last.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <jbacik@redhat.com>

commit df3935ffd6166fdd00702cf548fb5bb55737758b upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ioctl.c |   75 ++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 20 deletions(-)

--- a/fs/ioctl.c
+++ b/fs/ioctl.c
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
