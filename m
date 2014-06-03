From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] e2fsprogs: Add INCLUDES to BUILD_CFLAGS when cross-compiling
Date: Tue,  3 Jun 2014 18:51:59 -0300
Message-ID: <1401832319-2247-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:39932 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaFCWEF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2014 18:04:05 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need $INCLUDES in BUILD_CFLAGS otherwise cross-compilation is broken
now that util/subst.c uses config.h (from commit 2873927d15).

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 configure.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.in b/configure.in
index 448a292..8bac870 100644
--- a/configure.in
+++ b/configure.in
@@ -1382,7 +1382,7 @@ if test $cross_compiling = no; then
    BUILD_CFLAGS="$CFLAGS $CPPFLAGS $INCLUDES -DHAVE_CONFIG_H"
    BUILD_LDFLAGS="$LDFLAGS"
 else
-   BUILD_CFLAGS=
+   BUILD_CFLAGS="$INCLUDES -DHAVE_CONFIG_H"
    BUILD_LDFLAGS=
 fi
 AC_SUBST(BUILD_CFLAGS)
-- 
1.8.5.5

