From: Christoph Hellwig <hch@infradead.org>
Subject: Re: softlockup in xfstests 083
Date: Sat, 8 Dec 2012 07:45:42 -0500
Message-ID: <20121208124542.GA14814@infradead.org>
References: <20121122193600.GA31635@infradead.org>
 <alpine.LFD.2.00.1211261423090.24277@dhcp-1-104.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Luk?? Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37159
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751867Ab2LHMpo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2012 07:45:44 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1211261423090.24277@dhcp-1-104.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 26, 2012 at 02:30:32PM +0100, Luk?? Czerner wrote:
> I am unable to reproduce the problem even after 70 iteration of 083
> on 3.7.0-rc7. It is not immediately obvious what would block you in
> ext4_ext_remove_space() other reading the extent tree from the disk,
> but it should not take so long, is the trace always the same ?

Hi Lukas,

sorry for the delay.

Been retesting this with the current post-pre8 Linus tree and I can
hit it with a single try, same trace as before.

This is an x86-64 kvm guest, single virtual cpu and 1.5 GB memory on
a virtio disk.

