From: Sebastian Rasmussen <sebras@gmail.com>
Subject: [PATCH 2/3] Fix typos in code comments and developer docs.
Date: Sat, 14 Oct 2017 20:44:55 +0200
Message-ID: <20171014184456.17602-3-sebras@gmail.com>
References: <20171014184456.17602-1-sebras@gmail.com>
Cc: linux-ext4@vger.kernel.org, Sebastian Rasmussen <sebras@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:50949 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdJNSpJ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Oct 2017 14:45:09 -0400
Received: by mail-lf0-f65.google.com with SMTP id a132so12861422lfa.7
        for <linux-ext4@vger.kernel.org>; Sat, 14 Oct 2017 11:45:08 -0700 (PDT)
In-Reply-To: <20171014184456.17602-1-sebras@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Sebastian Rasmussen <sebras@gmail.com>
---
 INSTALL                            |  2 +-
 INSTALL.elfbin                     |  2 +-
 TODO                               |  4 ++--
 aclocal.m4                         |  4 ++--
 configure.ac                       |  6 +++---
 contrib/add_ext4_encrypt.c         |  2 +-
 contrib/android/basefs_allocator.c |  2 +-
 debian/rules                       |  2 +-
 debian/uuid-dev.README.Debian      |  4 ++--
 debugfs/Makefile.in                |  2 +-
 debugfs/logdump.c                  |  2 +-
 debugfs/set_fields.c               |  2 +-
 debugfs/util.c                     |  2 +-
 e2fsck/message.c                   |  2 +-
 e2fsck/pass1.c                     |  6 +++---
 e2fsck/pass1b.c                    |  2 +-
 e2fsck/pass2.c                     |  4 ++--
 e2fsck/pass3.c                     |  2 +-
 e2fsck/pass5.c                     |  2 +-
 e2fsck/problem.c                   |  6 +++---
 e2fsck/problem.h                   | 10 +++++-----
 e2fsck/recovery.c                  |  4 ++--
 e2fsck/region.c                    |  2 +-
 e2fsck/unix.c                      |  2 +-
 e2fsck/util.c                      |  2 +-
 ext2ed/README                      |  6 +++---
 ext2ed/dir_com.c                   |  2 +-
 ext2ed/disk.c                      |  2 +-
 ext2ed/ext2ed.conf.in              |  4 ++--
 ext2ed/ext2ed.h                    |  4 ++--
 ext2ed/init.c                      |  2 +-
 ext2ed/main.c                      | 10 +++++-----
 intl/dcigettext.c                  |  2 +-
 intl/l10nflist.c                   |  2 +-
 intl/libgettext.h                  |  2 +-
 intl/xsize.h                       |  2 +-
 lib/blkid/dev.c                    |  2 +-
 lib/blkid/probe.h                  |  2 +-
 lib/blkid/tag.c                    |  2 +-
 lib/et/com_right.c                 |  2 +-
 lib/ext2fs/Makefile.in             |  2 +-
 lib/ext2fs/alloc_tables.c          |  2 +-
 lib/ext2fs/bb_inode.c              |  2 +-
 lib/ext2fs/bitops.c                |  2 +-
 lib/ext2fs/blkmap64_rb.c           |  2 +-
 lib/ext2fs/ext2_fs.h               |  4 ++--
 lib/ext2fs/ext2fs.h                |  4 ++--
 lib/ext2fs/ext3_extents.h          |  2 +-
 lib/ext2fs/get_pathname.c          |  2 +-
 lib/ext2fs/inline_data.c           |  2 +-
 lib/ext2fs/inode.c                 |  2 +-
 lib/ext2fs/nt_io.c                 |  8 ++++----
 lib/ext2fs/rbtree.h                |  2 +-
 lib/ext2fs/res_gdt.c               |  2 +-
 lib/ext2fs/tdb.c                   | 14 +++++++-------
 lib/ext2fs/undo_io.c               |  2 +-
 lib/ss/ct_c.sed                    |  4 ++--
 lib/support/profile.c              |  2 +-
 lib/support/profile_helpers.c      |  2 +-
 lib/support/quotaio.h              |  2 +-
 lib/support/quotaio_tree.h         |  2 +-
 lib/uuid/gen_uuid_nt.c             |  2 +-
 misc/Makefile.in                   |  2 +-
 misc/create_inode.c                |  2 +-
 misc/e2image.c                     |  2 +-
 misc/e4crypt.c                     |  2 +-
 misc/e4defrag.c                    |  4 ++--
 misc/findsuper.c                   |  4 ++--
 misc/fsck.c                        |  2 +-
 misc/fsck.h                        |  2 +-
 misc/logsave.c                     |  2 +-
 misc/tune2fs.h                     |  4 ++--
 resize/extent.c                    |  2 +-
 resize/main.c                      |  2 +-
 resize/online.c                    |  2 +-
 resize/resize2fs.c                 | 14 +++++++-------
 resize/resize2fs.h                 |  2 +-
 resize/sim_progress.c              |  2 +-
 resize/test_extent.c               |  2 +-
 util/gen-tarball.in                |  2 +-
 util/subst.c                       |  2 +-
 util/symlinks.c                    |  2 +-
 82 files changed, 126 insertions(+), 126 deletions(-)

diff --git a/INSTALL b/INSTALL
index b5afd2f5..2dd08f53 100644
--- a/INSTALL
+++ b/INSTALL
@@ -56,7 +56,7 @@ frequency, and the fsck pass number, respectively.  The problem with
 this is that the getmntent() library routine interprets those missing
 fields as "0", and a pass number of 0 is documented as meaning that
 fsck should not check that particular filesystem.  If your entries in
-your /etc/fstab file look liks this:
+your /etc/fstab file look like this:
 
 /dev/hda4       /        ext2        defaults
 
diff --git a/INSTALL.elfbin b/INSTALL.elfbin
index 3f54aa10..9c2c6006 100644
--- a/INSTALL.elfbin
+++ b/INSTALL.elfbin
@@ -35,7 +35,7 @@ frequency, and the fsck pass number, respectively.  The problem with
 this is that the getmntent() library routine interprets those missing
 fields as "0", and a pass number of 0 is documented as meaning that
 fsck should not check that particular filesystem.  If your entries in
-your /etc/fstab file look liks this:
+your /etc/fstab file look like this:
 
 /dev/hda4       /        ext2        defaults
 
diff --git a/TODO b/TODO
index d531d175..a622bec1 100644
--- a/TODO
+++ b/TODO
@@ -29,7 +29,7 @@ Date: Mon, 08 Mar 1999 21:46:14 +0100
 From: Sergio Polini <s.polini@mclink.it>
 
 
