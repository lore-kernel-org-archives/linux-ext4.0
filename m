From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 18:30:15 -0400
Message-ID: <20080425223015.GB31226@Krystal>
References: <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:60787 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbYDYWaT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 18:30:19 -0400
Content-Disposition: inline
In-Reply-To: <48125635.3060303@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Yes, this is the case. Using breakpoints for markers quickly becomes
>> noticeable for thing such as scheduler instrumentation, page fault
>> handler instrumentation, etc. And yes, I have developed kernel tracer,
>> LTTng, which takes care of writing the data to trace buffers
>> efficiently. The last time I took performance measurements, it was
>> performing locking and writing to the memory buffer in about 270ns on a
>> 3GHz Pentium 4. It might be a tiny bit slower now that it parses the
>> markers format strings dynamically, but nothing very significant.
>> But there is another point that markers do which the breakpoint won't
>> give you : they extract local variables from functions and they identify
>> them with field names which separates the instrumentation from the
>> actual kernel implementation details. In order to do that, I rely on gcc
>> building a stack frame for a function call, which I don't want to build
>> unnecessarity when the marker is disabled. This is why I use a jump to
>> skip passing the arguments on the stack and the function call.
>
> Well, debuggers do it, and that's ultimately what why we have debugging 
> annotation formats like DWARF2 - to be able to take an arbitrary state and 
> decode local variables from the combined register-memory state. This is 
> often done by an interpreter, but that's not necessary; a compiler can use 
> the debugging information and build appropriate capture code, which would 
> be able to execute very quickly.  Not only is this capable of extracting 
> arbitrary information, but it also guarantees that the extraction code is 
> out of line.
>

DWARF2 is capable of extracting information only when not optimized away
by the compiler. That's the whole point of markers : liveness is good in
this case because we make sure the variable is there, not that it
*might* be there. The latter case might be good enough for a debugger,
but not for a production system tracer.

> The act of building a stack frame not only preturbs the generated code (gcc 
> has to guarantee liveness, which you can see as a pro or a con), but it 
> also puts a fair amount of code in the icache path of the function.
>

if (unlikely(condition))
  function_call(params);

The builtin expect will take care to put the instructions out of the
hot paths and therefore leave them out of the icache with gcc
-freorder-blocks (in -O2). The only addition to the frequently used
icache is, in this case, the 5 bytes jump, 2 bytes mov, 2 bytes test and
2 (or 6) bytes conditional branch, for a total of 11 bytes for small
functions and 15 bytes for functions which require near jumps.

> Now, if a breakpoint is too expensive, one can do exactly the same trick 
> with a naked call instruction, with a higher icache impact in the unused 
> case (five bytes instead of one or two).  However, the key to low impact is 
> to use the debugging information to recover state.
>

The runtime cost of function call is bigger than the jump. I don't see
what this buys us.

> (Liveness at the probe point is still possible to enforce with this 
> technique: give gcc a "g" read constraint as part of the probe instruction. 
>  That makes gcc ensure the information is *somewhere*.  The debugging 
> information will tell you where to pick it up from. Obviously, any time 
> liveness is enforce you suffer a potential cost.)

It could be possible to do so. However, passing a variable argument list
to a marker is rather more flexible than those inline assembly
constraints. And you are still tied to the variable names and offer no
abstraction between the kernel implementation and the conceptual name
associated to a traced variable.

Mathieu

>
> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
