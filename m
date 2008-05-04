From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Sun, 04 May 2008 09:18:26 -0700
Message-ID: <481DE1D2.4080704@zytor.com>
References: <481241DC.3070601@zytor.com> <alpine.LFD.1.10.0804251349510.2779@woody.linux-foundation.org> <20080425211205.GC25950@Krystal> <481249FB.8070204@zytor.com> <20080425214704.GD25950@Krystal> <48125635.3060303@zytor.com> <20080425223015.GB31226@Krystal> <alpine.LFD.1.10.0804251534420.2779@woody.linux-foundation.org> <20080428204342.GD27154@Krystal> <48163B50.8010608@goop.org> <20080504150353.GB23137@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:51298 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbYEDQeq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 May 2008 12:34:46 -0400
In-Reply-To: <20080504150353.GB23137@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mathieu Desnoyers wrote:
> 
> I am not saying that the standard marker will have to inhibit
> optimizations. Actually, it's the contrary : a well-thought marker
> should _not_ modify that kind of optimization, and we should put markers
> in code locations less likely to inhibit gcc optimizations. However, in
> the case where we happen to be interested in information otherwise
> optimized away by GCC, it makes sense to inhibit this optimization in
> order to have the information available for tracing.
> 
> I expect this to happen rarely, but I think we must deal with
> optimizations to make sure we never trace garbage due to some unexpected
> gcc optimization. I think it's a small (e.g. undetectable at the
> macrobenchmark level) price to pay to get correct tracing information.
> 

That's a pretty flippant reply... liveness causes register pressure 
which can cause rapid degradation in code quality on a register-starved 
architecture like x86.

	-hpa
