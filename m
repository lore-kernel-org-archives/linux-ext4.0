From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 16:13:59 -0700
Message-ID: <481265B7.9040505@goop.org>
References: <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org> <20080425230028.GC31226@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	"Frank Ch. Eigler" <fche@redhat.com>, systemtap@sources.redhat.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:50821 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205AbYDYXOG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 19:14:06 -0400
In-Reply-To: <20080425230028.GC31226@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> This idea has been considered a few years ago at OLS in the tracing BOF
> if I remember well.  The results were this : First, there is no way to
> guarantee that no code path, nor any return address from any function,
> interrupt, sleeping thread, will return to the "old" version of the
> function. Nor is it possible to determine when a quiescent state is
> reached. Therefore, we couldn't see how we can do the teardown.
>   

Does that matter?  The new function is semantically identical to the old 
one, and the old code will remain in place.  If there's still users in 
the old function it may take a while for them to get flushed out (and 
won't be traced in the meantime), but you have to expect some missed 
events if you're shoving any kind of dynamic marker into the code.  The 
main problem is if there's something still depending on the first 5 
bytes of the function (most likely if there's a loop head somewhere near 
the top of the function).

Updating the markers would mean you'd leave a trail of old versions 
hanging around as modules, but that's not a huge cost...

> The second point is dependency between execution flow and variables. If
> we don't do a complete copy of the variables (which I don't see how we
> can do atomically), we will have to share the variables between the old
> and the new copies of the functions. However, some variables might
> encode information about the execution flow of the program and depend on
> the actual address at which the code is linked (function pointers for
> instance). Stuff like "goto *addr" would also break.
>   

Obviously you'd only pick up new callers of the function, which would 
mean that they'd pick up the new versions of those function-local 
things.  Though you'd need to make sure that the new versions of the 
function are using the old version's static variables...

>
> Then dealing with multiple code patching infrastructures (kprobes,
> alternatives, paravirt) would become hellish. If a kprobe is planted in
> the original version of the function, we have to insert it in the new
> version... and the teardown of the old function is still a problem.
>   

The module machinery already deals with patching paravirt and 
alternatives into loaded modules.  Your bespoke module would get dealt 
with like any other module.

    J
