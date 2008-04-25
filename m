From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 15:36:40 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org>
References: <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal> <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal>
 <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal>
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
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213AbYDYWnU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 18:43:20 -0400
In-Reply-To: <20080425223015.GB31226@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Mathieu Desnoyers wrote:
> 
> DWARF2 is capable of extracting information only when not optimized away
> by the compiler. That's the whole point of markers : liveness is good in
> this case because we make sure the variable is there, not that it
> *might* be there. The latter case might be good enough for a debugger,
> but not for a production system tracer.

This is why you really do want to recompile the function entirely if 
you're debugging it. Because it might simply not be debuggable in its 
normal state.

I'd much rather see something truly generic that doesn't need any 
pre-inserted "markers" at all that disable optimizations, and that allows 
just about anything. Including live system bug-fixes etc (imagine finding 
a bug - and not at somethign that was previously already "marked" - and 
just replacing the buggy function with a non-buggy one).

		Linus
