From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: fix for fiemap last-block test
Date: Tue, 28 Apr 2009 10:58:30 -0500
Message-ID: <49F727A6.8010302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Carl Henrik Lunde <chlunde@ping.uio.no>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45029 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761591AbZD1P71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Apr 2009 11:59:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Carl Henrik Lunde reported and debugged this; the test for the
last allocated block was comparing bytes to blocks in this test:

	if (logical + length - 1 == EXT_MAX_BLOCK ||
	    ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK)
		flags |= FIEMAP_EXTENT_LAST;

so any extent which ended right at 4G was stopping the extent
walk.  Just replacing these values with the extent block &
length should fix it.

Also give blksize_bits a saner type, and reverse the order 
of the tests to make the more likely case tested first.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Tested-by: Carl Henrik Lunde <chlunde@ping.uio.no>
---

Index: linux-2.6.29.x86_64/fs/ext4/extents.c
===================================================================
--- linux-2.6.29.x86_64.orig/fs/ext4/extents.c
+++ linux-2.6.29.x86_64/fs/ext4/extents.c
@@ -3087,7 +3087,7 @@ static int ext4_ext_fiemap_cb(struct ino
 		       void *data)
 {
 	struct fiemap_extent_info *fieinfo = data;
-	unsigned long blksize_bits = inode->i_sb->s_blocksize_bits;
+	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 	__u64	logical;
 	__u64	physical;
 	__u64	length;
@@ -3134,8 +3134,8 @@ static int ext4_ext_fiemap_cb(struct ino
 	 *
 	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
 	 */
-	if (logical + length - 1 == EXT_MAX_BLOCK ||
-	    ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK)
+	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
+	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK)
 		flags |= FIEMAP_EXTENT_LAST;
 
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,

