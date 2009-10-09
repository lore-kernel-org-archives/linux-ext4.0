From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Fri, 9 Oct 2009 16:37:07 -0700
Message-ID: <20091009233707.GA24745@hexapodia.org>
References: <20091009061729.GA31242@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	iommu@lists.linux-foundation.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761600AbZJIXhp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091009061729.GA31242@hexapodia.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 08, 2009 at 11:17:29PM -0700, Andy Isaacson wrote:
> I'm testing DMAR support on 2.6.32 on Intel VT-d laptop platforms.  It
> was pretty stable circa 2.6.31-rc5 (we have dozens of machines running
> 2.6.31-rc8), but in the last two weeks I've had a bunch of instability
> on Linus' tip kernels that looked potentially like IOMMU badness.
> 
> For example,
> <20090928191644.GR12922@hexapodia.org>
> http://lkml.org/lkml/2009/9/28/201
> 
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
> 
> The full output of fsck and full dmesg are at the URL below.

I also have a "e2image -r" for this filesystem.  Please let me know if
you'd like any further information.

-andy
