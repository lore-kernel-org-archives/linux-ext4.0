From: Leonard Michlmayr <leonard.michlmayr@gmail.com>
Subject: ext4_fiemap gives 0 extents for files smaller than a block (patch
 included)
Date: Wed, 04 Nov 2009 19:42:41 +0100
Message-ID: <1257360161.22057.16.camel@michlmayr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-k/ajpJuzLsFcZdgAKKTm"
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.187]:37863 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZKDSml (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 13:42:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-k/ajpJuzLsFcZdgAKKTm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Fiemap (ioctl) does not return any extents for small files on ext4.
(fm_start=0, fm_length=filesize)

File affected: fs/ext4/extents.c

I found the reason of the bug: wrong rounding. It will not only affect
small files, but any request that overlaps an extent boundary by less
that blocksize.

The attached patch is against 2.6.32-rc5.

Leonard Michlmayr


--=-k/ajpJuzLsFcZdgAKKTm
Content-Disposition: attachment; filename="ext4_fiemap_fix.patch"
Content-Type: text/x-patch; name="ext4_fiemap_fix.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -Naur linux-2.6.32-rc5/fs/ext4/extents.c linux-2.6.32-rc5.patched/fs/ext4/extents.c
--- linux-2.6.32-rc5/fs/ext4/extents.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.patched/fs/ext4/extents.c	2009-11-04 19:35:44.000000000 +0100
@@ -3685,6 +3685,7 @@
 		__u64 start, __u64 len)
 {
 	ext4_lblk_t start_blk;
+	ext4_lblk_t end_blk;
 	ext4_lblk_t len_blks;
 	int error = 0;
 
@@ -3700,7 +3701,8 @@
 		error = ext4_xattr_fiemap(inode, fieinfo);
 	} else {
 		start_blk = start >> inode->i_sb->s_blocksize_bits;
-		len_blks = len >> inode->i_sb->s_blocksize_bits;
+		end_blk = (start + len - 1) >> inode->i_sb->s_blocksize_bits;
+		len_blks = end_blk - start_blk + 1;
 
 		/*
 		 * Walk the extent tree gathering extent information.

--=-k/ajpJuzLsFcZdgAKKTm--

