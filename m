From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] build: update generated configure file
Date: Wed, 24 Apr 2013 16:35:17 -0600
Message-ID: <1366842917-25333-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-05.shaw.ca ([64.59.134.13]:22122 "EHLO
	smtp-out-05.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3DXWpA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Apr 2013 18:45:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 274d46e1d changed the configure.in file to add an loff_t check
but the configure file was not regenerated as part of that patch.
That results in "configure" containing an uncommitted diff whenever
autoconf is run.

Commit the newly-generated configure file (also using autoconf 2.69).

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 configure |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/configure b/configure
index da1bcb6..c91e605 100755
--- a/configure
+++ b/configure
@@ -640,6 +640,7 @@ LINUX_CMT
 UNI_DIFF_OPTS
 SEM_INIT_LIB
 SOCKET_LIB
+SIZEOF_OFF_T
 SIZEOF_LONG_LONG
 SIZEOF_LONG
 SIZEOF_INT
@@ -10574,10 +10575,45 @@ cat >>confdefs.h <<_ACEOF
 _ACEOF
 
 
+# The cast to long int works around a bug in the HP C Compiler
+# version HP92453-01 B.11.11.23709.GP, which incorrectly rejects
+# declarations like `int a3[[(sizeof (unsigned char)) >= 0]];'.
+# This bug is HP SR number 8606223364.
+{ $as_echo "$as_me:${as_lineno-$LINENO}: checking size of off_t" >&5
+$as_echo_n "checking size of off_t... " >&6; }
+if ${ac_cv_sizeof_off_t+:} false; then :
+  $as_echo_n "(cached) " >&6
+else
+  if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (off_t))" "ac_cv_sizeof_off_t"        "$ac_includes_default"; then :
+
+else
+  if test "$ac_cv_type_off_t" = yes; then
+     { { $as_echo "$as_me:${as_lineno-$LINENO}: error: in \`$ac_pwd':" >&5
+$as_echo "$as_me: error: in \`$ac_pwd':" >&2;}
+as_fn_error 77 "cannot compute sizeof (off_t)
+See \`config.log' for more details" "$LINENO" 5; }
+   else
+     ac_cv_sizeof_off_t=0
+   fi
+fi
+
+fi
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: $ac_cv_sizeof_off_t" >&5
+$as_echo "$ac_cv_sizeof_off_t" >&6; }
+
+
+
+cat >>confdefs.h <<_ACEOF
+#define SIZEOF_OFF_T $ac_cv_sizeof_off_t
+_ACEOF
+
+
 SIZEOF_SHORT=$ac_cv_sizeof_short
 SIZEOF_INT=$ac_cv_sizeof_int
 SIZEOF_LONG=$ac_cv_sizeof_long
 SIZEOF_LONG_LONG=$ac_cv_sizeof_long_long
+SIZEOF_OFF_T=$ac_cv_sizeof_off_t
+
 
 
 
-- 
1.7.3.4

