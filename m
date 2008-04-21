From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 14:19:26 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804211407370.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <20080421.133940.52972455.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au, paulmck@us.ibm.com,
	jirislaby@gmail.com
To: David Miller <davem@davemloft.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477AbYDUVUp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 17:20:45 -0400
In-Reply-To: <20080421.133940.52972455.davem@davemloft.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 21 Apr 2008, David Miller wrote:
> 
> Do we know the offset within the object at which this all 1's
> value is found?
> 
> My rough calculations show that on 32-bit that expect->mask member is
> at offset 56 and on 64-bit it should be at offset 72.  Does that
> match up to the offset of the filp or whatever bit being corrupted?

No, I think that the d_hash list is at offset 24 (64-bit).

But that changes if any of

 - GENERIC_LOCKBREAK
 - DEBUG_SPINLOCK
 - DEBUG_LOCK_ALLOC (and if so, LOCK_STAT)

is set, and then you might actually get to 72.

However, the Code: line for one of the oopses shows that in that 
particular case, it was at offset 0x18 (ie the normal 24), so at least one 
of the oopses had no such thing going on.

			Linus
