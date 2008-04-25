From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Thu, 24 Apr 2008 18:48:32 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org>
References: <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org> <4811090A.9030809@gmail.com> <20080424.183558.96469288.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jirislaby@gmail.com, zdenek.kabelac@gmail.com, mingo@elte.hu,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754256AbYDYBvS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 21:51:18 -0400
In-Reply-To: <20080424.183558.96469288.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Thu, 24 Apr 2008, David Miller wrote:
> 
> So the clue is setting some byte at ((offset % 8) == 0) into a
> structure with 0xf0...

It's not always at (offset % 8) == 0. We've seen that 0xf0 pattern in 
other oopses, but it's not always 8-byte aligned. In fact, when we've seen 
it in oopses, it has generally been in the higher bytes (eg offset 5 
within a 64-bit word, causing an invalid pointer on x86-64).

But that 0xf0 definitely has shown up before. It's not the *only* 
corruption, but it's definitely a very interesting pattern. And the other 
ones that didn't show the 0xf0 pattern could obviously be due to pointers 
that were corrupted by 0xf0 in low bytes, so it _may_ be the source of the 
other corruptions too that didn't have an obvious 0xf0 directly in them.

			Linus
