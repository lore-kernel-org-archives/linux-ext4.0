From: Chris Wright <chrisw@sous-sol.org>
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Fri, 9 Oct 2009 17:09:26 -0700
Message-ID: <20091010000926.GA17547@sequoia.sous-sol.org>
References: <20091009061729.GA31242@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	iommu@lists.linux-foundation.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:53003 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752841AbZJJAKP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Oct 2009 20:10:15 -0400
Content-Disposition: inline
In-Reply-To: <20091009061729.GA31242@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Andy Isaacson (adi@hexapodia.org) wrote:
> Today while running 817b33d38 I got the following (on a Thinkpad X200
> I'd replaced the Dell with, just in case it was previously-good hardware
> going bad).
> 
> [   29.450550] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
> [   30.022328] DRHD: handling fault status reg 3
> [   30.022328] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
> [   30.022328] DMAR:[fault reason 05] PTE Write access is not set
> [   30.146136] DRHD: handling fault status reg 3
> [   30.248938] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
> [   30.248939] DMAR:[fault reason 05] PTE Write access is not set

There's some timing coincidence there, but it's a full 1/2 second between
the ext4 error and the DMAR fault (and there's various DMAR faults
along the way for the same buffer before and after the ext4 error).
That fault is quite typical of a driver bug, and it's the VGA device
(rather its driver) that is culpable.  The IOMMU caught the VGA device
trying to do a DMA write to a buffer mapped r/o.

> The full output of fsck and full dmesg are at the URL below.
> 
> I don't know that DMAR is resulting in my repeated filesystem
> corruption, but it does seem like a potential cause (and would explain
> why I'm seeing this whereas most people aren't, since few people are
> using VT-d *and* i915).

I do use it every day on my primary workstation (x200), and haven't
had any issue (I'm using ext3).

> I see that the BROKEN_GFX_WA code has been removed; do we actually
> believe that the relevant code is working?  Could it be corrupting my
> AHCI DMAs if not?

It should be for your adapter (after 66a4fe0c merged in agp fixes).
While it could still be broken (aside of the initial faults before the
device is even initialized in Linux -- I'm not seeing any faults, btw),
iommu=pt will put all devices in a 1:1 mapped domain and would suppress
the DMAR faults you see (similar to intel_iommu=off, but allowing the
iommu to still be used for pci device assignment).  However, doing that
or enabling the gfx workaround would allow the device to generate invalid
DMA requests since if effectively disables the IOMMU for the gfx device,
which would leave a better opportunity for DMA related corruption.
The earlier fs issues we saw w/ the IOMMU were when it was actively
blocking disk DMA requests, but that's not happening here.

> At the end of the last thread Ted thought that we'd
> lost a write of an inode block; this time the symptoms look different,
> in that I don't see one inode block representing a significant data
> loss (though I'm by no means an expert).
> 
> Complete dmesg etc are at
> http://web.hexapodia.org/~adi/bugs/20091008-ext4-dmar/
> 
> I'll try running with BROKEN_GFX_WA turned back on and see if that
> improves things at all.

thanks,
-chris
