From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Remove configure --enable-swapfs and associated support #defines
Date: Sun, 12 Aug 2007 12:57:21 -0400
Message-ID: <11869378423328-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
 <11869378411811-git-send-email-tytso@mit.edu>
 <11869378412404-git-send-email-tytso@mit.edu>
 <11869378412289-git-send-email-tytso@mit.edu>
 <1186937842710-git-send-email-tytso@mit.edu>
 <11869378423190-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141AbXHLQ6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:45 -0400
In-Reply-To: <11869378423190-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This removes the last vestiges of support for the legacy PowerPC
big-endian filesystem format.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 configure              |   33 ++-------------------------------
 configure.in           |   20 --------------------
 debian/rules           |    6 ++----
 lib/ext2fs/Makefile.in |    4 +---
 lib/ext2fs/bitops.h    |   32 +-------------------------------
 lib/ext2fs/ext2fs.h    |    9 ---------
 lib/ext2fs/swapfs.c    |    2 +-
 7 files changed, 7 insertions(+), 99 deletions(-)

diff --git a/configure b/configure
index 5c8448a..ee087b4 100755
--- a/configure
+++ b/configure
@@ -684,7 +684,6 @@ CHECKER_CMT
 LIB_EXT
 STATIC_LIB_EXT
 PROFILED_LIB_EXT
-SWAPFS_CMT
 DEBUGFS_CMT
 IMAGER_CMT
 RESIZER_CMT
@@ -1368,7 +1367,6 @@ Optional Features:
   --enable-jbd-debug  	  enable journal debugging
   --enable-blkid-debug    enable blkid debugging
   --enable-testio-debug   enable the use of the test I/O manager for debugging
-  --disable-swapfs    	  disable support of legacy byte-swapped filesystems
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
   --disable-resizer   	  disable support of e2resize program
@@ -3992,32 +3990,6 @@ else
 
 fi
 
-# Check whether --enable-swapfs was given.
-if test "${enable_swapfs+set}" = set; then
-  enableval=$enable_swapfs; if test "$enableval" = "no"
-then
-	SWAPFS_CMT=#
-	echo "Disabling swapfs support"
-else
-	SWAPFS_CMT=
-	cat >>confdefs.h <<\_ACEOF
-#define ENABLE_SWAPFS 1
-_ACEOF
-
-	echo "Enabling swapfs support"
-fi
-
-else
-  SWAPFS_CMT=
-echo "Enabling swapfs support by default"
-cat >>confdefs.h <<\_ACEOF
-#define ENABLE_SWAPFS 1
-_ACEOF
-
-
-fi
-
-
 # Check whether --enable-debugfs was given.
 if test "${enable_debugfs+set}" = set; then
   enableval=$enable_debugfs; if test "$enableval" = "no"
@@ -15694,11 +15666,11 @@ CHECKER_CMT!$CHECKER_CMT$ac_delim
 LIB_EXT!$LIB_EXT$ac_delim
 STATIC_LIB_EXT!$STATIC_LIB_EXT$ac_delim
 PROFILED_LIB_EXT!$PROFILED_LIB_EXT$ac_delim
-SWAPFS_CMT!$SWAPFS_CMT$ac_delim
 DEBUGFS_CMT!$DEBUGFS_CMT$ac_delim
 IMAGER_CMT!$IMAGER_CMT$ac_delim
 RESIZER_CMT!$RESIZER_CMT$ac_delim
 E2FSCK_TYPE!$E2FSCK_TYPE$ac_delim
+FSCK_PROG!$FSCK_PROG$ac_delim
 _ACEOF
 
   if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 76; then
@@ -15768,7 +15740,6 @@ _ACEOF
 ac_delim='%!_!# '
 for ac_last_try in false false false false false :; do
   cat >conf$$subs.sed <<_ACEOF
-FSCK_PROG!$FSCK_PROG$ac_delim
 FSCK_MAN!$FSCK_MAN$ac_delim
 E2INITRD_PROG!$E2INITRD_PROG$ac_delim
 E2INITRD_MAN!$E2INITRD_MAN$ac_delim
@@ -15851,7 +15822,7 @@ LIBOBJS!$LIBOBJS$ac_delim
 LTLIBOBJS!$LTLIBOBJS$ac_delim
 _ACEOF
 
