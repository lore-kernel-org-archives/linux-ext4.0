From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsprogs: fix configure help text for quota
Date: Tue, 27 Nov 2012 12:21:56 -0600
Message-ID: <50B504C4.6090504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab2K0SV5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Nov 2012 13:21:57 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qARILvTm000899
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2012 13:21:57 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id qARILuEI007193
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 27 Nov 2012 13:21:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's --enable-quota, not --enable-libquota.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

PS it's still off by default.  Should it be?  What bugs remain?

Manpage refers to "-O quota" unconditionally.  Maybe that should be
different depending on how it's configured?




diff --git a/configure b/configure
index d47cef7..91e2bf5 100755
--- a/configure
+++ b/configure
@@ -1498,7 +1498,7 @@ Optional Features:
   --disable-testio-debug  disable the use of the test I/O manager for debugging
   --disable-libuuid	  do not build private uuid library
   --disable-libblkid	  do not build private blkid library
-  --enable-libquota	  enable quota support
+  --enable-quota	  enable quota support
   --disable-debugfs   	  disable support of debugfs program
   --disable-imager   	  disable support of e2image program
   --disable-resizer   	  disable support of e2resize program
diff --git a/configure.in b/configure.in
index 0b96b8d..bc8d1e8 100644
--- a/configure.in
+++ b/configure.in
@@ -568,7 +568,7 @@ dnl
 PKG_PROG_PKG_CONFIG
 AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota support])
 AC_ARG_ENABLE([quota],
-[  --enable-libquota	  enable quota support],
+[  --enable-quota	  enable quota support],
 if test "$enableval" = "no"
 then
 	AC_MSG_RESULT([Disabling quota support])

