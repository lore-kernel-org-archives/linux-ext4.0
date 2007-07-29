From: David Chinner <dgc@sgi.com>
Subject: Re: [xfs-masters] [RFC: 2.6 patch] make the *FS_SECURITY options no longer user visible
Date: Mon, 30 Jul 2007 09:29:05 +1000
Message-ID: <20070729232905.GG31489@sgi.com>
References: <20070729150209.GS16817@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
	sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, jffs-dev@axis.com
To: xfs-masters@oss.sgi.com
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070729150209.GS16817@stusta.de>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jul 29, 2007 at 05:02:09PM +0200, Adrian Bunk wrote:
> Please correct me if any of the following assumptions is wrong:
> - SELinux is currently the only user of filesystem security labels
>   shipped with the Linux kernel
> - if a user has SELinux enabled he wants his filesystems to support
>   security labels
> 
> Based on these assumption, it doesn't make sense to have the
> *FS_SECURITY user visible since we can perfectly determine automatically 
> when turning them on makes sense.

Hmmm. The code in XFS is not dependent on selinux, but this change
would mean that testing the security xattr namespace would require a
selinux enabled kernel.

I agree that the default for these should be "y" and selected if
selinux is enabled, but forcing us to use selinux enabled kernels
(on distro's that may not support selinux) just to test the
security xattr namespace is a bit of a pain.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
