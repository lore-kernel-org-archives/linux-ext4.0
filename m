From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] configure.in: fix external libblkid test for static link
Date: Sat, 5 Jul 2014 00:31:26 -0400
Message-ID: <20140705043126.GI11103@thunk.org>
References: <b52e76432fe23490b891884f3a66504101c2a5bd.1402481313.git.baruch@tkos.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Baruch Siach <baruch@tkos.co.il>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46349 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaGEEbc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 00:31:32 -0400
Content-Disposition: inline
In-Reply-To: <b52e76432fe23490b891884f3a66504101c2a5bd.1402481313.git.baruch@tkos.co.il>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2014 at 01:08:33PM +0300, Baruch Siach wrote:
> External libblkid needs -luuid when linking statically. Use pkg-config to
> determine it correctly. Adding --static doesn't heart even for dynamic
> linking.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Thanks for reporting this; I fixed this a slightly different and
simpler way.

       	   	     	     	   	  - Ted

commit 2d7583bd42a884d9d9fe6413a9f1a8356e7bb803
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jul 5 00:27:02 2014 -0400

    configure.in: fix external libblkid test for static link
    
    External libblkid needs -luuid when linking statically.
    
    Also fix up the bogus other-lib parameter in the libuuid test;
    $LIBUUID is the null string, so it doesn't do anything other than
    obfuscate the use of AC_CHECK_LIB.
    
    Reported-by: Baruch Siach <baruch@tkos.co.il>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/configure b/configure
index a41e008..87fd2f3 100755
--- a/configure
+++ b/configure
@@ -5264,7 +5264,7 @@ if ${ac_cv_lib_uuid_uuid_generate+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
-LIBS="-luuid $LIBUUID $LIBS"
+LIBS="-luuid  $LIBS"
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
@@ -5476,7 +5476,7 @@ if ${ac_cv_lib_blkid_blkid_get_cache+:} false; then :
   $as_echo_n "(cached) " >&6
 else
   ac_check_lib_save_LIBS=$LIBS
-LIBS="-lblkid $LIBBLKID $LIBS"
+LIBS="-lblkid -luuid $LIBS"
 cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
 
diff --git a/configure.in b/configure.in
index 4f7e613..3ca5d63 100644
--- a/configure.in
+++ b/configure.in
@@ -478,8 +478,7 @@ then
 	AC_CHECK_LIB(uuid, uuid_generate,
 		[LIBUUID=`$PKG_CONFIG --libs uuid`;
 		 STATIC_LIBUUID=`$PKG_CONFIG --static --libs uuid`],
-		[AC_MSG_ERROR([external uuid library not found])],
-		[$LIBUUID])
+		[AC_MSG_ERROR([external uuid library not found])])
 	UUID_CMT=#
 	AC_MSG_RESULT([Disabling private uuid library])
 else
@@ -530,8 +529,7 @@ then
 	AC_CHECK_LIB(blkid, blkid_get_cache,
 		[LIBBLKID=`$PKG_CONFIG --libs blkid`;
 		 STATIC_LIBBLKID=`$PKG_CONFIG --static --libs blkid`],
-		[AC_MSG_ERROR([external blkid library not found])],
-		[$LIBBLKID])
+		[AC_MSG_ERROR([external blkid library not found])], -luuid)
 	BLKID_CMT=#
 	AC_MSG_RESULT([Disabling private blkid library])
 else
