From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 15:07:49 -0700
Message-ID: <48125635.3060303@zytor.com>
References: <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal>
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
Received: from terminus.zytor.com ([198.137.202.10]:38841 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761654AbYDYWOJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 18:14:09 -0400
In-Reply-To: <20080425214704.GD25950@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> 
> Yes, this is the case. Using breakpoints for markers quickly becomes
> noticeable for thing such as scheduler instrumentation, page fault
> handler instrumentation, etc. And yes, I have developed kernel tracer,
> LTTng, which takes care of writing the data to trace buffers
> efficiently. The last time I took performance measurements, it was
> performing locking and writing to the memory buffer in about 270ns on a
> 3GHz Pentium 4. It might be a tiny bit slower now that it parses the
> markers format strings dynamically, but nothing very significant.
> 
> But there is another point that markers do which the breakpoint won't
> give you : they extract local variables from functions and they identify
> them with field names which separates the instrumentation from the
> actual kernel implementation details. In order to do that, I rely on gcc
> building a stack frame for a function call, which I don't want to build
> unnecessarity when the marker is disabled. This is why I use a jump to
> skip passing the arguments on the stack and the function call.
> 

Well, debuggers do it, and that's ultimately what why we have debugging 
annotation formats like DWARF2 - to be able to take an arbitrary state 
and decode local variables from the combined register-memory state. 
This is often done by an interpreter, but that's not necessary; a 
compiler can use the debugging information and build appropriate capture 
code, which would be able to execute very quickly.  Not only is this 
capable of extracting arbitrary information, but it also guarantees that 
the extraction code is out of line.

The act of building a stack frame not only preturbs the generated code 
(gcc has to guarantee liveness, which you can see as a pro or a con), 
but it also puts a fair amount of code in the icache path of the function.

Now, if a breakpoint is too expensive, one can do exactly the same trick 
with a naked call instruction, with a higher icache impact in the unused 
case (five bytes instead of one or two).  However, the key to low impact 
is to use the debugging information to recover state.

(Liveness at the probe point is still possible to enforce with this 
technique: give gcc a "g" read constraint as part of the probe 
instruction.  That makes gcc ensure the information is *somewhere*.  The 
debugging information will tell you where to pick it up from. 
Obviously, any time liveness is enforce you suffer a potential cost.)

	-hpa
