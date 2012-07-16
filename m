From: =?iso-8859-15?Q?Antonio_Huete_Jim=E9nez?= <ahuete.devel@gmail.com>
Subject: Re: [PATCH] Add support for DragonFly BSD operating system.
Date: Mon, 16 Jul 2012 02:26:57 +0200
Message-ID: <op.whiji7pcf7p71t@sixfeet.quantumachine.net>
References: <op.whcml3m4f7p71t@sixfeet.quantumachine.net>
 <20120713003026.GA30092@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	"Andreas Dilger" <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58122 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2GPA1C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 15 Jul 2012 20:27:02 -0400
Received: by weyx8 with SMTP id x8so3623132wey.19
        for <linux-ext4@vger.kernel.org>; Sun, 15 Jul 2012 17:27:00 -0700 (PDT)
In-Reply-To: <20120713003026.GA30092@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Theodore, Andreas,

Thanks for taking the time to review the patch. I've split the patch in  
two parts.

- First one to change the tag as recommended by Theodore. There is not  
specific reason for wanting a tag for DragonFly so I also think the idea  
of a 'BSD' tag is nicer. The rest of main BSDs are included now. I've also  
untangled the #ifdef #else's and converted it to a shorter block using  
#elif, as specified by Andreas.

- Second patch fixes the issues I consider necessary for DragonFly BSD to  
be able to format disk/slices in ext2/3/4 format. Andreas, I've followed  
the recommendation of using less #ifdefs, you will see that patch is  
cleaner now. With regards to merging both libraries (ext2fs and blkid) I  
am afraid I have not much time for doing it, sorry.

I've pasted both new patches in this email with the intention of producing  
less traffic in the mailing list, but I'm unsure if this is the correct  
thing to do, opposed to sending one mail per patch.

If there is anything wrong, just let me know and I'll try to correct it.

Best regards,
Antonio Huete

 From 66c7097eaf08fd9c0e2453fb35c2e95939e3303b Mon Sep 17 00:00:00 2001
