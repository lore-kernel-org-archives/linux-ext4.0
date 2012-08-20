From: Antonio Huete Jimenez <tuxillo@gmail.com>
Subject: [PATCH] Common BSD tag for FreeBSD, NetBSD, OpenBSD and DragonFly BSD.
Date: Mon, 20 Aug 2012 13:10:10 +0200
Message-ID: <1345461010-63183-1-git-send-email-tuxillo@quantumachine.net>
Cc: Antonio Huete Jimenez <tuxillo@quantumachine.net>,
	Antonio Huete Jimenez <tuxillo@dragonflybsd.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55790 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2HTLKn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 07:10:43 -0400
Received: by wibhr14 with SMTP id hr14so3583300wib.1
        for <linux-ext4@vger.kernel.org>; Mon, 20 Aug 2012 04:10:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- All BSD will appear now as "BSD" under the OS creator field.
- Minor adjustments to multiple #if's

Signed-off-by: Antonio Huete Jimenez <tuxillo@dragonflybsd.org>
---
 lib/e2p/ostype.c        |    2 +-
 lib/ext2fs/ext2_fs.h    |    2 +-
 lib/ext2fs/initialize.c |   19 ++++++-------------
 misc/mke2fs.c           |    8 +++++++-
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
index d002e75..f9105fd 100644
--- a/lib/e2p/ostype.c
+++ b/lib/e2p/ostype.c
@@ -18,7 +18,7 @@ static const char *os_tab[] =
 	{ "Linux",
 	  "Hurd",
 	  "Masix",
-	  "FreeBSD",
+	  "BSD",
 	  "Lites",
 	  0 };
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 5b6e315..3f510f9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -680,7 +680,7 @@ struct ext2_super_block {
 #define EXT2_OS_LINUX		0
 #define EXT2_OS_HURD		1
 #define EXT2_OBSO_OS_MASIX	2
-#define EXT2_OS_FREEBSD		3
+#define EXT2_OS_BSD		3
 #define EXT2_OS_LITES		4
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 80bff0e..79047d9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -28,23 +28,16 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
-#if defined(__linux__)    &&	defined(EXT2_OS_LINUX)
-#define CREATOR_OS EXT2_OS_LINUX
-#else
-#if defined(__GNU__)     &&	defined(EXT2_OS_HURD)
+#if defined(__GNU__)     &&     defined(EXT2_OS_HURD)
 #define CREATOR_OS EXT2_OS_HURD
-#else
-#if defined(__FreeBSD__) &&	defined(EXT2_OS_FREEBSD)
-#define CREATOR_OS EXT2_OS_FREEBSD
-#else
-#if defined(LITES) 	   &&	defined(EXT2_OS_LITES)
+#elif (defined(__FreeBSD__) || defined(__NetBSD__) || defined(__OpenBSD__) \
+    || defined(__DragonFly__)) && defined(EXT2_OS_BSD)
+#define CREATOR_OS EXT2_OS_BSD
+#elif defined(LITES)         &&   defined(EXT2_OS_LITES)
 #define CREATOR_OS EXT2_OS_LITES
 #else
 #define CREATOR_OS EXT2_OS_LINUX /* by default */
-#endif /* defined(LITES) && defined(EXT2_OS_LITES) */
-#endif /* defined(__FreeBSD__) && defined(EXT2_OS_FREEBSD) */
-#endif /* defined(__GNU__)     && defined(EXT2_OS_HURD) */
-#endif /* defined(__linux__)   && defined(EXT2_OS_LINUX) */
+#endif
 
 /*
  * Calculate the number of GDT blocks to reserve for online filesystem growth.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 072e656..3c03a8d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -665,7 +665,13 @@ static int set_os(struct ext2_super_block *sb, char *os)
 	else if (strcasecmp(os, "GNU") == 0 || strcasecmp(os, "hurd") == 0)
 		sb->s_creator_os = EXT2_OS_HURD;
 	else if (strcasecmp(os, "freebsd") == 0)
-		sb->s_creator_os = EXT2_OS_FREEBSD;
+		sb->s_creator_os = EXT2_OS_BSD;
+	else if (strcasecmp(os, "netbsd") == 0)
+		sb->s_creator_os = EXT2_OS_BSD;
+	else if (strcasecmp(os, "openbsd") == 0)
+		sb->s_creator_os = EXT2_OS_BSD;
+	else if (strcasecmp(os, "dragonfly") == 0)
+		sb->s_creator_os = EXT2_OS_BSD;
 	else if (strcasecmp(os, "lites") == 0)
 		sb->s_creator_os = EXT2_OS_LITES;
 	else
-- 
1.7.7.2

