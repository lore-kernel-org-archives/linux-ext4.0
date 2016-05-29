From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: fix f_pre_1970_date_encoding on systems with a 32-bit time_t
Date: Sun, 29 May 2016 01:08:12 -0400
Message-ID: <1464498492-1597-2-git-send-email-tytso@mit.edu>
References: <1464498492-1597-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43704 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbcE2FIT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 29 May 2016 01:08:19 -0400
In-Reply-To: <1464498492-1597-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 configure                             | 36 +++++++++++++++++++++++++++++++++++
 configure.ac                          |  3 +++
 tests/Makefile.in                     |  1 +
 tests/f_pre_1970_date_encoding/script | 28 +++++++++++++++++++--------
 4 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/configure b/configure
index 3759c9c..8f6d6cb 100755
--- a/configure
+++ b/configure
@@ -650,6 +650,7 @@ FUSE_CMT
 FUSE_LIB
 MAGIC_LIB
 SOCKET_LIB
+SIZEOF_TIME_T
 SIZEOF_OFF_T
 SIZEOF_LONG_LONG
 SIZEOF_LONG
@@ -12593,11 +12594,46 @@ cat >>confdefs.h <<_ACEOF
 _ACEOF
 
 
+# The cast to long int works around a bug in the HP C Compiler
+# version HP92453-01 B.11.11.23709.GP, which incorrectly rejects
+# declarations like `int a3[[(sizeof (unsigned char)) >= 0]];'.
+# This bug is HP SR number 8606223364.
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking size of time_t" >&5
+$as_echo_n "checking size of time_t... " >&6; }
+if ${ac_cv_sizeof_time_t+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (time_t))" "ac_cv_sizeof_time_t"        "$ac_includes_default"; then :
+
+else
+  if test "$ac_cv_type_time_t" = yes; then
+     { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error 77 "cannot compute sizeof (time_t)
+See \`config.log' for more details" "$LINENO" 5; }
+   else
+     ac_cv_sizeof_time_t=0
+   fi
+fi
+
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_sizeof_time_t" >&5
+$as_echo "$ac_cv_sizeof_time_t" >&6; }
+
+
+
+cat >>confdefs.h <<_ACEOF
+#define SIZEOF_TIME_T $ac_cv_sizeof_time_t
+_ACEOF
+
+
 SIZEOF_SHORT=$ac_cv_sizeof_short
 SIZEOF_INT=$ac_cv_sizeof_int
 SIZEOF_LONG=$ac_cv_sizeof_long
 SIZEOF_LONG_LONG=$ac_cv_sizeof_long_long
 SIZEOF_OFF_T=$ac_cv_sizeof_off_t
+SIZEOF_TIME_T=$ac_cv_sizeof_time_t
+
 
 
 
diff --git a/configure.ac b/configure.ac
index e8e0d68..b8e2d4a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -971,16 +971,19 @@ AC_CHECK_SIZEOF(int)
 AC_CHECK_SIZEOF(long)
 AC_CHECK_SIZEOF(long long)
 AC_CHECK_SIZEOF(off_t)
+AC_CHECK_SIZEOF(time_t)
 SIZEOF_SHORT=$ac_cv_sizeof_short
 SIZEOF_INT=$ac_cv_sizeof_int
 SIZEOF_LONG=$ac_cv_sizeof_long
 SIZEOF_LONG_LONG=$ac_cv_sizeof_long_long
 SIZEOF_OFF_T=$ac_cv_sizeof_off_t
+SIZEOF_TIME_T=$ac_cv_sizeof_time_t
 AC_SUBST(SIZEOF_SHORT)
 AC_SUBST(SIZEOF_INT)
 AC_SUBST(SIZEOF_LONG)
 AC_SUBST(SIZEOF_LONG_LONG)
 AC_SUBST(SIZEOF_OFF_T)
+AC_SUBST(SIZEOF_TIME_T)
 AC_C_BIGENDIAN
 if test $cross_compiling = no; then
   BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh $ac_aux_dir/parse-types.sh
diff --git a/tests/Makefile.in b/tests/Makefile.in
index 9a7d3ff..c130f4a 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -20,6 +20,7 @@ test_one: $(srcdir)/test_one.in Makefile mke2fs.conf
 	@echo "QUOTA=y" >> test_one
 	@echo "SRCDIR=@srcdir@" >> test_one
 	@echo "DIFF_OPTS=@UNI_DIFF_OPTS@" >> test_one
+	@echo "SIZEOF_TIME_T=@SIZEOF_TIME_T@" >> test_one
 	@cat $(srcdir)/test_one.in >> test_one
 	@chmod +x test_one
 
diff --git a/tests/f_pre_1970_date_encoding/script b/tests/f_pre_1970_date_encoding/script
index e6d7bbd..06ff98a 100644
--- a/tests/f_pre_1970_date_encoding/script
+++ b/tests/f_pre_1970_date_encoding/script
@@ -68,17 +68,29 @@ get_file_xtime_and_extra year-1979
 get_file_xtime_and_extra year-2039
 get_file_xtime_and_extra year-2139
 
-# now we need to check that after the year 2242, e2fsck does not
-# modify dates with extra_xtime=3
+if test $SIZEOF_TIME_T -gt 4
+then
+  # now we need to check that after the year 2242, e2fsck does not
+  # modify dates with extra_xtime=3
 
-# restore the unrepaired filesystem
-mv $TMPFILE.sav $TMPFILE
+  # restore the unrepaired filesystem
+  mv $TMPFILE.sav $TMPFILE
 
-#retry the repair
-E2FSCK_TIME=9270393539 $FSCK $FSCK_OPT $TMPFILE >> $OUT 2>&1
+  #retry the repair
+  E2FSCK_TIME=9270393539 $FSCK $FSCK_OPT $TMPFILE >> $OUT 2>&1
 
-# check that the 1909 file is unaltered (i.e. it has a post-2378 date)
-get_file_xtime_and_extra year-1909
+  # check that the 1909 file is unaltered (i.e. it has a post-2378 date)
+  get_file_xtime_and_extra year-1909
+else
+  rm -f TMPFILE.sav
+cat << EOF >> $TIMESTAMPS
+times for year-1909 =
+ ctime: 0x8e475440:00000003
+ atime: 0x8e475440:00000003
+ mtime: 0x8e475440:00000003
+crtime: 0x8e475440:00000003
+EOF
+fi
 
 cmp -s $TIMESTAMPS $EXP
 status=$?
-- 
2.5.0

