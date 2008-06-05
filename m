From: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Thu, 5 Jun 2008 13:44:10 -0400
Message-ID: <20080605174410.GA29189@redhat.com>
References: <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbYFERsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Jun 2008 13:48:21 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251456410.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, 25 Apr 2008, Linus wrote:

> On Fri, 25 Apr 2008, Mathieu Desnoyers wrote:
> > The point is to provide a way to dynamically enable code at runtime
> > without noticeable performance impact on the system.
> 
> Quite frankly, maybe I'm a bit dense, but why don't you just recompile the 
> whole original function (at run-time), load that new version of a function 
> as a mini-module, and then insert a marker at the top of the old function 
> that just does a "jmp replacementfunction".
> 
> That has _zero_ cost for the non-marker case, and allows you to do pretty 
> much any arbitrary code changes for the marker case.
> [...]
> Yeah, this requires you to basically recompile some function snippet when 
> you insert a probe, but if that scares people, you could basically do it 
> using the old code and inserting the markers and "relinking" it - avoiding 
> the C compiler, and just basically have an "assembly recompiler".

Linus, was it your intention to signal that you would veto any uses of
the current trace_mark mechanism, and wait for this hypothetical
function-recompilation-splicing widget as a replacement?  This is how
some people are interpreting this old thread.

A number of problems with the new idea were brought up, and no one
appears to have taken interest in trying to build it to see if they
can be overcome or if there are more.

On the other hand, a number of concerns with the markers have been
dealt with since, such as performance numbers showing near-zero
impact, and a variety of experience with the few dozen lttng markers
and the tools that consume the data.  The current debate appears to be
stuck on fuzzier aesthetic issues.


How are we to move forward?  Do you see any *harm* in letting in the
lttng markers soon?

Could it be that once this "recompile function with instrumentation on
the fly" machinery comes into existence eventually, then these exact
same marker points could be reinterpreted as one particular potential
instrumentation spot?  (This could be something as simple as building
the kernel with CONFIG_MARKERS=n by default so the markers are
compiled out, then having selected alternative functions built with
CONFIG_MARKERS=y.)

- FChE