-I'm reading the sorce code of e2fsck 1.14.
+I'm reading the source code of e2fsck 1.14.
 In pass2.c, lines 352-357, I read:
 
 if ((dirent->name_len & 0xFF) > EXT2_NAME_LEN) {
@@ -72,7 +72,7 @@ directories by using debugfs to get the relevant block numbers, then
 using dd to get the actual data.
 
 If debugfs had a feature where it ignored the size of a directory reported by
-the inode and instead just dumped all the blocks, it would have facilited
+the inode and instead just dumped all the blocks, it would have facilitated
 things a bit. This seems like a very easy feature to add.
 
 Again, thanks for writing debugfs (and all the other Linux stuff you've written!).
diff --git a/aclocal.m4 b/aclocal.m4
index 4cf123a1..cfb42cd1 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -1884,7 +1884,7 @@ AC_DEFUN([AC_LIB_LINKFLAGS_BODY],
     fi
 ])
   dnl Search the library and its dependencies in $additional_libdir and
-  dnl $LDFLAGS. Using breadth-first-seach.
+  dnl $LDFLAGS. Using breadth-first-search.
   LIB[]NAME=
   LTLIB[]NAME=
   INC[]NAME=
@@ -2912,7 +2912,7 @@ fi[]dnl
 # to PKG_CHECK_MODULES(), but does not set variables or print errors.
 #
 # Please remember that m4 expands AC_REQUIRE([PKG_PROG_PKG_CONFIG])
-# only at the first occurence in configure.ac, so if the first place
+# only at the first occurrence in configure.ac, so if the first place
 # it's called might be skipped (such as if it is within an "if", you
 # have to call PKG_CHECK_EXISTS manually
 # --------------------------------------------------------------
diff --git a/configure.ac b/configure.ac
index 1314c385..4ec46170 100644
--- a/configure.ac
+++ b/configure.ac
@@ -124,8 +124,8 @@ else
 fi
 AC_USE_SYSTEM_EXTENSIONS
 dnl
-dnl Set default values for library extentions.  Will be dealt with after
-dnl parsing configuration opions, which may modify these
+dnl Set default values for library extensions.  Will be dealt with after
+dnl parsing configuration options, which may modify these
 dnl
 LIB_EXT=.a
 STATIC_LIB_EXT=.a
@@ -977,7 +977,7 @@ AC_CHECK_HEADERS(net/if.h,,,
 ]])
 AC_FUNC_VPRINTF
 dnl Check to see if dirent has member d_reclen. On cygwin those d_reclen
