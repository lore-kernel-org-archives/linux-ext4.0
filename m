From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] configure: Disable uuidd by default
Date: Thu, 16 Jul 2009 19:52:21 +0100
Message-ID: <E1MRWBp-0000yk-N0@zelda.netsplit.com>
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Since util-linux-ng now builds uuidd by default, e2fsprogs should
not do so.

Signed-off-by: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
---
 configure    |   12 ++++--------
 configure.in |    7 +++----
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/configure b/configure
index f3fe992..16eaf6f 100755
--- a/configure
+++ b/configure
@@ -1506,7 +1506,7 @@ Optional Features:
   --enable-fsck           build fsck wrapper program
   --enable-e2initrd-helper build e2initrd-helper program
   --disable-tls           disable use of thread local support
-  --disable-uuidd         disable building the uuid daemon
+  --enable-uuidd         disable building the uuid daemon
   --disable-nls           do not use Native Language Support
   --disable-rpath         do not hardcode runtime library paths
 
@@ -5091,13 +5091,9 @@ $as_echo "Building uuidd" >&6; }
 fi
 
 else
-  cat >>confdefs.h <<\_ACEOF
-#define USE_UUIDD 1
-_ACEOF
-
-UUIDD_CMT=""
-{ $as_echo "$as_me:$LINENO: result: Building uuidd by default" >&5
-$as_echo "Building uuidd by default" >&6; }
+  { $as_echo "$as_me:$LINENO: result: Not building uuidd by default" >&5
+$as_echo "Not building uuidd by default" >&6; }
+UUIDD_CMT="#"
 
 fi
 
diff --git a/configure.in b/configure.in
index 1a7c040..fe845c9 100644
--- a/configure.in
+++ b/configure.in
@@ -641,7 +641,7 @@ dnl
 dnl
 dnl
 AC_ARG_ENABLE([uuidd],
-[  --disable-uuidd         disable building the uuid daemon],
+[  --enable-uuidd         disable building the uuid daemon],
 [if test "$enableval" = "no"
 then
 	AC_MSG_RESULT([Not building uuidd])
@@ -652,9 +652,8 @@ else
 	AC_MSG_RESULT([Building uuidd])
 fi]
 ,
-AC_DEFINE(USE_UUIDD)
-UUIDD_CMT=""
-AC_MSG_RESULT([Building uuidd by default])
+AC_MSG_RESULT([Not building uuidd by default])
+UUIDD_CMT="#"
 )
 AC_SUBST(UUIDD_CMT)
 dnl
-- 
1.6.0.5

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
