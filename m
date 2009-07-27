From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] hook up compat handler for FIEMAP ioctl
Date: Mon, 27 Jul 2009 15:09:22 -0500
Message-ID: <4A6E0972.5010803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50525 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZG0UJY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jul 2009 16:09:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The FIEMAP_IOC_FIEMAP mapping ioctl was missing a 32-bit
compat handler; the structure is nicely aligned, padded,
and sized, so it should be just this simple.

Tested w/ 32-bit ioctl tester (from Josef) on a 64-bit
kernel on ext4.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f28f070..f91fd51 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1905,6 +1905,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)

