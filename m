From: Ross Burton <ross.burton@intel.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20Move=20e2fsprogs-specific=20macros=20from=20aclocal=2Em4=20to=20acinclude=2Em4?=
Date: Tue,  1 Jul 2014 11:47:34 +0100
Message-ID: <1404211654-10158-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:46977 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbaGAKrv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 06:47:51 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so9546188wes.4
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jul 2014 03:47:50 -0700 (PDT)
Received: from melchett.burtonini.com (35.106.2.81.in-addr.arpa. [81.2.106.35])
        by mx.google.com with ESMTPSA id d12sm13837383wjx.0.2014.07.01.03.47.48
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Jul 2014 03:47:49 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Autoconf says that aclocal.m4 is a machine-generated copy of system-wid=
e macros,
whereas acinclude.m4 is for project-specific macros.  Reflect this divi=
sion and
ease building by anyone who needs to re-generate the autotooling by spl=
itting
AX_TLS and CHECK_GNU_MAKE to acinclude.m4.

Signed-off-by: Ross Burton <ross.burton@intel.com>
---
 acinclude.m4 |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
 aclocal.m4   |  132 +-------------------------------------------------=
--------
 2 files changed, 132 insertions(+), 130 deletions(-)
 create mode 100644 acinclude.m4

diff --git a/acinclude.m4 b/acinclude.m4
new file mode 100644
index 0000000..cf84acc
--- /dev/null
+++ b/acinclude.m4
@@ -0,0 +1,130 @@
+# from http://autoconf-archive.cryp.to/ax_tls.html
+#
+# This was licensed under the GPL with the following exception:
+#
+# As a special exception, the respective Autoconf Macro's copyright
+# owner gives unlimited permission to copy, distribute and modify the
+# configure scripts that are the output of Autoconf when processing
+# the Macro. You need not follow the terms of the GNU General Public
+# License when using or distributing such scripts, even though
+# portions of the text of the Macro appear in them. The GNU General
+# Public License (GPL) does govern all other use of the material that
+# constitutes the Autoconf Macro.
+#
+# This special exception to the GPL applies to versions of the
+# Autoconf Macro released by the Autoconf Macro Archive. When you make
+# and distribute a modified version of the Autoconf Macro, you may
+# extend this special exception to the GPL to apply to your modified
+# version as well.
+#
+AC_DEFUN([AX_TLS], [
+  AC_MSG_CHECKING(for thread local storage (TLS) class)
+  AC_CACHE_VAL(ac_cv_tls, [
+    ax_tls_keywords=3D"__thread __declspec(thread) none"
+    for ax_tls_keyword in $ax_tls_keywords; do
+       case $ax_tls_keyword in
+          none) ac_cv_tls=3Dnone ; break ;;
+          *)
+             AC_TRY_COMPILE(
+                [#include <stdlib.h>
+                 static void
+                 foo(void) {
+                 static ] $ax_tls_keyword [ int bar;
+                 exit(1);
+                 }],
+                 [],
+                 [ac_cv_tls=3D$ax_tls_keyword ; break],
+                 ac_cv_tls=3Dnone
+             )
+          esac
+    done
+])
+
+  if test "$ac_cv_tls" !=3D "none"; then
+    dnl AC_DEFINE([TLS], [], [If the compiler supports a TLS storage c=
lass define it to that here])
+    AC_DEFINE_UNQUOTED([TLS], $ac_cv_tls, [If the compiler supports a =
TLS storage class define it to that here])
+  fi
+  AC_MSG_RESULT($ac_cv_tls)
+])
+
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+#         http://www.nongnu.org/autoconf-archive/check_gnu_make.html
+# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
+#
+# SYNOPSIS
+#
+#   CHECK_GNU_MAKE()
+#
+# DESCRIPTION
+#
+#   This macro searches for a GNU version of make. If a match is found=
, the
+#   makefile variable `ifGNUmake' is set to the empty string, otherwis=
e it
+#   is set to "#". This is useful for including a special features in =
a
+#   Makefile, which cannot be handled by other versions of make. The
+#   variable _cv_gnu_make_command is set to the command to invoke GNU =
make
+#   if it exists, the empty string otherwise.
+#
+#   Here is an example of its use:
+#
+#   Makefile.in might contain:
+#
+#       # A failsafe way of putting a dependency rule into a makefile
+#       $(DEPEND):
+#               $(CC) -MM $(srcdir)/*.c > $(DEPEND)
+#
+#       @ifGNUmake@ ifeq ($(DEPEND),$(wildcard $(DEPEND)))
+#       @ifGNUmake@ include $(DEPEND)
+#       @ifGNUmake@ endif
+#
+#   Then configure.in would normally contain:
+#
+#       CHECK_GNU_MAKE()
+#       AC_OUTPUT(Makefile)
+#
+#   Then perhaps to cause gnu make to override any other make, we coul=
d do
+#   something like this (note that GNU make always looks for GNUmakefi=
le
+#   first):
+#
+#       if  ! test x$_cv_gnu_make_command =3D x ; then
+#               mv Makefile GNUmakefile
+#               echo .DEFAULT: > Makefile ;
+#               echo \  $_cv_gnu_make_command \$@ >> Makefile;
+#       fi
+#
+#   Then, if any (well almost any) other make is called, and GNU make =
also
+#   exists, then the other make wraps the GNU make.
+#
+# LICENSE
+#
+#   Copyright (c) 2008 John Darrington <j.darrington@elvis.murdoch.edu=
=2Eau>
+#
+#   Copying and distribution of this file, with or without modificatio=
n, are
+#   permitted in any medium without royalty provided the copyright not=
ice
+#   and this notice are preserved.
+#
+# Note: Modified by Ted Ts'o to add @ifNotGNUMake@
+
+AC_DEFUN(
+        [CHECK_GNU_MAKE], [ AC_CACHE_CHECK( for GNU make,_cv_gnu_make_=
command,
+                _cv_gnu_make_command=3D'' ;
+dnl Search all the common names for GNU make
+                for a in "$MAKE" make gmake gnumake ; do
+                        if test -z "$a" ; then continue ; fi ;
+                        if  ( sh -c "$a --version" 2> /dev/null | grep=
 GNU  2>&1 > /dev/null ) ;  then
+                                _cv_gnu_make_command=3D$a ;
+                                break;
+                        fi
+                done ;
+        ) ;
+dnl If there was a GNU version, then set @ifGNUmake@ to the empty stri=
ng, '#' otherwise
+        if test  "x$_cv_gnu_make_command" !=3D "x"  ; then
+                ifGNUmake=3D'' ;
+                ifNotGNUmake=3D'#' ;
+        else
+                ifGNUmake=3D'#' ;
+                ifNotGNUmake=3D'' ;
+                AC_MSG_RESULT("Not found");
+        fi
+        AC_SUBST(ifGNUmake)
+        AC_SUBST(ifNotGNUmake)
+] )
diff --git a/aclocal.m4 b/aclocal.m4
index 6fd4652..1ac3861 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -2601,55 +2601,6 @@ AC_DEFUN([gl_XSIZE],
   AC_CHECK_HEADERS(stdint.h)
 ])