From: Antonio Huete Jimenez <tuxillo@quantumachine.net>
Date: Mon, 16 Jul 2012 00:50:50 +0200
Subject: [PATCH 1/2] Common BSD tag for FreeBSD, NetBSD, OpenBSD and  
DragonFly BSD.

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
-         "FreeBSD",
+         "BSD",
           "Lites",
           0 };

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fb3f7cc..ca870c9 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -657,7 +657,7 @@ struct ext2_super_block {
  #define EXT2_OS_LINUX          0
  #define EXT2_OS_HURD           1
  #define EXT2_OBSO_OS_MASIX     2
-#define EXT2_OS_FREEBSD                3
+#define EXT2_OS_BSD            3
  #define EXT2_OS_LITES          4

  /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index b06371c..b801494 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -28,23 +28,16 @@
  #include "ext2_fs.h"
  #include "ext2fs.h"

-#if defined(__linux__)    &&   defined(EXT2_OS_LINUX)
-#define CREATOR_OS EXT2_OS_LINUX
-#else
-#if defined(__GNU__)     &&    defined(EXT2_OS_HURD)
+#if defined(__GNU__)     &&     defined(EXT2_OS_HURD)
  #define CREATOR_OS EXT2_OS_HURD
-#else
-#if defined(__FreeBSD__) &&    defined(EXT2_OS_FREEBSD)
-#define CREATOR_OS EXT2_OS_FREEBSD
-#else
-#if defined(LITES)        &&   defined(EXT2_OS_LITES)
+#elif (defined(__FreeBSD__) || defined(__NetBSD__) ||  
defined(__OpenBSD__) \
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
   * Calculate the number of GDT blocks to reserve for online filesystem  
growth.
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7ec8cc2..d7ef0e9 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -638,7 +638,13 @@ static int set_os(struct ext2_super_block *sb, char  
*os)
         else if (strcasecmp(os, "GNU") == 0 || strcasecmp(os, "hurd") == 0)
                 sb->s_creator_os = EXT2_OS_HURD;
         else if (strcasecmp(os, "freebsd") == 0)
-               sb->s_creator_os = EXT2_OS_FREEBSD;
+               sb->s_creator_os = EXT2_OS_BSD;
+       else if (strcasecmp(os, "netbsd") == 0)
+               sb->s_creator_os = EXT2_OS_BSD;
+       else if (strcasecmp(os, "openbsd") == 0)
+               sb->s_creator_os = EXT2_OS_BSD;
+       else if (strcasecmp(os, "dragonfly") == 0)
+               sb->s_creator_os = EXT2_OS_BSD;
         else if (strcasecmp(os, "lites") == 0)
                 sb->s_creator_os = EXT2_OS_LITES;
         else
--
1.7.3.4

 From 2c310b676a8fe9e1f2187aadcfc84cbeca07539d Mon Sep 17 00:00:00 2001
From: Antonio Huete Jimenez <tuxillo@quantumachine.net>
Date: Mon, 16 Jul 2012 01:25:55 +0200
Subject: [PATCH 2/2] Fix to support DragonFly BSD

- DragonFly uses DIOCGPART to return disk information.

Signed-off-by: Antonio Huete Jimenez <tuxillo@dragonflybsd.org>
---
  lib/blkid/getsize.c  |   15 ++++++++++++---
  lib/ext2fs/getsize.c |   20 ++++++++++++++++----
  lib/ext2fs/unix_io.c |    2 +-
  misc/util.c          |    2 +-
  4 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
index f670e1b..0536968 100644
--- a/lib/blkid/getsize.c
+++ b/lib/blkid/getsize.c
@@ -46,6 +46,9 @@
  #include <sys/stat.h>
  #endif

+#ifdef __DragonFly__
+#include <sys/diskslice.h>
+#endif

  #if defined(__linux__) && defined(_IO) && !defined(BLKGETSIZE)
  #define BLKGETSIZE _IO(0x12,96)        /* return device size */
@@ -85,11 +88,10 @@ blkid_loff_t blkid_get_dev_size(int fd)
  #ifdef FDGETPRM
         struct floppy_struct this_floppy;
  #endif
-#ifdef HAVE_SYS_DISKLABEL_H
+#if defined(HAVE_SYS_DISKLABEL_H) && !defined(__DragonFly__)
         int part = -1;
         struct disklabel lab;
         struct partition *pp;
-       char ch;
         struct stat st;
  #endif /* HAVE_SYS_DISKLABEL_H */

@@ -129,11 +131,18 @@ blkid_loff_t blkid_get_dev_size(int fd)
                 return (off_t)size64;
  #endif /* DIOCGMEDIASIZE */

+/* tested on DragonFly 3.1-DEVELOPMENT i386/X86_64 */
+#ifdef DIOCGPART
+       struct partinfo dp;
+       if (ioctl(fd, DIOCGPART, &dp) >= 0)
+               return (off_t)dp.media_size;
+#endif /* DIOCGPART */
+
  #ifdef FDGETPRM
         if (ioctl(fd, FDGETPRM, &this_floppy) >= 0)
                 return (blkid_loff_t)this_floppy.size << 9;
  #endif
-#ifdef HAVE_SYS_DISKLABEL_H
+#if defined(HAVE_SYS_DISKLABEL_H) && !defined(__DragonFly__)
         /*
          * This code works for FreeBSD 4.11 i386, except for the full  
device
          * (such as /dev/ad0). It doesn't work properly for newer FreeBSD
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 0a7053e..ce9404e 100644
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
  #define BLKGETSIZE _IO(0x12,96)        /* return device size */
@@ -153,12 +156,12 @@ errcode_t ext2fs_get_device_size2(const char *file,  
int blocksize,
  #ifdef FDGETPRM
         struct floppy_struct this_floppy;
  #endif
-#ifdef HAVE_SYS_DISKLABEL_H
+#if defined(HAVE_SYS_DISKLABEL_H) && !defined(__DragonFly__)
         int part;
         struct disklabel lab;
         struct partition *pp;
         char ch;
-#endif /* HAVE_SYS_DISKLABEL_H */
+#endif /* HAVE_SYS_DISKLABEL_H && !defined(__DragonFly__) */

         fd = ext2fs_open_file(file, O_RDONLY, 0);
         if (fd < 0)
@@ -199,7 +202,7 @@ errcode_t ext2fs_get_device_size2(const char *file,  
int blocksize,
         }
  #endif

-#ifdef HAVE_SYS_DISKLABEL_H
+#if defined(HAVE_SYS_DISKLABEL_H)
  #if defined(DIOCGMEDIASIZE)
         {
             off_t ms;
@@ -228,8 +231,17 @@ errcode_t ext2fs_get_device_size2(const char *file,  
int blocksize,
                         goto out;
                 }
         }
+#elif defined(DIOCGPART)
+       /* DragonFly partition information */
+       struct partinfo dp;
+       if (ioctl(fd, DIOCGPART, &dp) >= 0) {
+               *retblocks = dp.media_size / blocksize;
+               printf("success!\n");
+               goto out;
+       }
+
  #endif /* defined(DIOCG*) */
-#endif /* HAVE_SYS_DISKLABEL_H */
+#endif /* HAVE_SYS_DISKLABEL_H && !defined(__DragonFly__) */

         {
                 ext2fs_struct_stat st;
diff --git a/lib/ext2fs/unix_io.c b/lib/ext2fs/unix_io.c
index 02570f0..ad28bc3 100644
--- a/lib/ext2fs/unix_io.c
+++ b/lib/ext2fs/unix_io.c
@@ -554,7 +554,7 @@ static errcode_t unix_open(const char *name, int  
flags, io_channel *channel)
                 io->flags |= CHANNEL_FLAGS_DISCARD_ZEROES;
  #endif

-#if defined(__CYGWIN__) || defined(__FreeBSD__) ||  
defined(__FreeBSD_kernel__)
+#if defined(__CYGWIN__) || defined(__FreeBSD__) ||  
defined(__FreeBSD_kernel__) || defined(__DragonFly)
         /*
          * Some operating systems require that the buffers be aligned,
          * regardless of O_DIRECT
diff --git a/misc/util.c b/misc/util.c
index 6c93e1c..ead4467 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -93,7 +93,7 @@ void check_plausibility(const char *device)
                                 "did you specify it correctly?\n"),  
stderr);
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
