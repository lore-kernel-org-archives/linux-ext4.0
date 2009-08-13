From: Greg KH <gregkh@suse.de>
Subject: [patch 16/28] compat_ioctl: hook up compat handler for FIEMAP ioctl
Date: Thu, 13 Aug 2009 12:40:37 -0700
Message-ID: <20090813194338.094383349@mini.kroah.org>
References: <20090813194021.446758568@mini.kroah.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Eric Sandeen <sandeen@redhat.com>,
	<linux-ext4@vger.kernel.org>, Mark Lord <lkml@rtr.ca>,
	Arnd Bergmann <arnd@arndb.de>, Josef Bacik <josef@redhat.com>,
	Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755812AbZHMTvv@vger.kernel.org>
Content-Disposition: inline; filename=compat_ioctl-hook-up-compat-handler-for-fiemap-ioctl.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
@@ -1910,6 +1910,7 @@ COMPATIBLE_IOCTL(FIONCLEX)
 COMPATIBLE_IOCTL(FIOASYNC)
 COMPATIBLE_IOCTL(FIONBIO)
 COMPATIBLE_IOCTL(FIONREAD)  /* This is also TIOCINQ */
+COMPATIBLE_IOCTL(FS_IOC_FIEMAP)
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
