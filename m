From: akpm@linux-foundation.org
Subject: [merged] compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch removed from -mm tree
Date: Mon, 10 Aug 2009 12:27:29 -0700
Message-ID: <200908101927.n7AJRTT9025994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: sandeen@redhat.com, arnd@arndb.de, jack@suse.cz, josef@redhat.com,
	linux-ext4@vger.kernel.org, lkml@rtr.ca, stable@kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     compat_ioctl: hook up compat handler for FIEMAP ioctl
has been removed from the -mm tree.  Its filename was
     compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat_ioctl: hook up compat handler for FIEMAP ioctl
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

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch

