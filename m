From: Mark Lord <lkml@rtr.ca>
Subject: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Sat, 01 Aug 2009 10:59:25 -0400
Message-ID: <4A74584D.2010300@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:37763 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZHAO7Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Aug 2009 10:59:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add support for the FIEMAP ioctl for 32-bit user on 64-bit kernel.

When using a 32-bit runtime on top of a 64-bit kernel,
programs like "filefrag" and "hdparm --fibmap" do not work correctly.

This is because there's no compat ioctl entry for the FIEMAP call.
FIEMAP returns file extent info, similar to FIBMAP (but better).

Since FIBMAP itself is b0rked on ext4, this leaves no way for a 32-bit
program to reliably get detailed block information for a file
when run on top of a 64-bit kernel.  This patch addresses the issue.

Once upstream, this patch could also be a candidate for -stable.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/fs/compat_ioctl.c	2009-08-01 10:47:16.601066905 -0400
+++ linux/fs/compat_ioctl.c	2009-08-01 10:49:23.054387926 -0400
@@ -35,6 +35,7 @@
 #include <linux/falloc.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/fiemap.h>
 #include <linux/ppp_defs.h>
 #include <linux/if_ppp.h>
 #include <linux/if_pppox.h>
@@ -1907,6 +1908,7 @@
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
@@ -2805,6 +2807,7 @@
 		goto out_fput;
 #endif
 
+	case FS_IOC_FIEMAP:
 	case FIBMAP:
 	case FIGETBSZ:
 	case FIONREAD:
