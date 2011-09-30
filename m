From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libext2fs: Fix various errors result from crc32c/metadata
	checksum integration
Date: Fri, 30 Sep 2011 12:38:43 -0700
Message-ID: <20110930193843.GS12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35280 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab1I3Tif (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Sep 2011 15:38:35 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8UIHRNT027069
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 14:17:27 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8UJcY90226678
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 15:38:34 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8UJcXl9025034
	for <linux-ext4@vger.kernel.org>; Fri, 30 Sep 2011 15:38:34 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix several minor errors in structure definitions, the byteswap code, and
Makefiles that result from merging the crc32c and initial parts of the metadata
checksumming patchset.

(This fix is required by the metadata checksumming patchset)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 lib/ext2fs/Makefile.in |    2 +-
 lib/ext2fs/ext2fs.h    |    4 ++--
 lib/ext2fs/swapfs.c    |   18 ++++++++----------
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index c2bfb70..3de9f87 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -398,7 +398,7 @@ clean::
 		tst_bitops tst_types tst_icount tst_super_size tst_csum \
 		ext2_tdbtool mkjournal debug_cmds.c \
 		../libext2fs.a ../libext2fs_p.a ../libext2fs_chk.a \
-		crc32c_table.h
+		crc32c_table.h gen_crc32ctable tst_crc32c
 
 mostlyclean:: clean
 distclean:: clean
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 203d222..357bf60 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -916,8 +916,8 @@ extern int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 extern void ext2fs_update_dynamic_rev(ext2_filsys fs);
 
 /* crc32c.c */
-extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
-extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
+extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
+extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
 extern void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group);
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 7962472..7c99373 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -260,7 +260,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		t->osd2.linux2.l_i_gid_high =
 		  ext2fs_swab16 (f->osd2.linux2.l_i_gid_high);
 		t->osd2.linux2.l_i_checksum_lo =
-			ext2fs_swab32(f->osd2.linux2.l_i_checksum_lo);
+			ext2fs_swab16(f->osd2.linux2.l_i_checksum_lo);
 		break;
 	case EXT2_OS_HURD:
 		t->osd1.hurd1.h_i_translator =
@@ -294,21 +294,19 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 		return;
 	}
 
-	if (extra_isize >= 2)
+	if (extra_isize >= 4)
 		t->i_checksum_hi = ext2fs_swab16(f->i_checksum_hi);
-	if (extra_isize >= 6)
-		t->i_checksum_hi = ext2fs_swab32(f->i_checksum_hi);
-	if (extra_isize >= 10)
+	if (extra_isize >= 8)
 		t->i_ctime_extra = ext2fs_swab32(f->i_ctime_extra);
-	if (extra_isize >= 14)
+	if (extra_isize >= 12)
 		t->i_mtime_extra = ext2fs_swab32(f->i_mtime_extra);
-	if (extra_isize >= 18)
+	if (extra_isize >= 16)
 		t->i_atime_extra = ext2fs_swab32(f->i_atime_extra);
-	if (extra_isize >= 22)
+	if (extra_isize >= 20)
 		t->i_crtime = ext2fs_swab32(f->i_crtime);
-	if (extra_isize >= 26)
+	if (extra_isize >= 24)
 		t->i_crtime_extra = ext2fs_swab32(f->i_crtime_extra);
-	if (extra_isize >= 30)
+	if (extra_isize >= 28)
 		t->i_version_hi = ext2fs_swab32(f->i_version_hi);
 
 	i = sizeof(struct ext2_inode) + extra_isize + sizeof(__u32);
