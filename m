From: Chen Qi <Qi.Chen@windriver.com>
Subject: e2fsprogs: fix cross compilation problem
Date: Thu, 13 Mar 2014 10:01:27 +0800
Message-ID: <1394676087-2624-1-git-send-email-Qi.Chen@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:55767 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbaCMCBZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 22:01:25 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
	by mail1.windriver.com (8.14.5/8.14.5) with ESMTP id s2D21OtH001711
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 19:01:24 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The checking of types in parse-types.sh doesn't make much sense in a
cross-compilation environment, because the generated binary is executed
on build machine.

So even if asm_types.h has got correct statements for types, it's possible
that the generated binary will report an error. Because these types are for
the target machine.

Signed-off-by: Chen Qi <Qi.Chen@windriver.com>
---
 config/parse-types.sh |    6 ++++--
 configure.in          |    6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/config/parse-types.sh b/config/parse-types.sh
index 5076f6c..24d2a99 100755
--- a/config/parse-types.sh
+++ b/config/parse-types.sh
@@ -118,8 +118,10 @@ if ./asm_types
 then
     true
 else
-    echo "Problem detected with asm_types.h"
-    echo "" > asm_types.h
+    if [ "${CROSS_COMPILE}" != "1" ]; then
+	echo "Problem detected with asm_types.h"
+	echo "" > asm_types.h
+    fi
 fi
 rm asm_types.c asm_types
 
diff --git a/configure.in b/configure.in
index 68adf0d..ed1697b 100644
--- a/configure.in
+++ b/configure.in
@@ -953,7 +953,11 @@ AC_SUBST(SIZEOF_LONG)
 AC_SUBST(SIZEOF_LONG_LONG)
 AC_SUBST(SIZEOF_OFF_T)
 AC_C_BIGENDIAN
-BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh $ac_aux_dir/parse-types.sh
+if test $cross_compiling = no; then
+  BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh $ac_aux_dir/parse-types.sh
+else
+  CROSS_COMPILE="1" BUILD_CC="$BUILD_CC" CPP="$CPP" /bin/sh $ac_aux_dir/parse-types.sh
+fi
 ASM_TYPES_HEADER=./asm_types.h
 AC_SUBST_FILE(ASM_TYPES_HEADER)
 dnl
-- 
1.7.9.5

