From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Tue, 4 Aug 2009 12:39:17 +0200
Message-ID: <200908041239.18238.arnd@arndb.de>
References: <4A74584D.2010300@rtr.ca> <4A775FB9.80600@rtr.ca> <20090803162255.c6d12eda.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Mark Lord <lkml@rtr.ca>, sandeen@redhat.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	sandeen@sandeen.net
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932817AbZHDKjc@vger.kernel.org>
In-Reply-To: <20090803162255.c6d12eda.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tuesday 04 August 2009, Andrew Morton wrote:
> > Well, whichever of the two works best for the maintainers.
> > 
> > We need something for it upstream, and probably back in -stable too.
> > Otherwise this prevents using 64-bit kernels on 32-bit userland,
> > as Linus likes to recommend so often.  ;)
> 
> OK, here's what I have, with a somewhat reworked changelog.
> 
> I assumed that "Josef" == josef@redhat.com.
> 
> Arnd, could you please check that it still looks OK?

Yes, it looks ok as well. The #include is not needed here,
and the difference in compat_sys_ioctl() is that with Eric's
patch, a file system or device driver could in theory implement
its own compat handler for FS_IOC_FIEMAP while it cannot do
that for the native ioctl.

I would like to keep the logic in compat_sys_ioctl in sync with
do_vfs_ioctl, but they have diverged already. I have an experimental
patch set to rework compat_ioctl handling that will also take care
of this.

	Arnd <><
