From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 15:04:51 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal>
 <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755322AbYDYWHT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 18:07:19 -0400
In-Reply-To: <20080425211205.GC25950@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Mathieu Desnoyers wrote:
> 
> The point is to provide a way to dynamically enable code at runtime
> without noticeable performance impact on the system.

Quite frankly, maybe I'm a bit dense, but why don't you just recompile the 
whole original function (at run-time), load that new version of a function 
as a mini-module, and then insert a marker at the top of the old function 
that just does a "jmp replacementfunction".

That has _zero_ cost for the non-marker case, and allows you to do pretty 
much any arbitrary code changes for the marker case.

It's also a much simpler replacement.

Yeah, that "jmp replacementfunction" is five or more bytes, but you can 
trivially do the actual _replacement_ write by writing it first as a 
single-byte debug trap, and after that has been written, write the target 
address after it, and then write the first byte of the "jmp" instruction 
last. In the (very unlikely) case that another CPU hits that debug trap, 
you just fix it up in the debug handler - you only need a single datum of 
"this is where that debug trap should relocate", because you simply create 
a triial spinlock around the code-sequence that does the instruction 
rewrite.

When undoing it, just do the same thing in reverse.

Yeah, this requires you to basically recompile some function snippet when 
you insert a probe, but if that scares people, you could basically do it 
using the old code and inserting the markers and "relinking" it - avoiding 
the C compiler, and just basically have an "assembly recompiler".

And yeah, maybe you want to do without the use of modules, and you'd just 
have a memory area that is kept free for these kinds of code replacement 
issues. And you can optimize it to not recompile the whole function, but 
do it on a finer granularity if you want.

And sure, you want to really make sure that there is security in place so 
that this isn't used for rootkits, but isn't that true of pretty much 
*any* trace facility?

			Linus
