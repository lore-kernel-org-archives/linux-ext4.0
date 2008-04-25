From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 17:59:53 +0200
Message-ID: <20080425155953.GA11243@elte.hu>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425155444.GB9503@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:39511 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519AbYDYQAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:00:51 -0400
Content-Disposition: inline
In-Reply-To: <20080425155444.GB9503@Krystal>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Woooow, just a sec here. I removed the atomicity test _because_ there 
> happen to be a case where it's safe to do non-atomic instruction 
> modification. If we do :
> 
> 1) replace the instruction first byte by a breakpoint, execute an
>   instruction bypass (see the immediate values patches for detail)
> 2) modify the instruction non-atomically
> 3) put back the original instruction first byte.
> 
> That's why I removed the BUG_ONs at the beginning of the function. 
> That's also why it's required to deal with page crossing.

but the code as-is is nonsensical. It checks for:

        BUG_ON(len > sizeof(long));

but then deals with page crossing...

it should also rename text_poke_early() to text_poke_core(), and call 
_that_ from text_poke() if core_kernel_text(). From that alone the whole 
poke_text() function would look a whole lot cleaner.

	Ingo
