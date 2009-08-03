From: akpm@linux-foundation.org
Subject: + compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch added to -mm tree
Date: Mon, 03 Aug 2009 16:22:59 -0700
Message-ID: <200908032322.n73NMx7P016438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: sandeen@redhat.com, arnd@arndb.de, jack@suse.cz, josef@redhat.com,
	linux-ext4@vger.kernel.org, lkml@rtr.ca, stable@kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     compat_ioctl: hook up compat handler for FIEMAP ioctl
has been added to the -mm tree.  Its filename is
     compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1838,6 +1838,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
_

Patches currently in -mm which might be from sandeen@redhat.com are

vfs-allow-file-truncations-when-both-suid-and-write-permissions-set.patch
compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch

