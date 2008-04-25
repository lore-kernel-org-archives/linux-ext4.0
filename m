From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 12:19:43 -0700
Message-ID: <48122ECF.405@zytor.com>
References: <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org> <20080425163035.GE9503@Krystal> <481209F2.4050908@zytor.com> <20080425170929.GA16180@Krystal> <20080425183748.GB16180@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:46137 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754096AbYDYT1c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 15:27:32 -0400
In-Reply-To: <20080425183748.GB16180@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> 
>>> b) there might be a jump into the middle of this instruction sequence?
>>>
>> If we change that, as discussed above, so the liveliness of ZF and of
>> the %al register is still insured by leaving the mov and test
>> instructions in place, we end up only modifying a single instruction and
>> the problem fades away. We would end up changing a jne for a jmp.
> 
> So, if we do is I propose here, we have to take into account this
> question too. Any jump that jumps in the middle of this instruction
> sequence would have to insure correct liveliness of %al and ZF. However,
> since we just limited the scope of their liveliness, there are no other
> code paths which can jump in the middle of our instruction sequence and
> insure correct ZF and %al liveliness.
> 

I wanted to point out that this, in particular, is utter nonsense. 
Consider a sequence that looks something like this:

if (foo ? bar : imv_cond(var)) {
	blah();
}

An entirely sane transformation of this (as far as gcc is concerned), is 
something like:

	cmpl $0,foo
	je 1f
	cmpl $0,bar
	jmp 2f
1:
#APP
	movb var,%al	/* This is your imv */
#NO_APP
	testb %al,%al
2:
	je 3f
	call blah
3:

Your code would take the movb-testb-je sequence and combine them, then 
we jump into the middle of the new instruction when jumping at 2!

There are only two ways to deal with this - extensive analysis of the 
entire flow of control, or telling the compiler exactly what is 
*actually* going on.  The latter is the preferred way, obviously.

	-hpa