=20
-# from http://autoconf-archive.cryp.to/ax_tls.html
-#
-# This was licensed under the GPL with the following exception:
-#
-# As a special exception, the respective Autoconf Macro's copyright
-# owner gives unlimited permission to copy, distribute and modify the
-# configure scripts that are the output of Autoconf when processing
-# the Macro. You need not follow the terms of the GNU General Public
-# License when using or distributing such scripts, even though
-# portions of the text of the Macro appear in them. The GNU General
-# Public License (GPL) does govern all other use of the material that
-# constitutes the Autoconf Macro.
-#
-# This special exception to the GPL applies to versions of the
-# Autoconf Macro released by the Autoconf Macro Archive. When you make
-# and distribute a modified version of the Autoconf Macro, you may
-# extend this special exception to the GPL to apply to your modified
-# version as well.
-#
-AC_DEFUN([AX_TLS], [
-  AC_MSG_CHECKING(for thread local storage (TLS) class)
-  AC_CACHE_VAL(ac_cv_tls, [
-    ax_tls_keywords=3D"__thread __declspec(thread) none"
-    for ax_tls_keyword in $ax_tls_keywords; do
-       case $ax_tls_keyword in
-          none) ac_cv_tls=3Dnone ; break ;;
-          *)
-             AC_TRY_COMPILE(
-                [#include <stdlib.h>
-                 static void
-                 foo(void) {
-                 static ] $ax_tls_keyword [ int bar;
-                 exit(1);
-                 }],
-                 [],
-                 [ac_cv_tls=3D$ax_tls_keyword ; break],
-                 ac_cv_tls=3Dnone
-             )
-          esac
-    done
-])
-
-  if test "$ac_cv_tls" !=3D "none"; then
-    dnl AC_DEFINE([TLS], [], [If the compiler supports a TLS storage c=
lass define it to that here])
-    AC_DEFINE_UNQUOTED([TLS], $ac_cv_tls, [If the compiler supports a =
TLS storage class define it to that here])
-  fi
-  AC_MSG_RESULT($ac_cv_tls)
-])
-
 # Excerpted from pkg.m4 - Macros to locate and utilise pkg-config
 #
 # Copyright =C3=82=C2=A9 2004 Scott James Remnant <scott@netsplit.com>=
