From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 28 Apr 2008 22:21:30 +0200
Message-ID: <20080428202130.GF15840@elte.hu>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:54349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718AbYD1UWo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 16:22:44 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'd much rather see something truly generic that doesn't need any 
> pre-inserted "markers" at all that disable optimizations, and that 
> allows just about anything. Including live system bug-fixes etc 
> (imagine finding a bug - and not at somethign that was previously 
> already "marked" - and just replacing the buggy function with a 
> non-buggy one).

Ob'plug: with the pending dyn-ftrace function tracer feature we do 
something rather close to that already: we have a 5 byte NOP in the 
prologue of every function that can be used as a non-destructive 'branch 
away' place.

Right now we use that to trace a (regex-ish pattern identified) set of 
functions. The regex pattern can be configured runtime via 
/debug/tracing/function_filter is not parsed runtime in any fastpath - 
it is used to activate/deactivate the tracepoints and patches them from 
NOPs into CALLs.

_But_ the same mechanism could perhaps be used to patch the function as 
well.

The cost is +5 bytes of NOP for every function in the system, but in 
practice we've not been able to measure any actual runtime costs of 
these NOPs - neither in micro-benchmarks nor in macro-benchmarks. (the 
only real cost here is the +5 bytes of I$ cost - otherwise the NOP will 
just be skipped by the decoder.)

the patching of these NOPs is inherently safe because they are inserted 
at build time. There's no negative impact to gcc optimizations at all. 
We get a nice selection of 75,000 tracepoints in an allmodconfig kernel 
- without _any_ source code level impact in the functions.

On the other hand, i'm not opposed to a handful of static markers either 
- i think the best model is to have both of these facilities. There are 
a couple of 'core events' that are not expressed via function calls, and 
even where they are expressed via function calls the function call 
layout is not stable while markers are stable across kernel versions. 
The notion of "a context-switch happened from task X to task Y" or "task 
X woke up task Y" is not going to change anytime soon so i'm not opposed 
to exposing that kind of information. And once we accept the static 
markers, we might as well make them as cheap as possible.

	Ingo
