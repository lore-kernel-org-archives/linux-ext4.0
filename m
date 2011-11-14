From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Make quota support disabled by support
Date: Mon, 14 Nov 2011 10:47:04 -0500
Message-ID: <1321285624-22675-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56361 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1KNPrI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Nov 2011 10:47:08 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quota support can be enabled using --enable-quota.  There are still
some buglets that we need to fix up before it can be considered 100%
supported, so let's disable it for the 1.42 release.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 RELEASE-NOTES       |    9 +++--
 configure           |   95 ++++++++-------------------------------------------
 configure.in        |   42 ++++++----------------
 debian/rules        |    2 +-
 lib/config.h.in     |    3 ++
 lib/ext2fs/ext2fs.h |   10 +++++
 misc/mke2fs.c       |    5 ++-
 7 files changed, 50 insertions(+), 116 deletions(-)

diff --git a/RELEASE-NOTES b/RELEASE-NOTES
index 7b36af9..afc738f 100644
--- a/RELEASE-NOTES
+++ b/RELEASE-NOTES
@@ -14,10 +14,6 @@ called 'bigalloc', which must be enabled when the file system is
 initially formatted.  It is not backwards compatible with older
 kernels.
 
-This release of e2fsprogs has support for integrated feature, where
-the quota files are hidden system files that are automatically
-maintained by e2fsck.
-
 Added support for the Multi-Mount Protection (MMP) feature.
 
 Fix a bug in e2fsck where if the free blocks and inodes counts are
@@ -202,6 +198,11 @@ Updated/clarified man pages.  (Addresses Debian Bugs: #639411,
 Programming notes
 -----------------
 
+Initial support for quota as an integrated feature, where the quota
+files are hidden system files that are automatically maintained by
+e2fsck is present, although disabled by default.  It must be enabled
+by using the configure option --enable-quota.
+
 Reserved the on-disk fields for the metadata checksum and snapshot
 features, which are currently in development.
 
diff --git a/configure b/configure
index 6c8eb49..0e8d6fb 100755
--- a/configure
+++ b/configure
@@ -808,7 +808,7 @@ enable_blkid_debug
 enable_testio_debug
 enable_libuuid
 enable_libblkid
-enable_libquota
+enable_quota
 enable_debugfs
 enable_imager
 enable_resizer
@@ -1462,7 +1462,7 @@ Optional Features:
   --disable-testio-debug  disable the use of the test I/O manager for debugging
   --disable-libuuid	  do not build private uuid library
   --disable-libblkid	  do not build private blkid library
-  --disable-libquota	  do not build private quota library
+  --enable-libquota	  enable quota support
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
   --disable-resizer   	  disable support of e2resize program
@@ -5204,97 +5204,32 @@ $as_echo "no" >&6; }
         fi
 
 fi
-LIBQUOTA=
-DEPLIBQUOTA=
-STATIC_LIBQUOTA=
-DEPSTATIC_LIBQUOTA=
-PROFILED_LIBQUOTA=
-DEPPROFILED_LIBQUOTA=
-QUOTA_CMT=
-# Check whether --enable-libquota was given.
-if test "${enable_libquota+set}" = set; then :
-  enableval=$enable_libquota; if test "$enableval" = "no"
-then
-	if test -z "$PKG_CONFIG"; then
-		as_fn_error "pkg-config not installed; please install it." "$LINENO" 5
-	fi
 