=2E
@@ -2694,84 +2645,5 @@ if test -n "$PKG_CONFIG"; then
               =20
 fi[]dnl
 ])# PKG_PROG_PKG_CONFIG
-# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
-#         http://www.nongnu.org/autoconf-archive/check_gnu_make.html
-# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
-#
-# SYNOPSIS
-#
-#   CHECK_GNU_MAKE()
-#
-# DESCRIPTION
-#
-#   This macro searches for a GNU version of make. If a match is found=
, the
-#   makefile variable `ifGNUmake' is set to the empty string, otherwis=
e it
-#   is set to "#". This is useful for including a special features in =
a
-#   Makefile, which cannot be handled by other versions of make. The
-#   variable _cv_gnu_make_command is set to the command to invoke GNU =
make
-#   if it exists, the empty string otherwise.
-#
-#   Here is an example of its use:
-#
-#   Makefile.in might contain:
-#
-#       # A failsafe way of putting a dependency rule into a makefile
-#       $(DEPEND):
-#               $(CC) -MM $(srcdir)/*.c > $(DEPEND)
-#
-#       @ifGNUmake@ ifeq ($(DEPEND),$(wildcard $(DEPEND)))
-#       @ifGNUmake@ include $(DEPEND)
-#       @ifGNUmake@ endif
-#
-#   Then configure.in would normally contain:
-#
-#       CHECK_GNU_MAKE()
-#       AC_OUTPUT(Makefile)
-#
-#   Then perhaps to cause gnu make to override any other make, we coul=
d do
-#   something like this (note that GNU make always looks for GNUmakefi=
le
-#   first):
-#
-#       if  ! test x$_cv_gnu_make_command =3D x ; then
-#               mv Makefile GNUmakefile
-#               echo .DEFAULT: > Makefile ;
-#               echo \  $_cv_gnu_make_command \$@ >> Makefile;
-#       fi
-#
-#   Then, if any (well almost any) other make is called, and GNU make =
also
-#   exists, then the other make wraps the GNU make.
-#
-# LICENSE
-#
-#   Copyright (c) 2008 John Darrington <j.darrington@elvis.murdoch.edu=
=2Eau>
-#
-#   Copying and distribution of this file, with or without modificatio=
n, are
-#   permitted in any medium without royalty provided the copyright not=
ice
-#   and this notice are preserved.
-#
-# Note: Modified by Ted Ts'o to add @ifNotGNUMake@
-
-AC_DEFUN(
-        [CHECK_GNU_MAKE], [ AC_CACHE_CHECK( for GNU make,_cv_gnu_make_=
command,
-                _cv_gnu_make_command=3D'' ;
-dnl Search all the common names for GNU make
-                for a in "$MAKE" make gmake gnumake ; do
-                        if test -z "$a" ; then continue ; fi ;
-                        if  ( sh -c "$a --version" 2> /dev/null | grep=
 GNU  2>&1 > /dev/null ) ;  then
-                                _cv_gnu_make_command=3D$a ;
-                                break;
-                        fi
-                done ;
-        ) ;
-dnl If there was a GNU version, then set @ifGNUmake@ to the empty stri=
ng, '#' otherwise
-        if test  "x$_cv_gnu_make_command" !=3D "x"  ; then
-                ifGNUmake=3D'' ;
-                ifNotGNUmake=3D'#' ;
-        else
-                ifGNUmake=3D'#' ;
-                ifNotGNUmake=3D'' ;
-                AC_MSG_RESULT("Not found");
-        fi
-        AC_SUBST(ifGNUmake)
-        AC_SUBST(ifNotGNUmake)
-] )
+
+m4_include([acinclude.m4])
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
