From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] blkid: [v2] remove unnecessary header and comment
Date: Wed, 11 Jun 2014 12:59:05 -0600
Message-ID: <1402513145-33627-1-git-send-email-adilger@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:46839 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaFKTAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2014 15:00:35 -0400
Received: by mail-pa0-f44.google.com with SMTP id bj1so114511pad.31
        for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2014 12:00:35 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106002191d9348b.cg.shawcable.net. [96.51.76.157])
        by mx.google.com with ESMTPSA id fe2sm76293661pbc.68.2014.06.11.12.00.33
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 11 Jun 2014 12:00:34 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The LIST_HEAD macro is not directly used in getsize.c, so
<sys/queue.h> is not needed at all, and could cause confusion at
some later point if the Linux-style list macros are ever used.

Build was verified on MacOS which defined HAVE_SYS_DISK_H true.
I manually inspected the sources for recent *BSD headers to check
if this was needed there or not.  MacOS and FreeBSD <sys/disk.h>
do not use lists at all.  NetBSD and OpenBSD <sys/disk.h> and all
of the <sys/mount.h> headers include <sys/queue.h> internally.

I used http://fxr.watson.org/fxr/source/sys/mount.h?v={OSTYPE}
as a reference, checking both old and new *BSD versions.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
configure            | 20 +-------------------
configure.in         |  9 ++-------
lib/blkid/getsize.c  |  4 ----
lib/config.h.in      |  3 ---
lib/ext2fs/getsize.c |  3 ---
5 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/configure b/configure
index 1b0ee62..5b6e5d8 100755
--- a/configure
+++ b/configure
@@ -10397,7 +10397,7 @@ fi
done

fi
-for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disklabel.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/prctl.h 	sys/queue.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
+for ac_header in  	dirent.h 	errno.h 	execinfo.h 	getopt.h 	malloc.h 	mntent.h 	paths.h 	semaphore.h 	setjmp.h 	signal.h 	stdarg.h 	stdint.h 	stdlib.h 	termios.h 	termio.h 	unistd.h 	utime.h 	linux/falloc.h 	linux/fd.h 	linux/major.h 	linux/loop.h 	net/if_dl.h 	netinet/in.h 	sys/disk.h	sys/disklabel.h 	sys/file.h 	sys/ioctl.h 	sys/mkdev.h 	sys/mman.h 	sys/mount.h	sys/prctl.h 	sys/resource.h 	sys/select.h 	sys/socket.h 	sys/sockio.h 	sys/stat.h 	sys/syscall.h 	sys/sysmacros.h 	sys/time.h 	sys/types.h 	sys/un.h 	sys/wait.h
do :
  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
@@ -10410,24 +10410,6 @@ fi

done

-for ac_header in sys/disk.h sys/mount.h
-do :
-  as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
-ac_fn_c_check_header_compile "$LINENO" "$ac_header" "$as_ac_Header" "
-#if HAVE_SYS_QUEUE_H
-#include <sys/queue.h>
-#endif
-
-"
-if eval test \"x\$"$as_ac_Header"\" = x"yes"; then :
-  cat >>confdefs.h <<_ACEOF
-#define `$as_echo "HAVE_$ac_header" | $as_tr_cpp` 1
-_ACEOF
-
-fi
-
-done
-
for ac_header in net/if.h
do :
  ac_fn_c_check_header_compile "$LINENO" "net/if.h" "ac_cv_header_net_if_h" "
diff --git a/configure.in b/configure.in
index 6592e70..45e1b61 100644
--- a/configure.in
+++ b/configure.in
@@ -895,12 +895,13 @@ AC_CHECK_HEADERS(m4_flatten([
 	net/if_dl.h
 	netinet/in.h
 	sys/disklabel.h
+	sys/disk.h
 	sys/file.h
 	sys/ioctl.h
 	sys/mkdev.h
 	sys/mman.h
+	sys/mount.h
 	sys/prctl.h
-	sys/queue.h
 	sys/resource.h
 	sys/select.h
 	sys/socket.h
@@ -913,12 +914,6 @@ AC_CHECK_HEADERS(m4_flatten([
 	sys/un.h
 	sys/wait.h
]))
-AC_CHECK_HEADERS(sys/disk.h sys/mount.h,,,
-[[
-#if HAVE_SYS_QUEUE_H
-#include <sys/queue.h>
-#endif
-]])
AC_CHECK_HEADERS(net/if.h,,,
[[
#if HAVE_SYS_TYPES_H
diff --git a/lib/blkid/getsize.c b/lib/blkid/getsize.c
index c2a8f72..a5c40aa 100644
--- a/lib/blkid/getsize.c
+++ b/lib/blkid/getsize.c
@@ -12,7 +12,6 @@
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE

-/* include this before sys/queues.h! */
#include "config.h"
#include "blkidP.h"

@@ -34,9 +33,6 @@
#include <sys/disklabel.h>
#endif
#ifdef HAVE_SYS_DISK_H
-#ifdef HAVE_SYS_QUEUE_H
-#include <sys/queue.h> /* for LIST_HEAD */
-#endif
#include <sys/disk.h>
#endif
#ifdef __linux__
diff --git a/lib/config.h.in b/lib/config.h.in
index 92b3c49..f1d032d 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -432,9 +432,6 @@
/* Define to 1 if you have the <sys/prctl.h> header file. */
#undef HAVE_SYS_PRCTL_H

-/* Define to 1 if you have the <sys/queue.h> header file. */
-#undef HAVE_SYS_QUEUE_H
