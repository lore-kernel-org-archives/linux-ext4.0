From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 15:38:34 -0700
Message-ID: <48125D6A.10508@zytor.com>
References: <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:40942 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYDYWmq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 18:42:46 -0400
In-Reply-To: <20080425223015.GB31226@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> 
> DWARF2 is capable of extracting information only when not optimized away
> by the compiler. That's the whole point of markers : liveness is good in
> this case because we make sure the variable is there, not that it
> *might* be there. The latter case might be good enough for a debugger,
> but not for a production system tracer.
> 

That's what I address with the last paragraph of the email.

> 
> The builtin expect will take care to put the instructions out of the
> hot paths and therefore leave them out of the icache with gcc
> -freorder-blocks (in -O2). The only addition to the frequently used
> icache is, in this case, the 5 bytes jump, 2 bytes mov, 2 bytes test and
> 2 (or 6) bytes conditional branch, for a total of 11 bytes for small
> functions and 15 bytes for functions which require near jumps.
> 
>> Now, if a breakpoint is too expensive, one can do exactly the same trick 
>> with a naked call instruction, with a higher icache impact in the unused 
>> case (five bytes instead of one or two).  However, the key to low impact is 
>> to use the debugging information to recover state.
> 
> The runtime cost of function call is bigger than the jump. I don't see
> what this buys us.

You get zero instructions and five bytes of NOP in the non-taken case.

In the taken case, you move the whole thing out of line.

>> (Liveness at the probe point is still possible to enforce with this 
>> technique: give gcc a "g" read constraint as part of the probe instruction. 
>>  That makes gcc ensure the information is *somewhere*.  The debugging 
>> information will tell you where to pick it up from. Obviously, any time 
>> liveness is enforce you suffer a potential cost.)
> 
> It could be possible to do so. However, passing a variable argument list
> to a marker is rather more flexible than those inline assembly
> constraints. And you are still tied to the variable names and offer no
> abstraction between the kernel implementation and the conceptual name
> associated to a traced variable.

"Rather more flexible?"  Surely you're joking, Mr. Feynman?  There is no 
difference, none, nada.

Furthermore, your capture stub compiler, or trace data extractor, can do 
any kind of mapping it pleases; so I'm utterly confused what you're 
talking about "still tied to variable names."

	-hpa
