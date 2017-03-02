From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/3] misc: fix all the compiler warnings
Date: Wed, 01 Mar 2017 20:52:12 -0800
Message-ID: <148843033271.21733.1120873236425357085.stgit@birch.djwong.org>
References: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16938 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbdCBEwT (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Mar 2017 23:52:19 -0500
In-Reply-To: <148843032650.21733.13980225191301375698.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the various compiler warnings that have crept in, and only define
__bitwise if the system headers haven't already done so.  Linux 4.10
changes the __bitwise definition so that our redefinition here is
just different enough that gcc complains.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/debugfs.c          |    2 --
 debugfs/xattrs.c           |    5 ++---
 e2fsck/pass2.c             |    2 +-
 lib/ext2fs/ext2_types.h.in |    8 ++++++--
 lib/ext2fs/ext_attr.c      |    2 --
 lib/support/cstring.c      |    6 +++---
 misc/dumpe2fs.c            |   15 ---------------
 7 files changed, 12 insertions(+), 28 deletions(-)


diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 165f924..366ae5f 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1588,9 +1588,7 @@ void do_unlink(int argc, char *argv[])
 void do_copy_inode(int argc, char *argv[])
 {
 	ext2_ino_t	src_ino, dest_ino;
-	struct ext2_inode inode;
 	unsigned char	buf[4096];
-	int		retval;
 
 	if (common_args_process(argc, argv, 3, 3, "copy_inode",
 				"<source file> <dest_name>", CHECK_FS_RW))
diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index 2443518..9b87d14 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -146,7 +146,7 @@ void do_get_xattr(int argc, char **argv)
 	size_t buflen;
 	int i;
 	int print_flags = 0;
-	int handle_flags = 0;
+	unsigned int handle_flags = 0;
 	errcode_t err;
 
 	reset_getopt();
@@ -241,8 +241,7 @@ void do_set_xattr(int argc, char **argv)
 	FILE *fp = NULL;
 	char *buf = NULL;
 	size_t buflen;
-	int print_flags = 0;
-	int handle_flags = 0;
+	unsigned int handle_flags = 0;
 	int i;
 	errcode_t err;
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 11c19e8..170878c 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -90,7 +90,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct problem_context	pctx;
 	ext2_filsys 		fs = ctx->fs;
-	char			*buf;
+	char			*buf = NULL;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
diff --git a/lib/ext2fs/ext2_types.h.in b/lib/ext2fs/ext2_types.h.in
index 07adc64..fb36a5d 100644
--- a/lib/ext2fs/ext2_types.h.in
+++ b/lib/ext2fs/ext2_types.h.in
@@ -173,10 +173,14 @@ typedef long		__s64;
 #define EXT2_ENDIAN_H_
 
 #ifdef __CHECKER__
-#define __bitwise		__attribute__((bitwise))
+# ifndef __bitwise
+#  define __bitwise		__attribute__((bitwise))
+# endif
 #define __force			__attribute__((force))
 #else
-#define __bitwise
+# ifndef __bitwise
+#  define __bitwise
+# endif
 #define __force
 #endif
 
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index ce2f48f..7a9a2d5 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -478,7 +478,6 @@ static errcode_t convert_posix_acl_to_disk_buffer(const void *value, size_t size
 	ext4_acl_header *ext_acl;
 	size_t s;
 	void *e;
-	int err;
 
 	int count;
 
@@ -532,7 +531,6 @@ static errcode_t convert_disk_buffer_to_posix_acl(const void *value, size_t size
 	errcode_t err;
 	const char *cp;
 	char *out;
-	int count;
 
 	if ((!value) ||
 	    (size < sizeof(ext4_acl_header)) ||
diff --git a/lib/support/cstring.c b/lib/support/cstring.c
index 7965e95..57f4522 100644
--- a/lib/support/cstring.c
+++ b/lib/support/cstring.c
@@ -15,12 +15,12 @@
 
 int parse_c_string(char *str)
 {
-	unsigned char *to, *from, ch;
+	char *to, *from, ch;
 	int v;
 
 	to = from = str;
 
-	for (to = from = (unsigned char *) str;
+	for (to = from = (char *) str;
 	     *from && *from != '"'; to++, from++) {
 		if (*from == '\\') {
 			ch = *(++from);
@@ -93,7 +93,7 @@ int parse_c_string(char *str)
 		*to = *from;
 	}
 	*to = '\0';
-	return to - (unsigned char *) str;
+	return to - (char *) str;
 }
 
 void print_c_string(FILE *f, const char *cp, int len)
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 621840a..395ea9e 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -356,16 +356,6 @@ static void list_bad_blocks(ext2_filsys fs, int dump)
 	ext2fs_badblocks_list_free(bb_list);
 }
 
-static const char *journal_checksum_type_str(__u8 type)
-{
-	switch (type) {
-	case JBD2_CRC32C_CHKSUM:
-		return "crc32c";
-	default:
-		return "unknown";
-	}
-}
