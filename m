From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 17:47:04 -0400
Message-ID: <20080425214704.GD25950@Krystal>
References: <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com>
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
Received: from tomts40.bellnexxia.net ([209.226.175.97]:58714 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751220AbYDYVrH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 17:47:07 -0400
Content-Disposition: inline
In-Reply-To: <481249FB.8070204@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> The point is to provide a way to dynamically enable code at runtime
>> without noticeable performance impact on the system. It's principally
>> useful to control the markers in the kernel, which can be placed in very
>> frequently executed code paths. The original markers add a memory read,
>> test and conditional branch at each marker site. By using the immediate
>> values patchset, it goes down to a load immediate value, test and branch.
>> However, Ingo was still unhappy with the conditional branch, so I cooked
>> this jump patching optimization on top of the immediate values. It
>> looks for an expected pattern which limits the liveliness of the %al and
>> ZF registers to the 3 instructions and, if it finds it, patches a jump
>> located just before the mov instruction to skip the whole pattern and
>> behave exactly like the conditional branch.
>> So basically we get code dynamically actvated by patching a single jump.
>
> Note that all these optimizations only make sense if the case where we 
> *take* the "marker" is frequent, *and* the marker itself is not too 
> expensive.
>

Yes, this is the case. Using breakpoints for markers quickly becomes
noticeable for thing such as scheduler instrumentation, page fault
handler instrumentation, etc. And yes, I have developed kernel tracer,
LTTng, which takes care of writing the data to trace buffers
efficiently. The last time I took performance measurements, it was
performing locking and writing to the memory buffer in about 270ns on a
3GHz Pentium 4. It might be a tiny bit slower now that it parses the
markers format strings dynamically, but nothing very significant.

But there is another point that markers do which the breakpoint won't
give you : they extract local variables from functions and they identify
them with field names which separates the instrumentation from the
actual kernel implementation details. In order to do that, I rely on gcc
building a stack frame for a function call, which I don't want to build
unnecessarity when the marker is disabled. This is why I use a jump to
skip passing the arguments on the stack and the function call.

Mathieu

> If that is not the case, just put in a noop that is dynamically patched to 
> an INT3 or ICEBP instruction (one byte) or an INT instruction (two bytes), 
> take the exception, look up the source address and revector to the marker 
> code.
>
> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
