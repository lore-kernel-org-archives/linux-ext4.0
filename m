From: Bhavesh Davda <bhavesh@vmware.com>
Subject: RE: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Wed, 14 Oct 2009 08:26:27 -0700
Message-ID: <8B1F619C9F5F454E81D90D3C161698D7017DD55F68@EXCH-MBX-3.vmware.com>
References: <20091009061729.GA31242@hexapodia.org>
	<20091010000926.GA17547@sequoia.sous-sol.org>
	<20091010014714.GG30557@hexapodia.org>
 <1255522166.4523.238.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: Chris Wright <chrisw@sous-sol.org>,
	"iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934525AbZJNP1J@vger.kernel.org>
In-Reply-To: <1255522166.4523.238.camel@macbook.infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry if this is unrelated, but I'm also seeing a IOMMU PTE Write fault on my Lenovo x200 booted into 2.6.32-rc4 early on boot. I'm just using ext3, and no visible file system corruptioin so far.

[    0.208727] DMAR: Forcing write-buffer flush capability
...
[    0.221299] DMAR: Host address width 36
[    0.221299] DMAR: DRHD base: 0x000000feb03000 flags: 0x0
[    0.221299] IOMMU feb03000: ver 1:0 cap c9008020e30260 ecap 1000
[    0.221299] DMAR: DRHD base: 0x000000feb01000 flags: 0x0
[    0.221299] IOMMU feb01000: ver 1:0 cap c0000020630260 ecap 1000
[    0.221299] DMAR: DRHD base: 0x000000feb00000 flags: 0x0
[    0.221299] IOMMU feb00000: ver 1:0 cap c0000020630270 ecap 1000
[    0.221299] DMAR: DRHD base: 0x000000feb02000 flags: 0x1
[    0.221299] IOMMU feb02000: ver 1:0 cap c9008020630260 ecap 1000
[    0.221299] DMAR: RMRR base: 0x000000f2826c00 end: 0x000000f28273ff
[    0.221299] DMAR: RMRR base: 0x000000bdc00000 end: 0x000000bfffffff
[    0.221299] DMAR: No ATSR found
...
[    0.224001] DRHD: handling fault status reg 3
[    0.224003] DMAR:[DMA Write] Request device [00:02.0] fault addr 95e7000
[    0.224004] DMAR:[fault reason 05] PTE Write access is not set
[    0.224084] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O

BIOS version 6DET33WW (1.10)

Thanks

- Bhavesh
 
Bhavesh P. Davda

> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of David Woodhouse
> Sent: Wednesday, October 14, 2009 5:09 AM
> To: Andy Isaacson
> Cc: Chris Wright; iommu@lists.linux-foundation.org; linux-
> ext4@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
> 
> On Fri, 2009-10-09 at 18:47 -0700, Andy Isaacson wrote:
> > Well, we don't know for sure what happened on the previous boot where
> > the filesystem corruption occurred.  I'm imagining a nightmare
> scenario
> > where GPU erroneous writes cause DMAR faults and handling them
> somehow
> > causes AHCI DMA requests to get lost.
> 
> Seems unlikely. The GPU faults happen whenever the GATT changes,
> because
> it translates _every_ address in the GATT through the IOMMU right there
> and then -- so if parts of the table are uninitialised, they'll cause
> stray write faults. But no writes are actually _happening_.
> 
> > I'm going to go ahead on the theory that the BIOS needs an update.
> 
> I can't really imagine how that would help; how the BIOS would be
> responsible for this. I'm more inclined to blame the drive. It's not an
> SSD, is it?
> 
> --
> dwmw2
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
