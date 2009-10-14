From: David Woodhouse <dwmw2@infradead.org>
Subject: RE: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Wed, 14 Oct 2009 16:34:23 +0100
Message-ID: <1255534463.5351.2.camel@macbook.infradead.org>
References: <20091009061729.GA31242@hexapodia.org>
	 <20091010000926.GA17547@sequoia.sous-sol.org>
	 <20091010014714.GG30557@hexapodia.org>
	 <1255522166.4523.238.camel@macbook.infradead.org>
	 <8B1F619C9F5F454E81D90D3C161698D7017DD55F68@EXCH-MBX-3.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andy Isaacson <adi@hexapodia.org>,
	Chris Wright <chrisw@sous-sol.org>,
	"iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Bhavesh Davda <bhavesh@vmware.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbZJNPfT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 11:35:19 -0400
In-Reply-To: <8B1F619C9F5F454E81D90D3C161698D7017DD55F68@EXCH-MBX-3.vmware.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2009-10-14 at 08:26 -0700, Bhavesh Davda wrote:
> [    0.224001] DRHD: handling fault status reg 3
> [    0.224003] DMAR:[DMA Write] Request device [00:02.0] fault addr 95e7000
> [    0.224004] DMAR:[fault reason 05] PTE Write access is not set 

It's harmless. Your BIOS just isn't completely initialising the GATT.

-- 
dwmw2

