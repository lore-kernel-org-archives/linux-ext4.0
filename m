From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 11:51:11 -0500
Message-ID: <4BCDDB7F.6040903@redhat.com>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de> <20100420153723.GE25507@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andre Noll <maan@systemlinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0DTRQw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 13:16:52 -0400
In-Reply-To: <20100420153723.GE25507@skl-net.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/20/2010 10:37 AM, Andre Noll wrote:
...

> - device timeout 30s, nobarrier
> 	No problem at all, all three runs OK.
> 
> Eric, are you still interested in seeing the blktrace output? Suppose,
> I should use a 30s timeout, nodealloc and barriers=1 as this triggers
> the problem within minutes.

Hm, so something about barriers being issued is causing timeout
problems on the device...?

since nodelalloc made it -worse- I suppose that rules out the problems
with fs flushing near ensopc, that should only be happening with delalloc.

To be honest I'm not sure what I would do with the blktrace data now,
but perhaps someone might be interested to see it; I'd at least gather it.

-Eric
