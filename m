From: Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Wed, 23 Apr 2008 12:05:01 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0804231202250.15173@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>
 <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
 <480F857A.3090503@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57886 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbYDWTFD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 15:05:03 -0400
In-Reply-To: <480F857A.3090503@cs.helsinki.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 23 Apr 2008, Pekka Enberg wrote:

>     fault = check_bytes(start + length, POISON_INUSE, remainder);

fault == NULL if the check was successful. Otherwise it contains the first
address that does not match our expectations.

>     if (!fault)
>             return 1;
>     while (end > fault && end[-1] == POISON_INUSE)
>             end--;
> 
>     slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);
> 
> So how come we're printing out 'fault' as zero and 'end' at 4 GB? Christoph?

We should have returned from the function and not printed this message. If 
we somehow skipped the test for !fault then end could have wrapped around 
which gets us to 4GB.


