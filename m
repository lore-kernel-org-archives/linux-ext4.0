From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Thu, 24 Apr 2008 18:57:57 -0700 (PDT)
Message-ID: <20080424.185757.254044977.davem@davemloft.net>
References: <4811090A.9030809@gmail.com>
	<20080424.183558.96469288.davem@davemloft.net>
	<alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jirislaby@gmail.com, zdenek.kabelac@gmail.com, mingo@elte.hu,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60148
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755290AbYDYB56 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 21:57:58 -0400
In-Reply-To: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Apr 2008 18:48:32 -0700 (PDT)

> But that 0xf0 definitely has shown up before. It's not the *only* 
> corruption, but it's definitely a very interesting pattern. And the other 
> ones that didn't show the 0xf0 pattern could obviously be due to pointers 
> that were corrupted by 0xf0 in low bytes, so it _may_ be the source of the 
> other corruptions too that didn't have an obvious 0xf0 directly in them.

Ok.

Do we know of any pattern of the wireless device type in use?
If there is a pattern to that, it would be a huge clue.

And if it is predominantly one particular wireless device type, we
should be able to come up with a patch to test.