-	as_ac_Lib=`$as_echo "ac_cv_lib_quota_LIBQUOTA=\`$PKG_CONFIG --libs quota\`;
-		 STATIC_LIBQUOTA=\`$PKG_CONFIG --static --libs quota\`" | $as_tr_sh`
-{ $as_echo "$as_me:${as_lineno-$LINENO}: checking for LIBQUOTA=\`$PKG_CONFIG --libs quota\`;
-		 STATIC_LIBQUOTA=\`$PKG_CONFIG --static --libs quota\` in -lquota" >&5
-$as_echo_n "checking for LIBQUOTA=\`$PKG_CONFIG --libs quota\`;
-		 STATIC_LIBQUOTA=\`$PKG_CONFIG --static --libs quota\` in -lquota... " >&6; }
-if { as_var=$as_ac_Lib; eval "test \"\${$as_var+set}\" = set"; }; then :
-  $as_echo_n "(cached) " >&6
+# Check whether --enable-quota was given.
+if test "${enable_quota+set}" = set; then :
+  enableval=$enable_quota; if test "$enableval" = "no"
+then
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support" >&5
+$as_echo "Disabling quota support" >&6; }
 else
-  ac_check_lib_save_LIBS=$LIBS
-LIBS="-lquota  $LIBS"
-cat confdefs.h - <<_ACEOF >conftest.$ac_ext
-/* end confdefs.h.  */
+	$as_echo "#define CONFIG_QUOTA 1" >>confdefs.h
 
-/* Override any GCC internal prototype to avoid an error.
-   Use char because int might match the return type of a GCC
-   builtin and then its argument prototype would still apply.  */
-#ifdef __cplusplus
-extern "C"
-#endif
-char LIBQUOTA=`$PKG_CONFIG --libs quota`;
-		 STATIC_LIBQUOTA=`$PKG_CONFIG --static --libs quota` ();
-int
-main ()
-{
-return LIBQUOTA=`$PKG_CONFIG --libs quota`;
-		 STATIC_LIBQUOTA=`$PKG_CONFIG --static --libs quota` ();
-  ;
-  return 0;
-}
-_ACEOF
-if ac_fn_c_try_link "$LINENO"; then :
-  eval "$as_ac_Lib=yes"
-else
-  eval "$as_ac_Lib=no"
-fi
-rm -f core conftest.err conftest.$ac_objext \
-    conftest$ac_exeext conftest.$ac_ext
-LIBS=$ac_check_lib_save_LIBS
-fi
-eval ac_res=\$$as_ac_Lib
-	       { $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_res" >&5
-$as_echo "$ac_res" >&6; }
-eval as_val=\$$as_ac_Lib
-   if test "x$as_val" = x""yes; then :
-  as_fn_error "external quota library not found" "$LINENO" 5
-else
-  $LIBQUOTA
+	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling quota support" >&5
+$as_echo "Enabling quota support" >&6; }
 fi
 
-	QUOTA_CMT=#
-	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling private quota library" >&5
-$as_echo "Disabling private quota library" >&6; }
 else
-	LIBQUOTA='$(LIB)/libquota'$LIB_EXT
-	DEPLIBQUOTA=$LIBQUOTA
-	STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
-	DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
-	PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
-	DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
-	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling private quota library" >&5
-$as_echo "Enabling private quota library" >&6; }
+  { $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support by default" >&5
+$as_echo "Disabling quota support by default" >&6; }
+
 fi
 
-else
-  LIBQUOTA='$(LIB)/libquota'$LIB_EXT
+LIBQUOTA='$(LIB)/libquota'$LIB_EXT
 DEPLIBQUOTA=$LIBQUOTA
 STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
 DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
 PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
 DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
-{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling private quota library by default" >&5
-$as_echo "Enabling private quota library by default" >&6; }
-
-fi
-
 
 
 
diff --git a/configure.in b/configure.in
index 0b609bb..2b81619 100644
--- a/configure.in
+++ b/configure.in
@@ -526,49 +526,31 @@ AC_SUBST(PROFILED_LIBBLKID)
 AC_SUBST(DEPPROFILED_LIBBLKID)
 AC_SUBST(BLKID_CMT)
 dnl
-dnl handle --disable-libquota
+dnl handle --enable-quota
 dnl
 PKG_PROG_PKG_CONFIG
-LIBQUOTA=
-DEPLIBQUOTA=
-STATIC_LIBQUOTA=
-DEPSTATIC_LIBQUOTA=
-PROFILED_LIBQUOTA=
-DEPPROFILED_LIBQUOTA=
-QUOTA_CMT=
-AC_ARG_ENABLE([libquota],
-[  --disable-libquota	  do not build private quota library],
+AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota support])
+AC_ARG_ENABLE([quota],
+[  --enable-libquota	  enable quota support],
 if test "$enableval" = "no"
 then
-	if test -z "$PKG_CONFIG"; then
-		AC_MSG_ERROR([pkg-config not installed; please install it.])
-	fi
-
-	AC_CHECK_LIB(quota,
-		[LIBQUOTA=`$PKG_CONFIG --libs quota`;
-		 STATIC_LIBQUOTA=`$PKG_CONFIG --static --libs quota`],
-		[AC_MSG_ERROR([external quota library not found])],
-		[$LIBQUOTA])
-	QUOTA_CMT=#
-	AC_MSG_RESULT([Disabling private quota library])
+	AC_MSG_RESULT([Disabling quota support])
 else
-	LIBQUOTA='$(LIB)/libquota'$LIB_EXT
-	DEPLIBQUOTA=$LIBQUOTA
-	STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
-	DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
-	PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
-	DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
-	AC_MSG_RESULT([Enabling private quota library])
+	AC_DEFINE(CONFIG_QUOTA, 1)
+	AC_MSG_RESULT([Enabling quota support])
 fi
 ,
+AC_MSG_RESULT([Disabling quota support by default])
+)
+dnl
+dnl Define stuff expected for quota library
+dnl
 LIBQUOTA='$(LIB)/libquota'$LIB_EXT
 DEPLIBQUOTA=$LIBQUOTA
 STATIC_LIBQUOTA='$(LIB)/libquota'$STATIC_LIB_EXT
 DEPSTATIC_LIBQUOTA=$STATIC_LIBQUOTA
 PROFILED_LIBQUOTA='$(LIB)/libquota'$PROFILED_LIB_EXT
 DEPPROFILED_LIBQUOTA=$PROFILED_LIBQUOTA
-AC_MSG_RESULT([Enabling private quota library by default])
-)
 AC_SUBST(LIBQUOTA)
 AC_SUBST(DEPLIBQUOTA)
 AC_SUBST(STATIC_LIBQUOTA)
diff --git a/debian/rules b/debian/rules
index 2d8e4ea..c950cd7 100755
--- a/debian/rules
+++ b/debian/rules
@@ -129,7 +129,7 @@ endif
 BF_CFLAGS = -Os -fomit-frame-pointer
 
 COMMON_CONF_FLAGS = --disable-e2initrd-helper --enable-elf-shlibs \
-	--infodir=/usr/share/info
+	--enable-quota --infodir=/usr/share/info
 ifeq ($(UTIL_LINUX_NG),yes)
 COMMON_CONF_FLAGS += --disable-fsck --disable-libblkid \
 			--disable-libuuid --disable-uuidd
diff --git a/lib/config.h.in b/lib/config.h.in
index a58745e..0e83634 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -12,6 +12,9 @@
 /* Define to 1 if debugging ext3/4 journal code */
 #undef CONFIG_JBD_DEBUG
 
+/* Define to 1 to enable quota support */
+#undef CONFIG_QUOTA
+
 /* Define to 1 if the testio I/O manager should be enabled */
 #undef CONFIG_TESTIO_DEBUG
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 4de20c9..08f1946 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -577,6 +577,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
+#ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
@@ -585,6 +586,15 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
 					 EXT4_FEATURE_RO_COMPAT_BIGALLOC|\
 					 EXT4_FEATURE_RO_COMPAT_QUOTA)
+#else
+#define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
+					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
+					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
+					 EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+#endif
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index a07e866..ebd5f34 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -847,7 +847,10 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 		EXT4_FEATURE_RO_COMPAT_BIGALLOC|
-		EXT4_FEATURE_RO_COMPAT_QUOTA
+#ifdef CONFIG_QUOTA
+		EXT4_FEATURE_RO_COMPAT_QUOTA|
+#endif
+		0
 };
 
 
-- 
1.7.4.1.22.gec8e1.dirty