-  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 81; then
+  if test `sed -n "s/.*$ac_delim\$/X/p" conf$$subs.sed | grep -c X` = 80; then
     break
   elif $ac_last_try; then
     { { echo "$as_me:$LINENO: error: could not make $CONFIG_STATUS" >&5
diff --git a/configure.in b/configure.in
index 011df1a..e434454 100644
--- a/configure.in
+++ b/configure.in
@@ -361,26 +361,6 @@ fi
 echo "Disabling testio debugging by default"
 )
 dnl
-dnl handle --enable-swapfs
-dnl
-AC_ARG_ENABLE([swapfs],
-[  --disable-swapfs    	  disable support of legacy byte-swapped filesystems],
-if test "$enableval" = "no"
-then
-	SWAPFS_CMT=#
-	echo "Disabling swapfs support"
-else
-	SWAPFS_CMT=
-	AC_DEFINE(ENABLE_SWAPFS)
-	echo "Enabling swapfs support"
-fi
-,
-SWAPFS_CMT=
-echo "Enabling swapfs support by default"
-AC_DEFINE(ENABLE_SWAPFS)
-)
-AC_SUBST(SWAPFS_CMT)
-dnl
 dnl handle --enable-debugfs
 dnl
 AC_ARG_ENABLE([debugfs],
diff --git a/debian/rules b/debian/rules
index bb3f1d3..d8411f6 100755
--- a/debian/rules
+++ b/debian/rules
@@ -92,13 +92,11 @@ STD_CONF_FLAGS = --with-ccopts="${CCOPTS}" --enable-compression \
 		--enable-blkid-devmapper
 
 BF_CONF_FLAGS = --with-ccopts="${CCOPTS} ${BF_CCOPTS}" \
-	--disable-nls --disable-swapfs --disable-imager \
+	--disable-nls --disable-imager \
 	--disable-debugfs  --disable-e2initrd-helper
 
 MIPS_NOPIC_CONF_FLAGS = --with-ccopts="${CCOPTS}" \
-	--disable-nls \
-	--disable-swapfs --disable-imager \
-        --disable-resizer # --disable-debugfs
+	--disable-nls --disable-imager --disable-resizer # --disable-debugfs
 
 # we can't use those flags at configure time
 MIPS_CFLAGS= -G 0 -fno-pic -mno-abicalls
diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 70e18e7..03ce131 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -243,12 +243,10 @@ mkjournal: mkjournal.c $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
 	@$(CC) -o mkjournal $(srcdir)/mkjournal.c -DDEBUG $(STATIC_LIBEXT2FS) $(LIBCOM_ERR) $(ALL_CFLAGS)
 
-check:: tst_bitops tst_badblocks tst_iscan @SWAPFS_CMT@ tst_byteswap \
-	tst_types tst_icount tst_super_size
+check:: tst_bitops tst_badblocks tst_iscan tst_types tst_icount tst_super_size
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_bitops
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_badblocks
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_iscan
-@SWAPFS_CMT@	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_byteswap
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_types
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_icount
 	LD_LIBRARY_PATH=$(LIB) DYLD_LIBRARY_PATH=$(LIB) ./tst_super_size
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index eed1a49..d83ce8e 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -274,36 +274,6 @@ _INLINE_ int ext2fs_find_next_bit_set (void * addr, int size, int offset)
 }
 #endif
 
-#ifdef EXT2FS_ENABLE_SWAPFS
-_INLINE_ __u32 ext2fs_swab32(__u32 val)
-{
-#ifdef EXT2FS_REQUIRE_486
-	__asm__("bswap %0" : "=r" (val) : "0" (val));
-#else
-	__asm__("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
-		"rorl $16,%0\n\t"	/* swap words		*/
-		"xchgb %b0,%h0"		/* swap higher bytes	*/
-		:"=q" (val)
-		: "0" (val));
-#endif
-	return val;
-}
-
-_INLINE_ __u16 ext2fs_swab16(__u16 val)
-{
-	__asm__("xchgb %b0,%h0"		/* swap bytes		*/ \
-		: "=q" (val) \
-		:  "0" (val)); \
-		return val;
-}
-
-_INLINE_ __u64 ext2fs_swab64(__u64 val)
-{
-	return (ext2fs_swab32(val >> 32) |
-		(((__u64)ext2fs_swab32(val & 0xFFFFFFFFUL)) << 32));
-}
-#endif
-
 #undef EXT2FS_ADDR
 
 #endif	/* i386 */
@@ -346,7 +316,7 @@ _INLINE_ int ext2fs_test_bit(unsigned int nr, const void * addr)
 #endif /* __mc68000__ */
 
 
-#if !defined(_EXT2_HAVE_ASM_SWAB_) && defined(EXT2FS_ENABLE_SWAPFS)
+#if !defined(_EXT2_HAVE_ASM_SWAB_) && defined(WORDS_BIGENDIAN)
 
 _INLINE_ __u16 ext2fs_swab16(__u16 val)
 {
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 20c63c0..83a9091 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -30,15 +30,6 @@ extern "C" {
 #endif
 
 /*
- * Build in support for byte-swapping filesystems if we the feature
- * has been configured or if we're being built on a CPU architecture
- * with a non-native byte order.
- */
-#if defined(ENABLE_SWAPFS) || defined(WORDS_BIGENDIAN)
-#define EXT2FS_ENABLE_SWAPFS
-#endif
-
-/*
  * Where the master copy of the superblock is located, and how big
  * superblocks are supposed to be.  We define SUPERBLOCK_SIZE because
  * the size of the superblock structure is not necessarily trustworthy
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 6576c59..bd0844d 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -20,7 +20,7 @@
 #include "ext2fs.h"
 #include <ext2fs/ext2_ext_attr.h>
 
-#ifdef EXT2FS_ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 void ext2fs_swap_super(struct ext2_super_block * sb)
 {
   	int i;
-- 
1.5.3.rc4.67.gf9286
