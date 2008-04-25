From: Craig Schlenter <craig@eng.detnet.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Fri, 25 Apr 2008 12:53:20 +0200
Message-ID: <20080425105320.GA2548@craigdell.detnet.com>
References: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org> <20080424.185757.254044977.davem@davemloft.net> <48118B18.5020008@gmail.com> <20080425.004523.146850490.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jirislaby@gmail.com, torvalds@linux-foundation.org,
	zdenek.kabelac@gmail.com, mingo@elte.hu, rjw@sisk.pl,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au, penberg@cs.helsinki.fi,
	clameter@sgi.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-03.jhb.wbs.co.za ([196.2.97.2]:41942 "EHLO
	mail-03.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYDYMja (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 08:39:30 -0400
Content-Disposition: inline
In-Reply-To: <20080425.004523.146850490.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 25, 2008 at 12:45:23AM -0700, David Miller wrote:
[snip]
> I notice Jiri, in your hardware list, you have an ath5k Atheros AR5212 chip
> in there.

I'm not sure how much code is shared between AR5212 and AR2413 but I
saw kmalloc poison issues about a month back with a fedora rawhide
kernel on a machine with a AR2413 chipset ... I filed the bug here:

http://madwifi.org/ticket/1856

I don't use that machine much so I haven't tried other kernels but
perhaps the above info helps in some way.

bye,

--Craig
