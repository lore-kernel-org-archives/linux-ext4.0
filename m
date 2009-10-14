From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Wed, 14 Oct 2009 13:09:26 +0100
Message-ID: <1255522166.4523.238.camel@macbook.infradead.org>
References: <20091009061729.GA31242@hexapodia.org>
	 <20091010000926.GA17547@sequoia.sous-sol.org>
	 <20091010014714.GG30557@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Chris Wright <chrisw@sous-sol.org>,
	iommu@lists.linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58320 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbZJNMKg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Oct 2009 08:10:36 -0400
In-Reply-To: <20091010014714.GG30557@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2009-10-09 at 18:47 -0700, Andy Isaacson wrote:
> Well, we don't know for sure what happened on the previous boot where
> the filesystem corruption occurred.  I'm imagining a nightmare scenario
> where GPU erroneous writes cause DMAR faults and handling them somehow
> causes AHCI DMA requests to get lost.

Seems unlikely. The GPU faults happen whenever the GATT changes, because
it translates _every_ address in the GATT through the IOMMU right there
and then -- so if parts of the table are uninitialised, they'll cause
stray write faults. But no writes are actually _happening_.

> I'm going to go ahead on the theory that the BIOS needs an update.

I can't really imagine how that would help; how the BIOS would be
responsible for this. I'm more inclined to blame the drive. It's not an
SSD, is it?

-- 
dwmw2

