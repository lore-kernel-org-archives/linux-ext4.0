From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] libquota: don't include system quota.h header
Date: Fri, 24 Feb 2012 00:43:52 -0700
Message-ID: <1330069432-35919-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:3689 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2BXHnx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 24 Feb 2012 02:43:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Don't use the system <sys/quota.h> header in mkquota.c, since there
is a local e2fsprogs version of quota.h that is already included and
has the desired quota constants, and avoids symbol conflicts with the
system <sys/quota.h> on other platforms (in particular OSX).

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 configure           |    2 +-
 configure.in        |    2 +-
 lib/quota/mkquota.c |    3 ---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 9f5eeb5..4b1939c 100755
--- a/configure
+++ b/configure
@@ -10251,7 +10251,7 @@ fi
 done
 
 fi
-for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
+for ac_header in dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h
 do :
   as_ac_Header=`$as_echo "ac_cv_header_$ac_header" | $as_tr_sh`
 ac_fn_c_check_header_mongrel "$LINENO" "$ac_header" "$as_ac_Header" "$ac_includes_default"
diff --git a/configure.in b/configure.in
index c304a8d..9fb29cb 100644
--- a/configure.in
+++ b/configure.in
@@ -784,7 +784,7 @@ if test $cross_compiling = no; then
 else
   AC_CHECK_PROGS(BUILD_CC, gcc cc)
 fi
-AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/quota.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
+AC_CHECK_HEADERS(dirent.h errno.h execinfo.h getopt.h malloc.h mntent.h paths.h semaphore.h setjmp.h signal.h stdarg.h stdint.h stdlib.h termios.h termio.h unistd.h utime.h linux/falloc.h linux/fd.h linux/major.h net/if_dl.h netinet/in.h sys/disklabel.h sys/file.h sys/ioctl.h sys/mkdev.h sys/mman.h sys/prctl.h sys/queue.h sys/resource.h sys/select.h sys/socket.h sys/sockio.h sys/stat.h sys/syscall.h sys/sysmacros.h sys/time.h sys/types.h sys/un.h sys/wait.h)
 AC_CHECK_HEADERS(sys/disk.h sys/mount.h,,,
 [[
 #if HAVE_SYS_QUEUE_H
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index ac7288c..fbfde92 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -6,9 +6,6 @@
 #include "config.h"
 #include <sys/types.h>
 #include <sys/stat.h>
-#ifdef HAVE_SYS_QUOTA_H
-#include <sys/quota.h>
-#endif
 #include <unistd.h>
 #include <errno.h>
 #include <string.h>
-- 
1.7.2

