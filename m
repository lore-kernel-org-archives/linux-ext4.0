From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: [E2FSPROGS, PATCH] Fix "make docs" rule in Makefile for doc folder.
Date: Mon, 14 Apr 2008 17:20:03 +0530
Message-ID: <ea11fea30804140450l5ee0a0f5o4b18f7fd6e7b6a1d@mail.gmail.com>
References: <ea11fea30804101255g4d4c772eh2016563954802713@mail.gmail.com>
	 <20080413212126.GA18156@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:35819 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbYDNLuH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Apr 2008 07:50:07 -0400
Received: by ug-out-1314.google.com with SMTP id z38so439162ugc.16
        for <linux-ext4@vger.kernel.org>; Mon, 14 Apr 2008 04:50:04 -0700 (PDT)
In-Reply-To: <20080413212126.GA18156@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>

diff --git a/configure.in b/configure.in
index 5243549..e64d817 100644
--- a/configure.in
+++ b/configure.in
@@ -595,6 +595,20 @@ AC_PATH_PROG(LDCONFIG, ldconfig, :)
 AC_CHECK_TOOL(AR, ar, ar)
 AC_CHECK_TOOL(RANLIB, ranlib, :)
 AC_CHECK_TOOL(STRIP, strip, :)
+AC_CHECK_PROG(MAKEINFO, makeinfo, makeinfo, )
+if test "_$MAKEINFO" = "_"; then
+    MAKEINFO="@echo Makeinfo is missing. Info documentation will not
be built.;true"
+else
+    case "$MAKEINFO" in
+      */missing.*)
+        AC_MSG_WARN([
+*** Makeinfo is missing. Info documentation will not be built.])
+        ;;
+      *)
+        ;;
+    esac
+fi
+AC_SUBST(MAKEINFO)
 AC_PROG_INSTALL
 # See if we need a separate native compiler.
 if test $cross_compiling = no; then
diff --git a/doc/Makefile.in b/doc/Makefile.in
index 5494cf0..9c961f3 100644
--- a/doc/Makefile.in
+++ b/doc/Makefile.in
@@ -13,7 +13,7 @@ INSTALL = @INSTALL@

 DVI=texi2dvi
 DVIPS=dvips -o "$@"
-INFO=makeinfo
+INFO=@MAKEINFO@
 HTML=texi2html

 all:: libext2fs.info libext2fs.dvi







On Mon, Apr 14, 2008 at 2:51 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Apr 11, 2008 at 01:25:47AM +0530, Manish Katiyar wrote:
>  > On systems which don't have makeinfo installed by default, "make" or
>  > "make docs" fails with the following error
>  > /home/mkatiyar/e2fs-git> make docs
>  > make[1]: Entering directory `/home/mkatiyar/e2fs-git/doc'
>  >         MAKEINFO libext2fs.info
>  > make[1]: makeinfo: Command not found
>  > make[1]: [libext2fs.info] Error 127 (ignored)
>  >
>  > This patch makes it to bail out with proper error message when
>  > makeinfo is not present.
>
>  Can you send me a Signed-off-by for your patch, per the
>  SUBMITTING-PATCHES file in the e2fsprogs sources?
>
>  Many thanks,
>
>                                          - Ted
>



-- 
Thanks & Regards,
********************************************
Manish Katiyar ( http://mkatiyar.googlepages.com )
3rd Floor, Fair Winds Block
EGL Software Park
Off Intermediate Ring Road
Bangalore 560071, India
***********************************************
