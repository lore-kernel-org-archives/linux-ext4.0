From: Ivan Shmakov <ivan@siamics.net>
Subject: e2fsprogs/configure: misleading --enable-hardening docstring
Date: Sun, 09 Oct 2016 16:50:46 +0000
Message-ID: <87a8ed79g9.fsf@violet.siamics.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fely.am-1.org ([78.47.74.50]:45253 "EHLO fely.am-1.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751576AbcJIRIR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 9 Oct 2016 13:08:17 -0400
Received: from violet.siamics.net ([2001:470:1f13:1eb::1:1d])
        by fely.am-1.org with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.84_2)
        (envelope-from <ivan@siamics.net>)
        id 1btHJO-0003Fa-8i
        for linux-ext4@vger.kernel.org; Sun, 09 Oct 2016 16:50:54 +0000
Received: from localhost ([::1] helo=violet.siamics.net)
        by violet.siamics.net with esmtps (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <ivan@siamics.net>)
        id 1btHJH-0006aP-Qk
        for linux-ext4@vger.kernel.org; Sun, 09 Oct 2016 23:50:47 +0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain

	Please consider the patch MIMEd.

configure: fix misleading --enable-hardening docstring

-- 
FSF associate member #7257  58F8 0F47 53F5 2EB2 F6A5  8916 3013 B6A0 230E 334A

--=-=-=
Content-Type: text/diff
Content-Disposition: inline

--- configure.ac.~1~
+++ configure.ac	2016-10-09 16:39:08.120404438 +0000
@@ -361,7 +361,7 @@
 LDFLAGS_SHLIB=${LDFLAGS_SHLIB:-$LDFLAGS}
 LDFLAGS_STATIC=${LDFLAGS_STATIC:-$LDFLAGS}
 AC_ARG_ENABLE([hardening],
-[  --enable-hardening	  	  build for coverage testing using gcov],
+[  --enable-hardening	  build with security hardening flags],
 if test "$enableval" = "yes"
 then
 	HARDEN_CFLAGS="-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
--- configure.~1~
+++ configure	2016-10-09 16:39:08.124404250 +0000
@@ -1536,7 +1536,7 @@
   --enable-bsd-shlibs	  select BSD shared libraries
   --enable-profile	  build profiling libraries
   --enable-gcov	  	  build for coverage testing using gcov
-  --enable-hardening	  	  build for coverage testing using gcov
+  --enable-hardening	  build with security hardening flags
   --enable-jbd-debug  	  enable journal debugging
   --enable-blkid-debug    enable blkid debugging
   --disable-testio-debug  disable the use of the test I/O manager for debugging

--=-=-=--
