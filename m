From: Scott James Remnant <scott@ubuntu.com>
Subject: [PATCH] configure: Disable fsck wrapper on Linux by default
Date: Thu, 16 Jul 2009 19:50:15 +0100
Message-ID: <E1MRWBp-0000yS-Dx@zelda.netsplit.com>
Cc: Theodore Tso <tytso@mit.edu>, util-linux-ng@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:60101 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032AbZGPTBJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 16 Jul 2009 15:01:09 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since util-linux-ng now builds its fsck wrapper by default, e2fsprogs
should not do so on Linux (it already does not on Hurd).

Signed-off-by: Scott James Remnant <scott@ubuntu.com>
---
 configure    |    6 +++---
 configure.in |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 5c272d8..9a29609 100755
--- a/configure
+++ b/configure
@@ -4855,15 +4855,15 @@ fi
 
 else
   case "$host_os" in
-  gnu*)
+  gnu*|linux-gnu)
     FSCK_PROG='' FSCK_MAN=''
     { $as_echo "$as_me:$LINENO: result: Not building fsck wrapper by default" >&5
 $as_echo "Not building fsck wrapper by default" >&6; }
     ;;
   *)
     FSCK_PROG=fsck FSCK_MAN=fsck.8
-    { $as_echo "$as_me:$LINENO: result: Building fsck wrapper by default" >&5
-$as_echo "Building fsck wrapper by default" >&6; }
+    { $as_echo "$as_me:$LINENO: result: Building fsck wrapper by default)" >&5
+$as_echo "Building fsck wrapper by default)" >&6; }
 esac
 
 fi
diff --git a/configure.in b/configure.in
index 25b9427..d9990b4 100644
--- a/configure.in
+++ b/configure.in
@@ -576,13 +576,13 @@ else
 fi]
 ,
 [case "$host_os" in
-  gnu*)
+  gnu*|linux-gnu)
     FSCK_PROG='' FSCK_MAN=''
     AC_MSG_RESULT([Not building fsck wrapper by default])
     ;;
   *)
     FSCK_PROG=fsck FSCK_MAN=fsck.8
-    AC_MSG_RESULT([Building fsck wrapper by default])
+    AC_MSG_RESULT([Building fsck wrapper by default)])
 esac]
 )
 AC_SUBST(FSCK_PROG)
-- 
1.6.0.5

