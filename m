From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 28 Apr 2008 16:43:42 -0400
Message-ID: <20080428204342.GD27154@Krystal>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts20.bellnexxia.net ([209.226.175.74]:62422 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933038AbYD1Uss (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 16:48:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 25 Apr 2008, Mathieu Desnoyers wrote:
> > 
> > DWARF2 is capable of extracting information only when not optimized away
> > by the compiler. That's the whole point of markers : liveness is good in
> > this case because we make sure the variable is there, not that it
> > *might* be there. The latter case might be good enough for a debugger,
> > but not for a production system tracer.
> 
> This is why you really do want to recompile the function entirely if 
> you're debugging it. Because it might simply not be debuggable in its 
> normal state.
> 
> I'd much rather see something truly generic that doesn't need any 
> pre-inserted "markers" at all that disable optimizations, and that allows 

Markers, with immediate values, only clobbers the eax register and the
ZF. It does not restrain inlining nor loop unrolling. It also requires
gcc to leave the variables in which the marker is interested "live". Are
you referring to other optimizations I wouldn't have though of ?

> just about anything. Including live system bug-fixes etc (imagine finding 
> a bug - and not at somethign that was previously already "marked" - and 
> just replacing the buggy function with a non-buggy one).
> 
> 		Linus

kprobes is already doing a good job at probing a live system without
rebooting. Markers are best suited to export information about kernel
events which stays stable between releases so the information is readily
available in the kernel, with low overhead even when tracing is enabled
(which kprobes doesn't provide) which allows a user to flip the "on"
switch and get a trace of all system calls, scheduling, traps,
interrupts that happen on the system.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
