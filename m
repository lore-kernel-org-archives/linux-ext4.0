From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Mon, 3 Aug 2009 16:22:55 -0700
Message-ID: <20090803162255.c6d12eda.akpm@linux-foundation.org>
References: <4A74584D.2010300@rtr.ca>
	<4A7722DF.80704@rtr.ca>
	<4A7725AF.6090106@redhat.com>
	<4A775FB9.80600@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sandeen@redhat.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, sandeen@sandeen.net,
	Arnd Bergmann <arnd@arndb.de>
To: Mark Lord <lkml@rtr.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbZHCXXY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Aug 2009 19:23:24 -0400
In-Reply-To: <4A775FB9.80600@rtr.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 03 Aug 2009 18:07:53 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Eric Sandeen wrote:
> > Mark Lord wrote:
> >> (resending, no ack from anyone first time around).
> > 
> > I had previously sent a fix for this to the ext4 list as well, although
> > w/o the added case for compat_ioctl or the extra #include.
> > 
> > Because this ioctl should be 100% compat everywhere, I don't -think-
> > it's needed, and
> > 
> > http://marc.info/?l=linux-ext4&m=124872536713005&w=2

mutter. I don't read linux-fsdevel much.

> > suffices....
> ..
> 
> Well, whichever of the two works best for the maintainers.
> 
> We need *something* for it upstream, and probably back in -stable too.
> Otherwise this prevents using 64-bit kernels on 32-bit userland,
> as Linus likes to recommend so often.  ;)

OK, here's what I have, with a somewhat reworked changelog.

I assumed that "Josef" == josef@redhat.com.

Arnd, could you please check that it still looks OK?

Thanks.


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

