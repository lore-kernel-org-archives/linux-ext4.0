From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/10] libext2fs: add pseudo bitmap backend type EXT2FS_BMAP64_AUTODIR
Date: Sun, 18 Dec 2011 01:42:33 -0500
Message-ID: <1324190558-7436-6-git-send-email-tytso@mit.edu>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50574 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277Ab1LRGml (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 01:42:41 -0500
In-Reply-To: <1324190558-7436-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This backend type will automatically switch between the bitarray and
the rbtree backend based on the number of directories in the file
system.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in    |    3 +++
 lib/ext2fs/ext2fs.h       |    1 +
 lib/ext2fs/gen_bitmap64.c |    8 ++++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 4c5ebed..ef55494 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -400,6 +400,9 @@ check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount \
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
 		./tst_bitmaps -t 2 -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
 	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
+	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) \
+		./tst_bitmaps -t 3 -f $(srcdir)/tst_bitmaps_cmds > tst_bitmaps_out
+	diff $(srcdir)/tst_bitmaps_exp tst_bitmaps_out
 
 installdirs::
 	$(E) "	MKINSTALLDIRS $(libdir) $(includedir)/ext2fs"
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 5ffb036..f2df66e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -294,6 +294,7 @@ struct struct_ext2_filsys {
 
 #define EXT2FS_BMAP64_BITARRAY	1
 #define EXT2FS_BMAP64_RBTREE	2
+#define EXT2FS_BMAP64_AUTODIR	3
 
 /*
  * Return flags for the block iterator functions
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index c9b4051..7b066a2 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -86,6 +86,7 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 {
 	ext2fs_generic_bitmap	bitmap;
 	struct ext2_bitmap_ops	*ops;
+	ext2_ino_t num_dirs;
 	errcode_t retval;
 
 	if (!type)
@@ -98,6 +99,13 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 	case EXT2FS_BMAP64_RBTREE:
 		ops = &ext2fs_blkmap64_rbtree;
 		break;
+	case EXT2FS_BMAP64_AUTODIR:
+		retval = ext2fs_get_num_dirs(fs, &num_dirs);
+		if (retval || num_dirs > (fs->super->s_inodes_count / 320))
+			ops = &ext2fs_blkmap64_bitarray;
+		else
+			ops = &ext2fs_blkmap64_rbtree;
+		break;
 	default:
 		return EINVAL;
 	}
-- 
1.7.8.11.gefc1f.dirty

