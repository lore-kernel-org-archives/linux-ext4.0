From: =?iso-8859-15?Q?Antonio_Huete_Jim=E9nez?= <ahuete.devel@gmail.com>
Subject: [PATCH] Add support for DragonFly BSD operating system.
Date: Thu, 12 Jul 2012 21:48:37 +0200
Message-ID: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57026 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab2GLTz1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2012 15:55:27 -0400
Received: by weyx8 with SMTP id x8so1969137wey.19
        for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2012 12:55:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Find below a patch to add support for DragonFly BSD to e2fsprogs. In the  
case it gets rejected please indicate a reason so I can get it fixed.

For convenience I've uploaded the patch here:  
http://island.quantumachine.net/~antonioh/archive/patches/0001-Add-support-for-DragonFly-BSD-operating-system.patch

Regards,
Antonio Huete



 From 31838ebfd8dd6a52a98ca083fb20401db82e6398 Mon Sep 17 00:00:00 2001
From: Antonio Huete Jimenez <tuxillo@quantumachine.net>
Date: Thu, 12 Jul 2012 21:33:57 +0200
Subject: [PATCH] Add support for DragonFly BSD operating system.

- Add a new OS tag.
- DragonFly uses DIOCGPART to return disk information.
- Avoid falling to some old FreeBSD 4.x code blocks.

Signed-off-by: Antonio Huete Jimenez <tuxillo@dragonflybsd.org>
---
  lib/blkid/getsize.c     |   15 ++++++++++++++-
  lib/e2p/ostype.c        |    5 +++--
  lib/ext2fs/ext2_fs.h    |    1 +
  lib/ext2fs/getsize.c    |   13 +++++++++++++
  lib/ext2fs/initialize.c |    4 ++++
  lib/ext2fs/unix_io.c    |    2 +-
  misc/mke2fs.c           |    2 ++
  misc/util.c             |    2 +-
  8 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
index f670e1b..9b7cf9f 100644
--- a/lib/blkid/getsize.c
+++ b/lib/blkid/getsize.c
@@ -45,7 +45,9 @@
  #if HAVE_SYS_STAT_H
  #include <sys/stat.h>
  #endif
-
+#ifdef __DragonFly__
+#include <sys/diskslice.h>
+#endif

  #if defined(__linux__) && defined(_IO) && !defined(BLKGETSIZE)
  #define BLKGETSIZE _IO(0x12,96)	/* return device size */
@@ -87,8 +89,10 @@ blkid_loff_t blkid_get_dev_size(int fd)
  #endif
  #ifdef HAVE_SYS_DISKLABEL_H
  	int part = -1;
+#ifndef __DragonFly__
  	struct disklabel lab;
  	struct partition *pp;
+#endif /* __DragonFly__ */
  	char ch;
  	struct stat st;
  #endif /* HAVE_SYS_DISKLABEL_H */
@@ -129,11 +133,19 @@ blkid_loff_t blkid_get_dev_size(int fd)
  		return (off_t)size64;
  #endif /* DIOCGMEDIASIZE */

+/* tested on DragonFly 3.1-DEVELOPMENT i386/X86_64 */
+#ifdef DIOCGPART
+	struct partinfo dp;
+	if (ioctl(fd, DIOCGPART, &dp) >= 0)
+		return (off_t)dp.media_size;
+#endif /* DIOCGPART */
+
  #ifdef FDGETPRM
  	if (ioctl(fd, FDGETPRM, &this_floppy) >= 0)
  		return (blkid_loff_t)this_floppy.size << 9;
  #endif
  #ifdef HAVE_SYS_DISKLABEL_H
