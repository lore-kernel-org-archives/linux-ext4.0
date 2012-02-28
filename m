From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC] ext4: block reservation allocation
Date: Tue, 28 Feb 2012 11:34:16 +0800
Message-ID: <20120228033416.GA17334@gmail.com>
References: <20120227090901.GA13953@gmail.com>
 <alpine.LFD.2.00.1202271234250.5597@dhcp-27-109.brq.redhat.com>
 <20120227131829.GA14666@gmail.com>
 <alpine.LFD.2.00.1202271417350.5597@dhcp-27-109.brq.redhat.com>
 <20120227150908.GA15097@gmail.com>
 <alpine.LFD.2.00.1202271611090.5597@dhcp-27-109.brq.redhat.com>
 <alpine.LFD.2.00.1202271619100.5597@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58608 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab2B1D3R (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Feb 2012 22:29:17 -0500
Received: by pbcup15 with SMTP id up15so2790732pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 27 Feb 2012 19:29:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1202271619100.5597@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 27, 2012 at 04:24:24PM +0100, Lukas Czerner wrote:
[snip]
> 
> You probably know all of that that already, but just in case... for the
> sake of good performance make sure that you partitions are properly aligned,
> because drive might very well have 4k sector size.

Thank you for reminding me. :-)

Regards,
Zheng

[snip]
