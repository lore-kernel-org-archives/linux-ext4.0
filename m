From: David Chinner <dgc@sgi.com>
Subject: Re: [xfs-masters] [RFC: 2.6 patch] make the *FS_SECURITY options no longer user visible
Date: Thu, 2 Aug 2007 22:21:22 +1000
Message-ID: <20070802122122.GR12413810@sgi.com>
References: <20070729150209.GS16817@stusta.de> <20070729232905.GG31489@sgi.com> <1185798467.15215.12.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
	chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
	jmorris@namei.org, eparis@parisplace.org,
	linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, jffs-dev@axis.com
To: Stephen Smalley <sds@tycho.nsa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37091 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754717AbXHBMVx (ORCPT
	<rfc822;@relay.sgi.com:linux-ext4@vger.kernel.org>);
	Thu, 2 Aug 2007 08:21:53 -0400
Content-Disposition: inline
In-Reply-To: <1185798467.15215.12.camel@moss-spartans.epoch.ncsc.mil>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 30, 2007 at 08:27:47AM -0400, Stephen Smalley wrote:
> On Mon, 2007-07-30 at 09:29 +1000, David Chinner wrote:
> > On Sun, Jul 29, 2007 at 05:02:09PM +0200, Adrian Bunk wrote:
> > > Please correct me if any of the following assumptions is wrong:
> > > - SELinux is currently the only user of filesystem security labels
> > >   shipped with the Linux kernel
> > > - if a user has SELinux enabled he wants his filesystems to support
> > >   security labels
> > > 
> > > Based on these assumption, it doesn't make sense to have the
> > > *FS_SECURITY user visible since we can perfectly determine automatically 
> > > when turning them on makes sense.
> > 
> > Hmmm. The code in XFS is not dependent on selinux, but this change
> > would mean that testing the security xattr namespace would require a
> > selinux enabled kernel.
> > 
> > I agree that the default for these should be "y" and selected if
> > selinux is enabled, but forcing us to use selinux enabled kernels
> > (on distro's that may not support selinux) just to test the
> > security xattr namespace is a bit of a pain.
> 
> You can enable SECURITY_SELINUX in the kernel config but still have it
> boot disabled by default via SECURITY_SELINUX_BOOTPARAM_VALUE=0.

Ok, that shouldn't cause a problem then. Objection withdrawn. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
