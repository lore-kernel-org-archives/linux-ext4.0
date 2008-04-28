From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 28 Apr 2008 14:01:01 -0700
Message-ID: <48163B0D.9000700@zytor.com>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org> <20080428202130.GF15840@elte.hu> <481639D2.7040306@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:59485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934620AbYD1VGD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Apr 2008 17:06:03 -0400
In-Reply-To: <481639D2.7040306@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
>> And once we accept the static markers, we might as well make them as 
>> cheap as possible.
> 
> Sure, so long as you take "as cheap as possible" to mean cheap in both 
> implementation complexity as well as runtime cost.
> 
> I don't have any specific objections to any of the stuff that Mathieu is 
> working on, but it does worry me that each time a problem is addressed 
> it ends up being an even more subtle piece of code.  I just haven't seen 
> enough concrete justification to make me feel comfortable with it all.
> 
> It seems to me that a relatively simple implementation which allows the 
> desired tracing/marking functionality is the first step.  If that proves 
> to cause a significant performance deficit then enabled then we can work 
> out how to address it in due course.  But doing it all at once before 
> merging anything seems like overkill, particularly when we're talking 
> about specifics of gcc's codegen patterns, disassembling code fragments, 
> etc.
> 

I really feel that the latest information that has come up has indicated 
that things are really not what they should be.  They are in line, have 
a substantial probe cost, and we're messing around with how to jump 
around them.

That's not the problem.

I maintain what I said before: a call instruction (which defaults to a 
NOP), and then extract the state based on debugging info or assembler 
annotations.

As far as patchable static jumps, I can see the utility of them, but I 
don't think this project is one of them.  However, I believe the right 
way to do them is via compiler support.

	-hpa