-dnl is not decleared.
+dnl is not declared.
 AC_CHECK_MEMBER(struct dirent.d_reclen,[AC_DEFINE(HAVE_RECLEN_DIRENT, 1,
 		       [Define to 1 if dirent has d_reclen])],,
 		[#include <dirent.h>])
diff --git a/contrib/add_ext4_encrypt.c b/contrib/add_ext4_encrypt.c
index d4e7c8c5..133fe253 100644
--- a/contrib/add_ext4_encrypt.c
+++ b/contrib/add_ext4_encrypt.c
@@ -1,5 +1,5 @@
 /*
- * Basic progam to add ext4 encryption to a file system
+ * Basic program to add ext4 encryption to a file system
  *
  * Copyright 2015, Google, Inc.
  *
diff --git a/contrib/android/basefs_allocator.c b/contrib/android/basefs_allocator.c
index 3d014a22..76d183c9 100644
--- a/contrib/android/basefs_allocator.c
+++ b/contrib/android/basefs_allocator.c
@@ -55,7 +55,7 @@ errcode_t base_fs_alloc_load(ext2_filsys fs, const char *file,
 	allocator->cur_entry = NULL;
 	allocator->entries = entries;
 
-	/* Overhide the default allocator */
+	/* Override the default allocator */
 	fs->get_alloc_block2 = basefs_block_allocator;
 	fs->priv_data = allocator;
 
diff --git a/debian/rules b/debian/rules
index 81eafc31..94fe7069 100755
--- a/debian/rules
+++ b/debian/rules
@@ -304,7 +304,7 @@ install: cleanup install-std
 
 # This rule allows to factorize the dh_clean between the 2 install rules
 # This must be launched before install-* (if launching them by hand, for
-# exemple) or results are unpredictable
+# example) or results are unpredictable
 cleanup:
 	dh_testdir
 	dh_testroot
diff --git a/debian/uuid-dev.README.Debian b/debian/uuid-dev.README.Debian
index 3d8cc89c..a4f047e3 100644
--- a/debian/uuid-dev.README.Debian
+++ b/debian/uuid-dev.README.Debian
@@ -1,5 +1,5 @@
 
-In order to santize e2fsprogs to be DFSG free, the file
+In order to sanitize e2fsprogs to be DFSG free, the file
 draft-leach-uuids-guids-01.txt has been removed.  It can be obtained
 by downloading e2fsprogs from the upstream sources.  It may also be
 available from other sites on the network, if you do a quick web
@@ -16,7 +16,7 @@ the documentation which has been removed for Debian's DFSG license
 purity shouldn't be denied to Ubuntu users.
 
 					Theodore Ts'o
-					Ocotober 3, 2006
+					October 3, 2006
 
 
 
diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 408a3236..57940cde 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -46,7 +46,7 @@ STATIC_DEPLIBS= $(STATIC_LIBEXT2FS) $(DEPSTATIC_LIBSS) \
 		$(DEPSTATIC_LIBCOM_ERR) $(DEPSTATIC_LIBUUID) \
 		$(DEPSTATIC_LIBE2P)
 
-# This nastyness is needed because of jfs_user.h hackery; when we finally
+# This nastiness is needed because of jfs_user.h hackery; when we finally
 # clean up this mess, we should be able to drop it
 LOCAL_CFLAGS = -I$(srcdir)/../e2fsck -DDEBUGFS
 DEPEND_CFLAGS = -I$(srcdir)
diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 6ff5ad1f..864f234c 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -1,7 +1,7 @@
 /*
  * logdump.c --- dump the contents of the journal out to a file
  *
- * Authro: Stephen C. Tweedie, 2001  <sct@redhat.com>
+ * Author: Stephen C. Tweedie, 2001  <sct@redhat.com>
  * Copyright (C) 2001 Red Hat, Inc.
  * Based on portions  Copyright (C) 1994 Theodore Ts'o.
  *
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ca688622..8dfbba9c 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -429,7 +429,7 @@ static struct field_set_info *find_field(struct field_set_info *fields,
 
 /*
  * Note: info->size == 6 is special; this means a base size 4 bytes,
- * and secondiory (high) size of 2 bytes.  This is needed for the
+ * and secondary (high) size of 2 bytes.  This is needed for the
  * special case of i_blocks_high and i_file_acl_high.
  */
 static errcode_t parse_uint(struct field_set_info *info, char *field,
diff --git a/debugfs/util.c b/debugfs/util.c
index 5f101f48..452de749 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -210,7 +210,7 @@ char *time_to_string(__s64 cl)
 	const char	*tz;
 
 	if (do_gmt == -1) {
-		/* The diet libc doesn't respect the TZ environemnt variable */
+		/* The diet libc doesn't respect the TZ environment variable */
 		tz = ss_safe_getenv("TZ");
 		if (!tz)
 			tz = "";
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 0d47a3a4..727f71d5 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -224,7 +224,7 @@ static void print_time(FILE *f, time_t t)
 	static int		do_gmt = -1;
 
 #ifdef __dietlibc__
-		/* The diet libc doesn't respect the TZ environemnt variable */
+		/* The diet libc doesn't respect the TZ environment variable */
 		if (do_gmt == -1) {
 			time_str = getenv("TZ");
 			if (!time_str)
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index f7593ff0..5015d938 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -30,7 +30,7 @@
  *
  * Pass 1 is designed to stash away enough information so that the
  * other passes should not need to read in the inode information
- * during the normal course of a filesystem check.  (Althogh if an
+ * during the normal course of a filesystem check.  (Although if an
  * inconsistency is detected, other passes may need to read in an
  * inode to fix it.)
  *
@@ -1688,7 +1688,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			/*
 			 * Make sure the root inode is a directory; if
 			 * not, offer to clear it.  It will be
-			 * regnerated in pass #3.
+			 * regenerated in pass #3.
 			 */
 			if (!LINUX_S_ISDIR(inode->i_mode)) {
 				if (fix_problem(ctx, PR_1_ROOT_NO_DIR, &pctx))
@@ -4156,7 +4156,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 }
 
 /*
- * Thes subroutines short circuits ext2fs_get_blocks and
+ * These subroutines short circuits ext2fs_get_blocks and
  * ext2fs_check_directory; we use them since we already have the inode
  * structure, so there's no point in letting the ext2fs library read
  * the inode again.
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index d22cffd3..392ff2c6 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -919,7 +919,7 @@ static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
 					sizeof(dp->inode), "clone file EA");
 		/*
 		 * If we cloned the EA block, find all other inodes
-		 * which refered to that EA block, and modify
+		 * which referred to that EA block, and modify
 		 * them to point to the new EA block.
 		 */
 		n = dict_lookup(&clstr_dict,
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 09b79c3b..09c16179 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1635,7 +1635,7 @@ static int deallocate_inode_block(ext2_filsys fs,
 }
 
 /*
- * This fuction deallocates an inode
+ * This function deallocates an inode
  */
 static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 {
@@ -1705,7 +1705,7 @@ clear_inode:
 }
 
 /*
- * This fuction clears the htree flag on an inode
+ * This function clears the htree flag on an inode
  */
 static void clear_htree(e2fsck_t ctx, ext2_ino_t ino)
 {
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 4d9430bb..6a975b36 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -15,7 +15,7 @@
  * not, e2fsck will offer to create a new one.  It is then marked as
  * "done".
  *
- * Then, pass3 interates over all directory inodes; for each directory
+ * Then, pass3 iterates over all directory inodes; for each directory
  * it attempts to trace up the filesystem tree, using dirinfo.parent
  * until it reaches a directory which has been marked "done".  If it
  * can not do so, then the directory must be disconnected, and e2fsck
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index ab736496..7803e8b8 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -300,7 +300,7 @@ static void print_bitmap_problem(e2fsck_t ctx, problem_t problem,
 	pctx->ino = pctx->ino2 = 0;
 }
 
-/* Just to be more succint */
+/* Just to be more succinct */
 #define B2C(x)	EXT2FS_B2C(fs, (x))
 #define EQ_CLSTR(x, y) (B2C(x) == B2C(y))
 #define LE_CLSTR(x, y) (B2C(x) <= B2C(y))
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2bb8d4e2..edc9d51f 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -174,7 +174,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Corruption found in @S.  (%s = %N).\n"),
 	  PROMPT_NONE, PR_AFTER_CODE, PR_0_SB_CORRUPT },
 
-	/* Error determing physical device size of filesystem */
+	/* Error determining physical device size of filesystem */
 	{ PR_0_GETSIZE_ERROR,
 	  N_("Error determining size of the physical @v: %m\n"),
 	  PROMPT_NONE, PR_FATAL },
@@ -1328,7 +1328,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@E has @D/unused @i %Di.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
-	/* Directry entry is link to '.' */
+	/* Directory entry is link to '.' */
 	{ PR_2_LINK_DOT,
 	  N_("@E @L to '.'  "),
 	  PROMPT_CLEAR, 0 },
@@ -1343,7 +1343,7 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@E @L to @d %P (%Di).\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Directory entry contains a link to the root directry */
+	/* Directory entry contains a link to the root directory */
 	{ PR_2_LINK_ROOT,
 	  N_("@E @L to the @r.\n"),
 	  PROMPT_CLEAR, 0 },
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 49a8c3ad..482d111a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -91,7 +91,7 @@ struct problem_context {
 /* Miscellaneous superblock corruption */
 #define PR_0_MISC_CORRUPT_SUPER			0x00000B
 
-/* Error determing physical device size of filesystem */
+/* Error determining physical device size of filesystem */
 #define PR_0_GETSIZE_ERROR			0x00000C
 
 /* Inode count in the superblock incorrect */
@@ -794,7 +794,7 @@ struct problem_context {
 /* Directory entry has deleted or unused inode */
 #define PR_2_UNUSED_INODE	0x020003
 
-/* Directry entry is link to '.' */
+/* Directory entry is link to '.' */
 #define PR_2_LINK_DOT		0x020004
 
 /* Directory entry points to inode now located in a bad block */
@@ -803,7 +803,7 @@ struct problem_context {
 /* Directory entry contains a link to a directory */
 #define PR_2_LINK_DIR		0x020006
 
-/* Directory entry contains a link to the root directry */
+/* Directory entry contains a link to the root directory */
 #define PR_2_LINK_ROOT		0x020007
 
 /* Directory entry has illegal characters in its name */
@@ -1093,7 +1093,7 @@ struct problem_context {
 #define PR_3_LPF_ENCRYPTED		0x03001B
 
 /*
- * Pass 3a --- rehashing diretories
+ * Pass 3a --- rehashing directories
  */
 /* Pass 3a: Reindexing directories */
 #define PR_3A_PASS_HEADER		0x031000
@@ -1210,7 +1210,7 @@ struct problem_context {
 /* Inode range not used, but marked in bitmap */
 #define PR_5_INODE_RANGE_UNUSED		0x050016
 
-/* Inode rangeused, but not marked used in bitmap */
+/* Inode range used, but not marked used in bitmap */
 #define PR_5_INODE_RANGE_USED		0x050017
 
 /* Block in use but group is marked BLOCK_UNINIT */
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index 4c457b39..81110e4d 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -325,7 +325,7 @@ int journal_recover(journal_t *journal)
  * Locate any valid recovery information from the journal and set up the
  * journal structures in memory to ignore it (presumably because the
  * caller has evidence that it is out of date).
- * This function does'nt appear to be exorted..
+ * This function doesn't appear to be exported..
  *
  * We perform one pass over the journal to allow us to tell the user how
  * much recovery information is being erased, and to let us initialise
@@ -689,7 +689,7 @@ static int do_one_pass(journal_t *journal,
 			 *		| GO TO NEXT    "Journal Corruption"
 			 *		| TRANSACTION
 			 *		|
-			 * {(n+1)th transanction}
+			 * {(n+1)th transaction}
 			 *		|
 			 * 	 _______|______________
 			 * 	|	 	      |
diff --git a/e2fsck/region.c b/e2fsck/region.c
index 95d23be4..d5b37df8 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -84,7 +84,7 @@ int region_allocate(region_t region, region_addr_t start, int n)
 
 	/*
 	 * Search through the linked list.  If we find that it
-	 * conflicts witih something that's already allocated, return
+	 * conflicts with something that's already allocated, return
 	 * 1; if we can find an existing region which we can grow, do
 	 * so.  Otherwise, stop when we find the appropriate place
 	 * insert a new region element into the linked list.
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 939862f1..b46dcb2d 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1214,7 +1214,7 @@ static errcode_t e2fsck_check_mmp(ext2_filsys fs, e2fsck_t ctx)
 	if (retval)
 		goto check_error;
 
-	/* Print warning if e2fck will wait for more than 20 secs. */
+	/* Print warning if e2fsck will wait for more than 20 secs. */
 	if (verbose || wait_time > EXT4_MMP_MIN_CHECK_INTERVAL * 4) {
 		log_out(ctx, _("MMP interval is %u seconds and total wait "
 			       "time is %u seconds. Please wait...\n"),
diff --git a/e2fsck/util.c b/e2fsck/util.c
index a297e58f..ed947025 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -735,7 +735,7 @@ int check_for_modules(const char *fs_name)
 
 /*
  * Helper function that does the right thing if write returns a
- * partial write, or an EGAIN/EINTR error.
+ * partial write, or an EAGAIN/EINTR error.
  */
 int write_all(int fd, char *buf, size_t count)
 {
diff --git a/ext2ed/README b/ext2ed/README
index fda4b87c..1f473cf4 100644
--- a/ext2ed/README
+++ b/ext2ed/README
@@ -48,10 +48,10 @@ This is version 0.2 of ext2ed - The extended-2 filesystem editor.
 Modifications on Apr 5 2001
 This is minor bug fixes to ext2ed, as of April 2001.
 It supports modern ext2 version that has file type in directory structure
-and fixes the missunderstanding between ncurses and
+and fixes the misunderstanding between ncurses and
 readline.
 
-I first applied patches from Redhat except the one for readline that 
+I first applied patches from Red Hat except the one for readline that 
 rewrote a readline behavior.
 
 Globals diffs between version 0.1 and 0.2 is stored in file :
@@ -114,7 +114,7 @@ that ncurses will be properly installed on your system:
 	set your TERM environment variable to 'linux' or link
 	l/linux to c/console in the terminfo database.
 
-4.	The percompiled binary was linked with ncurses 1.9.4 and will search
+4.	The precompiled binary was linked with ncurses 1.9.4 and will search
 	for the terminfo database on /usr/local/lib/terminfo. If you are
 	using it, and your 1.9.4 compatible terminfo database is not on the
 	directory above, use the TERMINFO environment variable to specify
diff --git a/ext2ed/dir_com.c b/ext2ed/dir_com.c
index ba852676..67bb4b57 100644
--- a/ext2ed/dir_com.c
+++ b/ext2ed/dir_com.c
@@ -539,7 +539,7 @@ void type_dir___remember (char *command_line)
 
 /*
 
-This is overrided here because we don't remember a directory - It is too complicated. Instead, we remember the
+This is overridden here because we don't remember a directory - It is too complicated. Instead, we remember the
 inode of the current directory.
 
 */
diff --git a/ext2ed/disk.c b/ext2ed/disk.c
index 70ece943..4612d00d 100644
--- a/ext2ed/disk.c
+++ b/ext2ed/disk.c
@@ -14,7 +14,7 @@ double check the various permissions and possible errors here.
 The major update which needs to be done here is switching to the use of the llseek system call, so that we will
 be able to support ext2 filesystems up to 4 TB. Currently, due to the standard fseek usage, we can't handle
 filesystems bigger than 4 GB. The limit is actually 2 GB because I used long rather than unsigned long long at too
-many places in the program. To conclude - This upgrade needs to be done carefuly; There are many places to change.
+many places in the program. To conclude - This upgrade needs to be done carefully; There are many places to change.
 
 First written on: April 9 1995
 
diff --git a/ext2ed/ext2ed.conf.in b/ext2ed/ext2ed.conf.in
index 7e2a9255..c0796234 100644
--- a/ext2ed/ext2ed.conf.in
+++ b/ext2ed/ext2ed.conf.in
@@ -52,8 +52,8 @@ AllowMountedRead	on
 
 # When ForceExt2 is set to on, the filesystem is assumed to be ext2
 # filesystem, despite the possibly corrupt superblock magic number reading.
-# All the ext2 specific commands will be aviable despite the possible
-# autodetection failture.
+# All the ext2 specific commands will be available despite the possible
+# autodetection failure.
 
 ForceExt2		off
 
diff --git a/ext2ed/ext2ed.h b/ext2ed/ext2ed.h
index b9b43b47..0ac77b7a 100644
--- a/ext2ed/ext2ed.h
+++ b/ext2ed/ext2ed.h
@@ -249,7 +249,7 @@ void signal_SIGSEGV_handler (int sig_num);
 
 /* general_com.c */
 
-/* General commands which are aviable always */
+/* General commands which are available always */
 
 extern void help (char *command_line);
 extern void set (char *command_line);
@@ -275,7 +275,7 @@ void detailed_help (char *text);
 
 /* ext2_com.c */
 
-/* Extended2 filesystem genereal commands - Aviable only when editing an
+/* Extended2 filesystem general commands - Available only when editing an
    ext2 filesystem */
 
 extern void type_ext2___super (char *command_line);
diff --git a/ext2ed/init.c b/ext2ed/init.c
index 718c0d08..4e584317 100644
--- a/ext2ed/init.c
+++ b/ext2ed/init.c
@@ -57,7 +57,7 @@ int init (void)
 
 	general_commands.last_command=-1;	/* No commands whatsoever meanwhile */
 	ext2_commands.last_command=-1;
-	add_general_commands ();		/* Add the general commands, aviable always */
+	add_general_commands ();		/* Add the general commands, available always */
 	device_handle=NULL;			/* Notice that our device is still not set up */
 	device_offset=-1;
 	current_type=NULL;			/* No filesystem specific types yet */
diff --git a/ext2ed/main.c b/ext2ed/main.c
index 4a29979b..f7e7d7df 100644
--- a/ext2ed/main.c
+++ b/ext2ed/main.c
@@ -14,7 +14,7 @@ This file mostly contains:
 2.	The parser, which asks the command line from the user.
 3.	The dispatcher, which analyzes the command line and calls the appropriate handler function.
 4.	A command pattern matcher which is used along with the readline completion feature.
-5.	A function which tells the user that an internal error has occured.
+5.	A function which tells the user that an internal error has occurred.
 
 First written on: March 30 1995
 
@@ -57,7 +57,7 @@ They are initialized below to some logical defaults.
 char Ext2Descriptors [200]="ext2.descriptors";	/* The location of the ext2 filesystem object definition */
 char AlternateDescriptors [200]="";		/* We allow the user to define additional structures */
 char LogFile [200]="ext2ed.log";		/* The location of the log file - Each write will be logged there */
-int LogChanges=1;				/* 1 enables logging, 0 diables logging */
+int LogChanges=1;				/* 1 enables logging, 0 disables logging */
 int AllowChanges=0;				/* When set, the enablewrite command will fail */
 int AllowMountedRead=0;				/* Behavior when trying to open a mounted filesystem read-only */
 int ForceExt2=0;				/* When set, ext2 autodetection is overridden */
@@ -334,7 +334,7 @@ void parser (void)
 
 
 /*
- * This is a very important function. Its task is to recieve a command
+ * This is a very important function. Its task is to receive a command
  * name and link it to a C function.  There are three types of commands:
  *
  * 1.	General commands - Always available and accessed through
@@ -354,7 +354,7 @@ void parser (void)
  *
  * When an handling function is found, it is called along with the
  * command line that was passed to us. The handling function is then
- * free to interpert the arguments in its own style.
+ * free to interpret the arguments in its own style.
  */
 int dispatch (char *command_line)
 {
@@ -480,7 +480,7 @@ char *complete_command (char *text,int state)
 			}
 		}
 
-	/* No, pehaps ext2 specific command then ? */
+	/* No, perhaps ext2 specific command then ? */
 
 	for (i=0;i<=ext2_commands.last_command;i++) {
 		if (strncmp (ext2_commands.names [i],text,len)==0) {
diff --git a/intl/dcigettext.c b/intl/dcigettext.c
index 79678cf8..f5a99b50 100644
--- a/intl/dcigettext.c
+++ b/intl/dcigettext.c
@@ -602,7 +602,7 @@ DCIGETTEXT (const char *domainname, const char *msgid1, const char *msgid2,
 	  /* When this is a SUID binary we must not allow accessing files
 	     outside the dedicated directories.  */
 	  if (ENABLE_SECURE && IS_PATH_WITH_DIR (single_locale))
-	    /* Ingore this entry.  */
+	    /* Ignore this entry.  */
 	    continue;
 	}
 
diff --git a/intl/l10nflist.c b/intl/l10nflist.c
index 3393ecb5..c13d36da 100644
--- a/intl/l10nflist.c
+++ b/intl/l10nflist.c
@@ -242,7 +242,7 @@ _nl_make_l10nflist (struct loaded_l10nfile **l10nfile_list,
     }
   if ((mask & (XPG_MODIFIER | CEN_AUDIENCE)) != 0)
     {
-      /* This component can be part of both syntaces but has different
+      /* This component can be part of both syntaxes but has different
 	 leading characters.  For CEN we use `+', else `@'.  */
       *cp++ = (mask & CEN_AUDIENCE) != 0 ? '+' : '@';
       cp = stpcpy (cp, modifier);
diff --git a/intl/libgettext.h b/intl/libgettext.h
index 3a92960a..c069fbd5 100644
--- a/intl/libgettext.h
+++ b/intl/libgettext.h
@@ -84,7 +84,7 @@ extern int _msg_tbl_length;
 #endif
 
 
-/* For automatical extraction of messages sometimes no real
+/* For automatic extraction of messages sometimes no real
    translation is needed.  Instead the string itself is the result.  */
 #define gettext_noop(Str) (Str)
 
diff --git a/intl/xsize.h b/intl/xsize.h
index 362e24b7..e3707fa1 100644
--- a/intl/xsize.h
+++ b/intl/xsize.h
@@ -95,7 +95,7 @@ xmax (size_t size1, size_t size2)
 /* Multiplication of a count with an element size, with overflow check.
    The count must be >= 0 and the element size must be > 0.
    This is a macro, not an inline function, so that it works correctly even
-   when N is of a wider tupe and N > SIZE_MAX.  */
+   when N is of a wider type and N > SIZE_MAX.  */
 #define xtimes(N, ELSIZE) \
   ((N) <= SIZE_MAX / (ELSIZE) ? (size_t) (N) * (ELSIZE) : SIZE_MAX)
 
diff --git a/lib/blkid/dev.c b/lib/blkid/dev.c
index 6d8eaeac..d35513e4 100644
--- a/lib/blkid/dev.c
+++ b/lib/blkid/dev.c
@@ -91,7 +91,7 @@ void blkid_debug_dump_dev(blkid_dev dev)
  *
  * These routines do not expose the list.h implementation, which are a
  * contamination of the namespace, and which force us to reveal far, far
- * too much of our internal implemenation.  I'm not convinced I want
+ * too much of our internal implementation.  I'm not convinced I want
  * to keep list.h in the long term, anyway.  It's fine for kernel
  * programming, but performance is not the #1 priority for this
  * library, and I really don't like the tradeoff of type-safety for
diff --git a/lib/blkid/probe.h b/lib/blkid/probe.h
index c46a3325..dea4081d 100644
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -663,7 +663,7 @@ struct btrfs_dev_item {
 
 	/*
 	 * starting byte of this partition on the device,
-	 * to allowr for stripe alignment in the future
+	 * to allow for stripe alignment in the future
 	 */
 	__u64 start_offset;
 
diff --git a/lib/blkid/tag.c b/lib/blkid/tag.c
index 1eae7df7..e88ebc46 100644
--- a/lib/blkid/tag.c
+++ b/lib/blkid/tag.c
@@ -261,7 +261,7 @@ errout:
  *
  * These routines do not expose the list.h implementation, which are a
  * contamination of the namespace, and which force us to reveal far, far
- * too much of our internal implemenation.  I'm not convinced I want
+ * too much of our internal implementation.  I'm not convinced I want
  * to keep list.h in the long term, anyway.  It's fine for kernel
  * programming, but performance is not the #1 priority for this
  * library, and I really don't like the tradeoff of type-safety for
diff --git a/lib/et/com_right.c b/lib/et/com_right.c
index 2cceb54c..a4ed5354 100644
--- a/lib/et/com_right.c
+++ b/lib/et/com_right.c
@@ -1,6 +1,6 @@
 /*
  * com_right.c -- provide Heimdall / Kerberos4kth com_err interfaces
- * 	for backwards compatbility
+ * 	for backwards compatibility
  *
  * Copyright (c) 2003 by Theodore Ts'o
  *
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index b729f619..946cae16 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -5,7 +5,7 @@ top_builddir = ../..
 my_dir = lib/ext2fs
 INSTALL = @INSTALL@
 DEPEND_CFLAGS = -I$(top_srcdir)/debugfs -I$(srcdir)/../../e2fsck -DDEBUGFS
-# This nastyness is needed because of jfs_user.h hackery; when we finally
+# This nastiness is needed because of jfs_user.h hackery; when we finally
 # clean up this mess, we should be able to drop it
 DEBUGFS_CFLAGS = -I$(srcdir)/../../e2fsck $(ALL_CFLAGS) -DDEBUGFS
 
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index da0b15bf..6261c42a 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -33,7 +33,7 @@
  * This routine searches for free blocks that can allocate a full
  * group of bitmaps or inode tables for a flexbg group.  Returns the
  * block number with a correct offset were the bitmaps and inode
- * tables can be allocated continously and in order.
+ * tables can be allocated continuously and in order.
  */
 static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk64_t start_blk,
 			     ext2fs_block_bitmap bmap, int rem_grp,
diff --git a/lib/ext2fs/bb_inode.c b/lib/ext2fs/bb_inode.c
index b0e114bb..11f10ebc 100644
--- a/lib/ext2fs/bb_inode.c
+++ b/lib/ext2fs/bb_inode.c
@@ -96,7 +96,7 @@ errcode_t ext2fs_update_bb_inode(ext2_filsys fs, ext2_badblocks_list bb_list)
 	 * Now set the bad blocks!
 	 *
 	 * First, mark the bad blocks as used.  This prevents a bad
-	 * block from being used as an indirecto block for the bad
+	 * block from being used as an indirect block for the bad
 	 * block inode (!).
 	 */
 	if (bb_list) {
diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 833d1e97..c4a1d4e0 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -24,7 +24,7 @@
 /*
  * For the benefit of those who are trying to port Linux to another
  * architecture, here are some C-language equivalents.  You should
- * recode these in the native assmebly language, if at all possible.
+ * recode these in the native assembly language, if at all possible.
  *
  * C language equivalents written by Theodore Ts'o, 9/26/92.
  * Modified by Pete A. Zaitcev 7/14/95 to be portable to big endian
diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 8d5ddd3f..55704774 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -555,7 +555,7 @@ static int rb_remove_extent(__u64 start, __u64 count,
 			retval = 1;
 			continue;
 		} else {
-			/* modify the last extent in reigon to be removed */
+			/* modify the last extent in region to be removed */
 			ext->count -= ((start + count) - ext->start);
 			ext->start = start + count;
 			retval = 1;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3b55000e..2496d16d 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -970,7 +970,7 @@ struct ext2_dir_entry {
  * bigger than 255 chars, it's safe to reclaim the extra byte for the
  * file_type field.
  *
- * This structure is deprecated due to endianity issues. Please use struct
+ * This structure is deprecated due to endian issues. Please use struct
  * ext2_dir_entry and accessor functions
  *   ext2fs_dirent_name_len
  *   ext2fs_dirent_set_name_len
@@ -1048,7 +1048,7 @@ struct ext2_dir_entry_tail {
  * regardless of how old the timestamp is.
  *
  * The timestamp in the MMP structure will be updated by e2fsck at some
- * arbitary intervals (start of passes, after every few groups of inodes
+ * arbitrary intervals (start of passes, after every few groups of inodes
  * in pass1 and pass1b).  There is no guarantee that e2fsck is updating
  * the MMP block in a timely manner, and the updates it does are purely
  * for the convenience of the sysadmin and not for automatic validation.
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index a4feaccc..6774e32c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -329,7 +329,7 @@ struct struct_ext2_filsys {
  *
  * BLOCK_FLAG_DEPTH_TRAVERSE indicates that the iterator function for
  * the indirect, doubly indirect, etc. blocks should be called after
- * all of the blocks containined in the indirect blocks are processed.
+ * all of the blocks contained in the indirect blocks are processed.
  * This is useful if you are going to be deallocating blocks from an
  * inode.
  *
@@ -423,7 +423,7 @@ typedef struct ext2_extent_path *ext2_extent_path_t;
 /*
  * Flags used by ext2fs_extent_delete()
  */
-#define EXT2_EXTENT_DELETE_KEEP_EMPTY	0x001 /* keep node if last extnt gone */
+#define EXT2_EXTENT_DELETE_KEEP_EMPTY	0x001 /* keep node if last extent gone */
 
 /*
  * Flags used by ext2fs_extent_set_bmap()
diff --git a/lib/ext2fs/ext3_extents.h b/lib/ext2fs/ext3_extents.h
index f73a3321..309fbc8c 100644
--- a/lib/ext2fs/ext3_extents.h
+++ b/lib/ext2fs/ext3_extents.h
@@ -59,7 +59,7 @@ struct ext3_extent_header {
 	__le16	eh_magic;	/* probably will support different formats */
 	__le16	eh_entries;	/* number of valid entries */
 	__le16	eh_max;		/* capacity of store in entries */
-	__le16	eh_depth;	/* has tree real underlaying blocks? */
+	__le16	eh_depth;	/* has tree real underlying blocks? */
 	__le32	eh_generation;	/* generation of the tree */
 };
 
diff --git a/lib/ext2fs/get_pathname.c b/lib/ext2fs/get_pathname.c
index 4c9c7655..8cfaf6e6 100644
--- a/lib/ext2fs/get_pathname.c
+++ b/lib/ext2fs/get_pathname.c
@@ -1,5 +1,5 @@
 /*
- * get_pathname.c --- do directry/inode -> name translation
+ * get_pathname.c --- do directory/inode -> name translation
  *
  * Copyright (C) 1993, 1994, 1995 Theodore Ts'o.
  *
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 53016fdb..7215c517 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -311,7 +311,7 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	dir->name[1] = '.';
 
 	/*
-	 * Ajust the last rec_len
+	 * Adjust the last rec_len
 	 */
 	offset = EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2);
 	dir = (struct ext2_dir_entry *) (bbuf + offset);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 8dc9ac0d..ad01a9fc 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -151,7 +151,7 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	 */
 	if (fs->badblocks == 0) {
 		/*
-		 * Temporarly save fs->get_blocks and set it to zero,
+		 * Temporarily save fs->get_blocks and set it to zero,
 		 * for compatibility with old e2fsck's.
 		 */
 		save_get_blocks = fs->get_blocks;
diff --git a/lib/ext2fs/nt_io.c b/lib/ext2fs/nt_io.c
index f0d16ae0..234f6b17 100644
--- a/lib/ext2fs/nt_io.c
+++ b/lib/ext2fs/nt_io.c
@@ -378,7 +378,7 @@ _MapNtStatus(
 
 
 //
-// Helper functions to make things easyer
+// Helper functions to make things easier
 //
 
 static
@@ -398,7 +398,7 @@ _OpenNtName(
 	IO_STATUS_BLOCK IoStatusBlock;
 
 	//
-	// Make Unicode name from inlut string
+	// Make Unicode name from input string
 	//
 
 	UnicodeString.Buffer = &Buffer[0];
@@ -411,7 +411,7 @@ _OpenNtName(
 
 	if(!NT_SUCCESS(Status))
 	{
-		return Status; // Unpappable character?
+		return Status; // Unmappable character?
 	}
 
 	//
@@ -673,7 +673,7 @@ _NormalizeDeviceName(
 	else if('f' == *Device)
 	{
 		//
-		// 3-d letted should be a digit.
+		// 3-d letter should be a digit.
 		//
 
 		if((*(Device + 3) != '\0') ||
diff --git a/lib/ext2fs/rbtree.h b/lib/ext2fs/rbtree.h
index b767a90b..1973b820 100644
--- a/lib/ext2fs/rbtree.h
+++ b/lib/ext2fs/rbtree.h
@@ -19,7 +19,7 @@
   linux/include/linux/rbtree.h
 
   To use rbtrees you'll have to implement your own insert and search cores.
-  This will avoid us to use callbacks and to drop drammatically performances.
+  This will avoid us to use callbacks and to drop dramatically performances.
   I know it's not the cleaner way,  but in C (not in C++) to get
   performances and genericity...
 
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index eaa9cf87..45a475d9 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -104,7 +104,7 @@ errcode_t ext2fs_create_resize_inode(ext2_filsys fs)
 	if (fs->blocksize == 1024 && sb_blk == 0)
 		sb_blk = 1;
 
-	/* Maximum possible file size (we donly use the dindirect blocks) */
+	/* Maximum possible file size (we only use the indirect blocks) */
 	apb = EXT2_ADDR_PER_BLOCK(sb);
 	if ((dindir_blk = inode.i_block[EXT2_DIND_BLOCK])) {
 #ifdef RES_GDT_DEBUG
diff --git a/lib/ext2fs/tdb.c b/lib/ext2fs/tdb.c
index b36c4858..9c1dd31d 100644
--- a/lib/ext2fs/tdb.c
+++ b/lib/ext2fs/tdb.c
@@ -712,7 +712,7 @@ int tdb_lockall_unmark(struct tdb_context *tdb)
 	return _tdb_unlockall(tdb, F_WRLCK | TDB_MARK_LOCK);
 }
 
-/* lock entire database with write lock - nonblocking varient */
+/* lock entire database with write lock - nonblocking variant */
 int tdb_lockall_nonblock(struct tdb_context *tdb)
 {
 	return _tdb_lockall(tdb, F_WRLCK, F_SETLK);
@@ -730,7 +730,7 @@ int tdb_lockall_read(struct tdb_context *tdb)
 	return _tdb_lockall(tdb, F_RDLCK, F_SETLKW);
 }
 
-/* lock entire database with read lock - nonblock varient */
+/* lock entire database with read lock - nonblock variant */
 int tdb_lockall_read_nonblock(struct tdb_context *tdb)
 {
 	return _tdb_lockall(tdb, F_RDLCK, F_SETLK);
@@ -1276,7 +1276,7 @@ void tdb_io_init(struct tdb_context *tdb)
     although once a transaction is started then an exclusive lock is
     gained until the transaction is committed or cancelled
 
-  - the commit stategy involves first saving away all modified data
+  - the commit strategy involves first saving away all modified data
     into a linearised buffer in the transaction recovery area, then
     marking the transaction recovery area with a magic value to
     indicate a valid recovery record. In total 4 fsync/msync calls are
@@ -2323,7 +2323,7 @@ static int update_tailer(struct tdb_context *tdb, tdb_off_t offset,
 }
 
 /* Add an element into the freelist. Merge adjacent records if
-   neccessary. */
+   necessary. */
 int tdb_free(struct tdb_context *tdb, tdb_off_t offset, struct list_struct *rec)
 {
 	tdb_off_t right, left;
@@ -2674,7 +2674,7 @@ static int tdb_next_lock(struct tdb_context *tdb, struct tdb_traverse_lock *tloc
 			   that we have done at least one fcntl lock at the
 			   start of a search to guarantee that memory is
 			   coherent on SMP systems. If records are added by
-			   others during the search then thats OK, and we
+			   others during the search then that's OK, and we
 			   could possibly miss those with this trick, but we
 			   could miss them anyway without this trick, so the
 			   semantics don't change.
@@ -2762,7 +2762,7 @@ static int tdb_traverse_internal(struct tdb_context *tdb,
 	struct list_struct rec;
 	int ret, count = 0;
 
-	/* This was in the initializaton, above, but the IRIX compiler
+	/* This was in the initialization, above, but the IRIX compiler
 	 * did not like it.  crh
 	 */
 	tl->next = tdb->travlocks.next;
@@ -4051,7 +4051,7 @@ int tdb_close(struct tdb_context *tdb)
 	return ret;
 }
 
-/* register a loging function */
+/* register a logging function */
 void tdb_set_logging_function(struct tdb_context *tdb,
                               const struct tdb_logging_context *log_ctx)
 {
diff --git a/lib/ext2fs/undo_io.c b/lib/ext2fs/undo_io.c
index 776d5b8b..19862414 100644
--- a/lib/ext2fs/undo_io.c
+++ b/lib/ext2fs/undo_io.c
@@ -381,7 +381,7 @@ static errcode_t undo_write_tdb(io_channel channel,
 		 * Read one block using the backing I/O manager
 		 * The backing I/O manager block size may be
 		 * different from the tdb_data_size.
-		 * Also we need to recalcuate the block number with respect
+		 * Also we need to recalculate the block number with respect
 		 * to the backing I/O manager.
 		 */
 		offset = block_num * data->tdb_data_size +
diff --git a/lib/ss/ct_c.sed b/lib/ss/ct_c.sed
index 8d6452be..9e5eebbe 100644
--- a/lib/ss/ct_c.sed
+++ b/lib/ss/ct_c.sed
@@ -25,7 +25,7 @@
 # an awk script to parse.
 
 #
-# The first section of this script is just to cannoicalize the file.  
+# The first section of this script is just to canonicalize the file.  
 # It removes comments, and puts each command_table request onto a single
 # line
 #
@@ -41,7 +41,7 @@ bFIRST
 }
 s/, */, /g
 #
-# Now we take care of some syntatic sugar.....
+# Now we take care of some syntactic sugar.....
 #
 /^unimplemented/ {
 	s/^unimplemented [A-Za-z_0-9]*/request ss_unimplemented/
diff --git a/lib/support/profile.c b/lib/support/profile.c
index ae9a2d9d..9e96673b 100644
--- a/lib/support/profile.c
+++ b/lib/support/profile.c
@@ -1112,7 +1112,7 @@ errcode_t profile_create_node(const char *name, const char *value,
 }
 
 /*
- * This function verifies that all of the representation invarients of
+ * This function verifies that all of the representation invariants of
  * the profile are true.  If not, we have a programming bug somewhere,
  * probably in this file.
  */
diff --git a/lib/support/profile_helpers.c b/lib/support/profile_helpers.c
index b8623268..d7d6f15e 100644
--- a/lib/support/profile_helpers.c
+++ b/lib/support/profile_helpers.c
@@ -179,7 +179,7 @@ cleanup_iterator:
 }
 
 /*
- * This function will return the list of the names of subections in the
+ * This function will return the list of the names of subsections in the
  * under the specified section name.
  */
 errcode_t
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index f89536eb..60689700 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -243,7 +243,7 @@ int parse_quota_types(const char *in_str, unsigned int *qtype_bits,
  * Return pointer to reserved inode field in superblock for given quota type.
  *
  * This allows the caller to get or set the quota inode by type without the
- * need for the quota array to be contiguous in the superbock.
+ * need for the quota array to be contiguous in the superblock.
  */
 static inline ext2_ino_t *quota_sb_inump(struct ext2_super_block *sb,
 					 enum quota_type qtype)
diff --git a/lib/support/quotaio_tree.h b/lib/support/quotaio_tree.h
index 0db0ca1e..b0b7257f 100644
--- a/lib/support/quotaio_tree.h
+++ b/lib/support/quotaio_tree.h
@@ -42,7 +42,7 @@ struct qtree_fmt_operations {
 	int (*is_id)(void *disk, struct dquot *dquot);
 };
 
-/* Inmemory copy of version specific information */
+/* In-memory copy of version specific information */
 struct qtree_mem_dqinfo {
 	unsigned int dqi_blocks;	/* # of blocks in quota file */
 	unsigned int dqi_free_blk;	/* First block in list of free blocks */
diff --git a/lib/uuid/gen_uuid_nt.c b/lib/uuid/gen_uuid_nt.c
index 79a40507..9a9a9775 100644
--- a/lib/uuid/gen_uuid_nt.c
+++ b/lib/uuid/gen_uuid_nt.c
@@ -64,7 +64,7 @@ NtCurrentTeb(void);
 
 //
 // The only way to get version information from the system is to examine
-// one stored in PEB. But it's pretty dangerouse because this value could
+// one stored in PEB. But it's pretty dangerous because this value could
 // be altered in image header.
 //
 
diff --git a/misc/Makefile.in b/misc/Makefile.in
index f696d13a..4bb92ace 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -118,7 +118,7 @@ DEPLIBS_E2P= $(LIBE2P) $(DEPLIBCOM_ERR)
 
 COMPILE_ET=	_ET_DIR_OVERRIDE=$(srcdir)/../lib/et/et ../lib/et/compile_et
 
-# This nastyness is needed because of jfs_user.h hackery; when we finally
+# This nastiness is needed because of jfs_user.h hackery; when we finally
 # clean up this mess, we should be able to drop it
 JOURNAL_CFLAGS = -I$(srcdir)/../e2fsck $(ALL_CFLAGS) -DDEBUGFS
 DEPEND_CFLAGS = -I$(top_srcdir)/e2fsck
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 8f7445d0..2dbb433c 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -33,7 +33,7 @@
 #include "create_inode.h"
 #include "support/nls-enable.h"
 
-/* 64KiB is the minimium blksize to best minimize system call overhead. */
+/* 64KiB is the minimum blksize to best minimize system call overhead. */
 #define COPY_FILE_BUFLEN	65536
 
 static int ext2_file_type(unsigned int mode)
diff --git a/misc/e2image.c b/misc/e2image.c
index 030f9cbe..be001f0f 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1109,7 +1109,7 @@ static int update_refcount(int fd, struct ext2_qcow2_image *img,
 	/*
 	 * We are relying on the fact that we are creating the qcow2
 	 * image sequentially, hence we will always allocate refcount
-	 * block items sequentialy.
+	 * block items sequentially.
 	 */
 	ref->refcount_block[ref->refcount_block_index] = ext2fs_cpu_to_be16(1);
 	ref->refcount_block_index++;
diff --git a/misc/e4crypt.c b/misc/e4crypt.c
index 600d0b7a..7b65d145 100644
--- a/misc/e4crypt.c
+++ b/misc/e4crypt.c
@@ -578,7 +578,7 @@ static void insert_key_into_keyring(const char *keyring, struct salt *salt)
 	 * We need to do this instead of simply adding the key to
 	 * KEY_SPEC_SESSION_KEYRING since trying to add a key to a
 	 * session keyring that does not yet exist will cause the
-	 * kernel to create a session keyring --- which wil then get
+	 * kernel to create a session keyring --- which will then get
 	 * garbage collected as soon as e4crypt exits.
 	 *
 	 * The fact that the keyctl system call and the add_key system
diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 5fa85b66..d63343e9 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1016,7 +1016,7 @@ static int get_best_count(ext4_fsblk_t block_count)
 	int ret;
 	unsigned int flex_bg_num;
 
-	/* Calcuate best extents count */
+	/* Calculate best extents count */
 	if (feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
 		flex_bg_num = 1 << log_groups_per_flex;
 		ret = ((block_count - 1) /
@@ -1580,7 +1580,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	/* Calcuate donor inode's continuous physical region */
+	/* Calculate donor inode's continuous physical region */
 	donor_physical_cnt = get_physical_count(donor_list_physical);
 
 	/* Change donor extent list from physical to logical */
diff --git a/misc/findsuper.c b/misc/findsuper.c
index 47aa43af..ff20b988 100644
--- a/misc/findsuper.c
+++ b/misc/findsuper.c
@@ -30,7 +30,7 @@
  *   findsuper /dev/hda
  *   findsuper /dev/hda 437760 1024   (my disk has cyls of 855*512)
  *
- * I suppose the next step is to figgure out a way to determine if
+ * I suppose the next step is to figure out a way to determine if
  * the block found is the first superblock somehow, and if so, build
  * a partition table from the superblocks found... but this is still
  * useful as is.
@@ -75,7 +75,7 @@
  * For new systems that have a block group number in the superblock it
  * is immediately clear which superblock is the first of a partition.
  * For old systems where no group numbers are given, the first
- * superblock can be recognised by the timestamp: all superblock
+ * superblock can be recognized by the timestamp: all superblock
  * copies have the creation time in s_mtime, except the first, which
  * has the last time e2fsck or tune2fs wrote to the filesystem.
  *
diff --git a/misc/fsck.c b/misc/fsck.c
index 7c93ee82..de5ae256 100644
--- a/misc/fsck.c
+++ b/misc/fsck.c
@@ -997,7 +997,7 @@ static int check_all(NOARGS)
 	}
 	/*
 	 * This is for the bone-headed user who enters the root
-	 * filesystem twice.  Skip root will skep all root entries.
+	 * filesystem twice.  Skip root will skip all root entries.
 	 */
 	if (skip_root)
 		for (fs = filesys_info; fs; fs = fs->next)
diff --git a/misc/fsck.h b/misc/fsck.h
index 8a0f70e3..8a55fbd6 100644
--- a/misc/fsck.h
+++ b/misc/fsck.h
@@ -34,7 +34,7 @@
 #define EXIT_LIBRARY     128
 
 /*
- * Internal structure for mount tabel entries.
+ * Internal structure for mount table entries.
  */
 
 struct fs_info {
diff --git a/misc/logsave.c b/misc/logsave.c
index 6a624dea..96b6d8e0 100644
--- a/misc/logsave.c
+++ b/misc/logsave.c
@@ -52,7 +52,7 @@ static void usage(char *progname)
 
 /*
  * Helper function that does the right thing if write returns a
- * partial write, or an EGAIN/EINTR error.
+ * partial write, or an EAGAIN/EINTR error.
  */
 static int write_all(int fd, const char *buf, size_t count)
 {
diff --git a/misc/tune2fs.h b/misc/tune2fs.h
index 7b7e431e..f31c8322 100644
--- a/misc/tune2fs.h
+++ b/misc/tune2fs.h
@@ -14,8 +14,8 @@
 extern "C" {
 #endif
 
-/* Takes exactly the same args as the tune2fs exectuable.
- * Is the entrypoint for libtune2fs.
+/* Takes exactly the same args as the tune2fs executable.
+ * Is the entry point for libtune2fs.
  */
 int tune2fs_main(int argc, char **argv);
 
diff --git a/resize/extent.c b/resize/extent.c
index ec81b944..e5ca16c0 100644
--- a/resize/extent.c
+++ b/resize/extent.c
@@ -8,7 +8,7 @@
  * Copyright (C) 1997, 1998 by Theodore Ts'o and
  * 	PowerQuest, Inc.
  *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
diff --git a/resize/main.c b/resize/main.c
index ab7375c1..ba6bb6b1 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -422,7 +422,7 @@ int main (int argc, char ** argv)
 	 * unless the user is forcing it.
 	 *
 	 * We do ERROR and VALID checks even if we're only printing the
-	 * minimimum size, because traversal of a badly damaged filesystem
+	 * minimum size, because traversal of a badly damaged filesystem
 	 * can cause issues as well.  We don't require it to be fscked after
 	 * the last mount time in this case, though, as this is a bit less
 	 * risky.
diff --git a/resize/online.c b/resize/online.c
index 9a4d828c..f0c214b1 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -201,7 +201,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	}
 
 	/* The current method of adding one block group at a time to a
-	 * mounted filesystem means it is impossible to accomodate the
+	 * mounted filesystem means it is impossible to accommodate the
 	 * flex_bg allocation method of placing the metadata together
 	 * in a single block group.  For now we "fix" this issue by
 	 * using the traditional layout for new block groups, where
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 20a0c463..b53141a2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1997, 1998 by Theodore Ts'o and
  * 	PowerQuest, Inc.
  *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
@@ -80,7 +80,7 @@ static int is_inode_tb(ext2_filsys fs, unsigned int grp, blk64_t blk)
 		      fs->inode_blocks_per_group);
 }
 
-/* Some bigalloc helper macros which are more succint... */
+/* Some bigalloc helper macros which are more succinct... */
 #define B2C(x)	EXT2FS_B2C(fs, (x))
 #define C2B(x)	EXT2FS_C2B(fs, (x))
 #define EQ_CLSTR(x, y) (B2C(x) == B2C(y))
@@ -578,7 +578,7 @@ out:
 }
 
 /*
- * Clean up the bitmaps for unitialized bitmaps
+ * Clean up the bitmaps for uninitialized bitmaps
  */
 static void fix_uninit_block_bitmaps(ext2_filsys fs)
 {
@@ -932,7 +932,7 @@ retry:
 	/*
 	 * If we changed the number of block_group descriptor blocks,
 	 * we need to make sure they are all marked as reserved in the
-	 * file systems's block allocation map.
+	 * file systems' block allocation map.
 	 */
 	for (i = 0; i < old_fs->group_desc_count; i++)
 		ext2fs_reserve_super_and_bgd(fs, i, fs->block_map);
@@ -1503,7 +1503,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 
 		/*
 		 * For those structures that have changed, we need to
-		 * do bookkeepping.
+		 * do bookkeeping.
 		 */
 		if (ext2fs_block_bitmap_loc(old_fs, i) !=
 		    (blk = ext2fs_block_bitmap_loc(fs, i))) {
@@ -2939,7 +2939,7 @@ static int calc_group_overhead(ext2_filsys fs, blk64_t grp,
 
 
 /*
- * calcluate the minimum number of blocks the given fs can be resized to
+ * calculate the minimum number of blocks the given fs can be resized to
  */
 blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 {
@@ -3032,7 +3032,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 #endif
 
 	/*
-	 * if we need more group descriptors in order to accomodate our data
+	 * if we need more group descriptors in order to accommodate our data
 	 * then we need to add them here
 	 */
 	blks_needed = data_needed;
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 829fcd8e..f9f58f20 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -4,7 +4,7 @@
  * Copyright (C) 1997, 1998 by Theodore Ts'o and
  * 	PowerQuest, Inc.
  *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
diff --git a/resize/sim_progress.c b/resize/sim_progress.c
index d4206ba2..321becdf 100644
--- a/resize/sim_progress.c
+++ b/resize/sim_progress.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1997, 1998 by Theodore Ts'o and
  * 	PowerQuest, Inc.
  *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
diff --git a/resize/test_extent.c b/resize/test_extent.c
index 60aa08f3..5e9aed79 100644
--- a/resize/test_extent.c
+++ b/resize/test_extent.c
@@ -4,7 +4,7 @@
  * Copyright (C) 1997, 1998 by Theodore Ts'o and
  * 	PowerQuest, Inc.
  *
- * Copyright (C) 1999, 2000 by Theosore Ts'o
+ * Copyright (C) 1999, 2000 by Theodore Ts'o
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Public
diff --git a/util/gen-tarball.in b/util/gen-tarball.in
index a3a02cef..6f087d1a 100644
--- a/util/gen-tarball.in
+++ b/util/gen-tarball.in
@@ -12,7 +12,7 @@ GZIP=gzip
 
 #
 # This hack is needed because texi2dvi blows up horribly if there are 
-# any '~' chracters in the directory pathname.  So we kludge around it by
+# any '~' characters in the directory path name.  So we kludge around it by
 # using a non-standard directory name for WIP releases.  dpkg-source
 # complains, but life goes on.
 #
diff --git a/util/subst.c b/util/subst.c
index e745d863..b37633d2 100644
--- a/util/subst.c
+++ b/util/subst.c
@@ -1,7 +1,7 @@
 /*
  * subst.c --- substitution program
  *
- * Subst is used as a quicky program to do @ substitutions
+ * Subst is used as a quickie program to do @ substitutions
  *
  */
 
diff --git a/util/symlinks.c b/util/symlinks.c
index 600effac..e9d2b011 100644
--- a/util/symlinks.c
+++ b/util/symlinks.c
@@ -126,7 +126,7 @@ static int shorten_path (char *path, char *abspath)
 
 	/* get rid of unnecessary "../dir" sequences */
 	while (abspath && strlen(abspath) > 1 && (p = strstr(path,"../"))) {
-		/* find innermost occurance of "../dir", and save "dir" */
+		/* find innermost occurrence of "../dir", and save "dir" */
 		int slashes = 2;
 		char *a, *s, *d = dir;
 		while ((s = strstr(p+3, "../"))) {
-- 
2.14.2
