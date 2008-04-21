From: David Miller <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 13:39:40 -0700 (PDT)
Message-ID: <20080421.133940.52972455.davem@davemloft.net>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	<200804211812.16994.rjw@sisk.pl>
	<alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au, paulmck@us.ibm.com,
	jirislaby@gmail.com
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49729
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752750AbYDUUji (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 16:39:38 -0400
In-Reply-To: <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Apr 2008 09:54:07 -0700 (PDT)

> What I find interesting is that at least for me, I have the SLAB bucket 
> size for nf_conntrack_expect being 208 bytes. And the *biggest* merge by 
> far after 2.6.25 so far has been networking (and conntrack in particular)
> 
> Is that a smoking gun? Not necessarily. But it *is* intriguing. But there 
> are other possible clashes (the 192-byte bucket has several different 
> suspects, and not all of them are in networking).1

I think you might be onto something here.

The "mask" member of struct nf_conntrack_expect could be reasonably
all 1's like the value reported in the crash that begins this
thread.

Do we know the offset within the object at which this all 1's
value is found?

My rough calculations show that on 32-bit that expect->mask member is
at offset 56 and on 64-bit it should be at offset 72.  Does that
match up to the offset of the filp or whatever bit being corrupted?

I'll scan through the netfilter changesets in post 2.6.25 to see if
anything stands out.


