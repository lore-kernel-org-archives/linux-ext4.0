From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH] stable - ext[234]: Avoid printk floods in the
	face of directory corruption (CVE-2008-3528)
Date: Wed, 22 Oct 2008 10:37:52 -0700
Message-ID: <20081022173752.GA10587@kroah.com>
References: <48FF42B8.3030606@redhat.com> <20081022161433.GB29489@kroah.com> <48FF52F4.10702@redhat.com> <20081022163421.GA28836@kroah.com> <48FF644A.50801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@kernel.org, ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:49737 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757888AbYJVRnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Oct 2008 13:43:37 -0400
Content-Disposition: inline
In-Reply-To: <48FF644A.50801@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:35:06PM -0500, Eric Sandeen wrote:
> Greg KH wrote:
> > On Wed, Oct 22, 2008 at 11:21:08AM -0500, Eric Sandeen wrote:
> >> Greg KH wrote:
> >>> On Wed, Oct 22, 2008 at 10:11:52AM -0500, Eric Sandeen wrote:
> >>>> This is a trivial backport of the following upstream commits:
> >>>>
> >>>> - bd39597cbd42a784105a04010100e27267481c67 (ext2)
> >>>> - cdbf6dba28e8e6268c8420857696309470009fd9 (ext3)
> >>>> - 9d9f177572d9e4eba0f2e18523b44f90dd51fe74 (ext4)
> >>>>
> >>>> This addresses CVE-2008-3528
> >>>>
> >>>> ext[234]: Avoid printk floods in the face of directory corruption
> >>> For what kernel releases is this applicable?  .27? .26? .25?  Earlier?
> >> Sorry.. it is applicable to pretty much any kernel in the past :)  .27
> >> certainly (that's what the patch is against), .26, .25.... yes.
> >>
> >> It's not a particularly dangerous condition - you have to somehow get
> >> the administrator to mount the filesystem before you can trigger the
> >> "exploit" (which is a DoS, essentially) - so, I don't know if it's worth
> >> porting back to the dawn of time...
> > 
> > Well, I will not port it back to older kernels than .25, so that's not a
> > big deal.
> > 
> > As for the "admin mount a filesystem", you could put an ext2/3 fs on a
> > usb stick and plug it into a box.  It will be mounted automatically, no
> > admin rights required, and the DoS would happen, right?
> 
> If I wanted to DoS a box sitting in front of me, I'd just pull the plug.

Yes, the fun "physical access" issue, right?

But for some, who run Linux in a "kiosk" mode, or in semi-secured places
like university labs, something like this would matter, so you might
want to notify the distros of this issue through vendor-sec and let them
make up their minds if they wish to backport the fixes to their
supported releases.

thanks,

greg k-h
