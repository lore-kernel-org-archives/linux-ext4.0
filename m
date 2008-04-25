From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 09:24:11 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
 <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830AbYDYQZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:25:44 -0400
In-Reply-To: <20080425161916.GD3265@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Andi Kleen wrote:
> 
> Not sure how the fixmap is better. It's pretty much equivalent, isn't it?
> Perhaps a little cheaper, but the code shouldn't be performance critical.

I have no really strong opinions. However, we do have a *lot* of lock 
prefixes in the kernel, and fixmaps are a lot cheaper than vmap(). It may 
not be performance-critical, but for me the "locks" section for the kernel 
is 0x8060 bytes long, which would seem to say that this is called four 
thousand times for each suspend and resume.

With each invocation being thousands of instructions and a cross-CPU IPI 
for the tlb flush, that kind of stuff adds up. We're likely talking real 
fractions of a second, rather than milliseconds.

But no, I didn't time it or really think very deeply about it.

		Linus
