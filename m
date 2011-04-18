From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 2/2] E2fsprogs: add compress and cow support in chattr, lsattr
Date: Mon, 18 Apr 2011 15:37:30 +0800
Message-ID: <4DABEA3A.4070008@cn.fujitsu.com>
References: <4DA2A15C.1050501@cn.fujitsu.com> <4DA692C8.2080400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, tytso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63213 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRHfy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Apr 2011 03:35:54 -0400
In-Reply-To: <4DA692C8.2080400@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Modify command 'chattr' and 'lsattr' to support compress and cow.
- use 'C' to indicate NOCOW attribute.
- still use 'c' to indicate compress attribute.

Also update the man doc.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 lib/e2p/pf.c         |    1 +
 lib/ext2fs/ext2_fs.h |    1 +
 misc/chattr.1.in     |   15 +++++++++++----
 misc/chattr.c        |   15 ++++++++++++++-
 4 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index cc50896..c9385dd 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -48,6 +48,7 @@ static struct flags_name flags_array[] = {
 	{ FS_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
+	{ FS_NOCOW_FL, "C", "NOCOW" },
 	{ 0, NULL, NULL }
 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 858c103..776be92 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -276,6 +276,7 @@ struct ext2_dx_countlimit {
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
 #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+#define FS_NOCOW_FL			0x00800000 /* Do not cow file */
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 92f6d70..434eb04 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -19,17 +19,18 @@ chattr \- change file attributes on a Linux file system
 .B chattr
 changes the file attributes on a Linux file system.
 .PP
-The format of a symbolic mode is +-=[acdeijstuADST].
+The format of a symbolic mode is +-=[acdeijstuACDST].
 .PP
 The operator `+' causes the selected attributes to be added to the
 existing attributes of the files; `-' causes them to be removed; and
 `=' causes them to be the only attributes that the files have.
 .PP
-The letters `acdeijstuADST' select the new attributes for the files:
+The letters `acdeijstuACDST' select the new attributes for the files:
 append only (a), compressed (c), no dump (d), extent format (e), immutable (i),
 data journalling (j), secure deletion (s), no tail-merging (t), 
-undeletable (u), no atime updates (A), synchronous directory updates (D), 
-synchronous updates (S), and top of directory hierarchy (T).
+undeletable (u), no atime updates (A), no copy on write (C),
+synchronous directory updates (D), synchronous updates (S),
+and top of directory hierarchy (T).
 .PP
 The following attributes are read-only, and may be listed by
 .BR lsattr (1)
@@ -64,6 +65,10 @@ this file compresses data before storing them on the disk.  Note: please
 make sure to read the bugs and limitations section at the end of this
 document.
 .PP
+A file with the `C' attribute set is marked without COW (copy on write).  Note:
+please make sure to read the bugs and limitations section at the end of this
+document.
+.PP
 When a directory with the `D' attribute set is modified,
 the changes are written synchronously on the disk; this is equivalent to
 the `dirsync' mount option applied to a subset of the files.
@@ -161,6 +166,8 @@ The `c', 's',  and `u' attributes are not honored
 by the ext2 and ext3 filesystems as implemented in the current mainline
 Linux kernels.    These attributes may be implemented
 in future versions of the ext2 and ext3 filesystems.
+The `C' attribute is only used in btrfs filesystem in the current mainline
+Linux kernels.
 .PP
 The `j' option is only useful if the filesystem is mounted as ext3.
 .PP
diff --git a/misc/chattr.c b/misc/chattr.c
index 78e3736..8c8231e 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -82,7 +82,7 @@ static unsigned long sf;
 static void usage(void)
 {
 	fprintf(stderr,
-		_("Usage: %s [-RVf] [-+=AacDdeijsSu] [-v version] files...\n"),
+		_("Usage: %s [-RVf] [-+=AacDdeijsSuC] [-v version] files...\n"),
 		program_name);
 	exit(1);
 }
@@ -106,6 +106,7 @@ static const struct flags_char flags_array[] = {
 	{ FS_UNRM_FL, 'u' },
 	{ FS_NOTAIL_FL, 't' },
 	{ FS_TOPDIR_FL, 'T' },
+	{ FS_NOCOW_FL, 'C' },
 	{ 0, 0 }
 };
 
@@ -159,6 +160,12 @@ static int decode_arg (int * i, int argc, char ** argv)
 			}
 			if ((fl = get_flag(*p)) == 0)
 				usage();
+
+			if (fl == FS_COMPR_FL) {
+				af |= FS_NOCOMPR_FL;
+				add = 1;
+			}
+
 			rf |= fl;
 			rem = 1;
 		}
@@ -168,6 +175,12 @@ static int decode_arg (int * i, int argc, char ** argv)
 		for (p = &argv[*i][1]; *p; p++) {
 			if ((fl = get_flag(*p)) == 0)
 				usage();
+
+			if (fl == FS_COMPR_FL) {
+				rf |= FS_NOCOMPR_FL;
+				rem = 1;
+			}
+
 			af |= fl;
 		}
 		break;
-- 
1.6.5.2

