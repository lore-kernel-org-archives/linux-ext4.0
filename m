From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 28 Apr 2008 14:02:08 -0700
Message-ID: <48163B50.8010608@goop.org>
References: <48123C9B.9020306@zytor.com> <20080425203717.GB25950@Krystal> <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org> <20080428204342.GD27154@Krystal>
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
	linux-kernel@vger.kernel.org, pageexec@freemail.hu
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw.goop.org ([64.81.55.164]:53623 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965811AbYD1VCV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 17:02:21 -0400
In-Reply-To: <20080428204342.GD27154@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> Markers, with immediate values, only clobbers the eax register and the
> ZF. It does not restrain inlining nor loop unrolling. It also requires
> gcc to leave the variables in which the marker is interested "live".

That in itself is pretty significant.  If that value would otherwise be 
constant folded or strength-reduced away, you're putting a big 
limitation on what the compiler can do.  The mere fact that its 
necessary to do something to preserve many values shows how much the 
compiler transforms the code away from what's in the source, and 
specifically referencing otherwise unused intermediates inhibits that.

In other words, if you weren't preventing optimisations, you wouldn't 
need to preserve values as much, because the optimiser wouldn't be 
getting rid of them.  If you need to preserve lots of values, you're 
necessarily preventing the optimiser from doing its job.

    J
