From: <gregkh@suse.de>
Subject: patch compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch added to 2.6.30-stable tree
Date: Tue, 11 Aug 2009 14:19:59 -0700
Message-ID: <20090811212116.D2EC548BCE@coco.kroah.org>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: sandeen@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
	gregkh@suse.de, jack@suse.cz, josef@redhat.com,
	linux-ext4@vger.kernel.org, lkml@rtr.ca,
	torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:51204 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZHKVVQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2009 17:21:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: compat_ioctl: hook up compat handler for FIEMAP ioctl

to the 2.6.30-stable tree.  Its filename is

    compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From 69130c7cf96ea853dc5be599dd6a4b98907d39cc Mon Sep 17 00:00:00 2001
From: Eric Sandeen <sandeen@redhat.com>
Date: Thu, 6 Aug 2009 15:07:37 -0700
Subject: compat_ioctl: hook up compat handler for FIEMAP ioctl

From: Eric Sandeen <sandeen@redhat.com>

commit 69130c7cf96ea853dc5be599dd6a4b98907d39cc upstream.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1915,6 +1915,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)


Patches currently in stable-queue which might be from sandeen@redhat.com are

queue-2.6.30/hugetlbfs-fix-i_blocks-accounting.patch
queue-2.6.30/compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch
