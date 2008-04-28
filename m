From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 28 Apr 2008 18:42:21 -0400
Message-ID: <20080428224221.GA30796@Krystal>
References: <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org> <20080428202130.GF15840@elte.hu> <481639D2.7040306@goop.org> <48163B0D.9000700@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts25.bellnexxia.net ([209.226.175.188]:64358 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935187AbYD1WmZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 18:42:25 -0400
Content-Disposition: inline
In-Reply-To: <48163B0D.9000700@zytor.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* H. Peter Anvin (hpa@zytor.com) wrote:
> Jeremy Fitzhardinge wrote:
>> Ingo Molnar wrote:
>>> And once we accept the static markers, we might as well make them as 
>>> cheap as possible.
>> Sure, so long as you take "as cheap as possible" to mean cheap in both 
>> implementation complexity as well as runtime cost.
>> I don't have any specific objections to any of the stuff that Mathieu is 
>> working on, but it does worry me that each time a problem is addressed it 
>> ends up being an even more subtle piece of code.  I just haven't seen 
>> enough concrete justification to make me feel comfortable with it all.
>> It seems to me that a relatively simple implementation which allows the 
>> desired tracing/marking functionality is the first step.  If that proves 
>> to cause a significant performance deficit then enabled then we can work 
>> out how to address it in due course.  But doing it all at once before 
>> merging anything seems like overkill, particularly when we're talking 
>> about specifics of gcc's codegen patterns, disassembling code fragments, 
>> etc.
>
> I really feel that the latest information that has come up has indicated 
> that things are really not what they should be.  They are in line, have a 


Do you consider all unlikely blocks to be in line ? If the real issue is
to make sure they don't share cache lines with the body of the function,
that could be arranged. However, I assume that using an unlikely branch
to let gcc with -freorder-blocks put the instructions at the end of the
function is enough.

> substantial probe cost,

When disabled : 0 cycles ? It additionnally clobbers eax and the EFLAGS.
For the parameters passed to the marker, I think the marker location
should be chosen carefully so most of the variables would be live anyway
even without a marker.

> and we're messing around with how to jump around 
> them.

I was perfectly happy with the immediate value + conditional branch, but
for apparently 0 cycles is more appealing than 2 :-)

>
> That's not the problem.
>
> I maintain what I said before: a call instruction (which defaults to a 
> NOP), and then extract the state based on debugging info or assembler 
> annotations.
>

Let's consider this option :

First of all, I wouldn't like to require tracing users to get the
kernel debuginfos each time they want to trace. I think it should be a
the "on" switch kind of infrastructure. Getting a few hundreds MB worth
of data isn't exactly that.

If I get your idea right, you propose to use an inline assembly with "g"
constraints to make sure gcc lets them alive. I just did some testing of
your approach applied to a marker in schedule() that shows that as soon
as you need to dereference a pointer in the parameters, this adds
operations in the fast path, which is not the case for markers because,
as Ingo explained, this is done in a block outside the fast path.

So your assembly constraint solution works fine only if the information
happens to be there, in a register, at the inline assembly site. Then
there is no added cost for register preparation. However, given it won't
always be true, you have to bear the cost of setting up the registers
from the stack or, worse, from a pointer read in the function fast path.

The markers offloads this to the jump target located outside of the fast
path. Therefore, in the general case which includes parameters not
present in the registers, markers seems like a more palatable solution.

> As far as patchable static jumps, I can see the utility of them, but I 
> don't think this project is one of them.  However, I believe the right way 
> to do them is via compiler support.
>

If you suppose the information is always live in registers at the
instrumented site, then yes, I guess your constraint+call approach is
good, modulo the fact that users will depend on hundreds of megabytes of
debuginfo.

However, in order to populate registers appropriately with a wider range
of parameters without adding instructions to the fast path, markers,
which add instructions in a cache-cold block seems like a good way to
go. And that depends on the ability to branch efficiently to that block,
when enabled, in order to prepare the stack and do the call.

Mathieu

> 	-hpa




-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
