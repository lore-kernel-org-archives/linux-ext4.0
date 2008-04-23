From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Wed, 23 Apr 2008 21:52:42 +0300
Message-ID: <480F857A.3090503@cs.helsinki.fi>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>  <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com>  <200804220254.45251.rjw@sisk.pl>  <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>  <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>  <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>  <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33817 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbYDWSy1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 14:54:27 -0400
In-Reply-To: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Linus Torvalds wrote:
> Looks like possibly a double free to me (with the first free caused the 
> page to be re-used, the second free is the one that triggers the debug 
> message). But maybe Pekka or Christoph are better at reading those oopses.
> 
>> =============================================================================
>> BUG kmalloc-4096: Padding overwritten. 0x0000000000000000-0x00000000ffffffff
>> -----------------------------------------------------------------------------

Okay, this doesn't make sense to me. The code does:

     u8 *start;
     u8 *fault;

     /* ... */

     start = page_address(page);

     /* ... */

     fault = check_bytes(start + length, POISON_INUSE, remainder);
     if (!fault)
             return 1;
     while (end > fault && end[-1] == POISON_INUSE)
             end--;

     slab_err(s, page, "Padding overwritten. 0x%p-0x%p", fault, end - 1);

So how come we're printing out 'fault' as zero and 'end' at 4 GB? Christoph?

Zdenek, can you please send the full dmesg?

		Pekka