+#ifndef __DragonFly__
  	/*
  	 * This code works for FreeBSD 4.11 i386, except for the full device
  	 * (such as /dev/ad0). It doesn't work properly for newer FreeBSD
@@ -151,6 +163,7 @@ blkid_loff_t blkid_get_dev_size(int fd)
  		if (pp->p_size)
  			return pp->p_size << 9;
  	}
+#endif / __DragonFly__ */
  #endif /* HAVE_SYS_DISKLABEL_H */
  	{
  #if defined(HAVE_FSTAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
diff --git a/lib/e2p/ostype.c b/lib/e2p/ostype.c
index d002e75..6d5579a 100644
--- a/lib/e2p/ostype.c
+++ b/lib/e2p/ostype.c
@@ -20,6 +20,7 @@ static const char *os_tab[] =
  	  "Masix",
  	  "FreeBSD",
  	  "Lites",
+	  "DragonFly",
  	  0 };

  /*
@@ -30,7 +31,7 @@ char *e2p_os2string(int os_type)
          const char	*os;
  	char 		*ret;

-	if (os_type <= EXT2_OS_LITES)
+	if (os_type <= EXT2_OS_DRAGONFLY)
  		os = os_tab[os_type];
  	else
  		os = "(unknown os)";
@@ -62,7 +63,7 @@ int main(int argc, char **argv)
  	char 	*s;
  	int	i, os;

-	for (i=0; i <= EXT2_OS_LITES; i++) {
+	for (i=0; i <= EXT2_OS_DRAGONFLY; i++) {
  		s = e2p_os2string(i);
  		os = e2p_string2os(s);
  		printf("%d: %s (%d)\n", i, s, os);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fb3f7cc..d85fb2f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -659,6 +659,7 @@ struct ext2_super_block {
  #define EXT2_OBSO_OS_MASIX	2
  #define EXT2_OS_FREEBSD		3
  #define EXT2_OS_LITES		4
+#define EXT2_OS_DRAGONFLY	5

  /*
   * Revision levels
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 0a7053e..1b7cca2 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -46,6 +46,9 @@
  #include <sys/stat.h>
  #endif
  #include <ctype.h>
+#ifdef __DragonFly__
+#include <sys/diskslice.h>
+#endif

  #if defined(__linux__) && defined(_IO) && !defined(BLKGETSIZE)
  #define BLKGETSIZE _IO(0x12,96)	/* return device size */
@@ -155,8 +158,10 @@ errcode_t ext2fs_get_device_size2(const char *file,  
int blocksize,
  #endif
  #ifdef HAVE_SYS_DISKLABEL_H
  	int part;
+#ifndef __DragonFly__
  	struct disklabel lab;
  	struct partition *pp;
+#endif /*__DragonFly__ */
  	char ch;
  #endif /* HAVE_SYS_DISKLABEL_H */

@@ -228,6 +233,14 @@ errcode_t ext2fs_get_device_size2(const char *file,  
int blocksize,
  			goto out;
  		}
  	}
+#elif defined(DIOCGPART)
+/* DragonFly partition information */
+        struct partinfo dp;
+        if (ioctl(fd, DIOCGPART, &dp) >= 0) {
+		*retblocks = dp.media_size / blocksize;
+		goto out;
+	}
+
  #endif /* defined(DIOCG*) */
  #endif /* HAVE_SYS_DISKLABEL_H */

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index b06371c..e7acb19 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -40,7 +40,11 @@
  #if defined(LITES) 	   &&	defined(EXT2_OS_LITES)
  #define CREATOR_OS EXT2_OS_LITES
  #else
+#if defined(__DragonFly__) &&	defined(EXT2_OS_DRAGONFLY)
+#define CREATOR_OS EXT2_OS_DRAGONFLY
+#else
  #define CREATOR_OS EXT2_OS_LINUX /* by default */
+#endif /* defined(__DragonFly__) &&   defined(EXT2_OS_DRAGONFLY) */
  #endif /* defined(LITES) && defined(EXT2_OS_LITES) */
  #endif /* defined(__FreeBSD__) && defined(EXT2_OS_FREEBSD) */
  #endif /* defined(__GNU__)     && defined(EXT2_OS_HURD) */
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 02570f0..c305a6c 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -554,7 +554,7 @@ static errcode_t unix_open(const char *name, int  
flags, io_channel *channel)
  		io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
  #endif

-#if defined(__CYGWIN__) || defined(__FreeBSD__) ||  
defined(__FreeBSD_kernel__)
+#if defined(__CYGWIN__) || defined(__FreeBSD__) ||  
defined(__FreeBSD_kernel__) || defined(__DragonFly__)
  	/*
  	 * Some operating systems require that the buffers be aligned,
  	 * regardless of O_DIRECT
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..1bd7f6b 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -641,6 +641,8 @@ static int set_os(struct ext2_super_block *sb, char  
*os)
  		sb->s_creator_os = EXT2_OS_FREEBSD;
  	else if (strcasecmp(os, "lites") == 0)
  		sb->s_creator_os = EXT2_OS_LITES;
+	else if (strcasecmp(os, "dragonfly") == 0)
+		sb->s_creator_os = EXT2_OS_DRAGONFLY;
  	else
  		return 0;
  	return 1;
diff --git a/misc/util.c b/misc/util.c
index 6c93e1c..ead4467 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -93,7 +93,7 @@ void check_plausibility(const char *device)
  				"did you specify it correctly?\n"), stderr);
  		exit(1);
  	}
-#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__)
+#if defined(__FreeBSD__) || defined(__FreeBSD_kernel__) ||  
defined(__DragonFly__)
  	/* On FreeBSD, all disk devices are character specials */
  	if (!S_ISBLK(s.st_mode) && !S_ISCHR(s.st_mode))
  #else
-- 
1.7.3.4
