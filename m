From: akpm@linux-foundation.org
Subject: [patch 07/15] compat_ioctl: hook up compat handler for FIEMAP ioctl
Date: Thu, 06 Aug 2009 15:07:37 -0700
Message-ID: <200908062207.n76M7b3d004529@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, sandeen@redhat.com, arnd@arndb.de,
	jack@suse.cz, josef@redhat.com, linux-ext4@vger.kernel.org,
	lkml@rtr.ca, stable@kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbZHFWJK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Aug 2009 18:09:10 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

The FIEMAP_IOC_FIEMAP mapping ioctl was missing a 32-bit compat handler,
which means that 32-bit suerspace on 64-bit kernels cannot use this ioctl
command.

The structure is nicely aligned, padded, and sized, so it is just this
simple.

Tested w/ 32-bit ioctl tester (from Josef) on a 64-bit kernel on ext4.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Mark Lord <lkml@rtr.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Josef Bacik <josef@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/compat_ioctl.c~compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl
+++ a/fs/compat_ioctl.c
@@ -1905,6 +1905,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
_
