From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 12:11:36 -0400
Message-ID: <20080425161136.GD9503@Krystal>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425155444.GB9503@Krystal> <20080425155953.GA11243@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35277 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755683AbYDYQQo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:16:44 -0400
Content-Disposition: inline
In-Reply-To: <20080425155953.GA11243@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Woooow, just a sec here. I removed the atomicity test _because_ there 
> > happen to be a case where it's safe to do non-atomic instruction 
> > modification. If we do :
> > 
> > 1) replace the instruction first byte by a breakpoint, execute an
> >   instruction bypass (see the immediate values patches for detail)
> > 2) modify the instruction non-atomically
> > 3) put back the original instruction first byte.
> > 
> > That's why I removed the BUG_ONs at the beginning of the function. 
> > That's also why it's required to deal with page crossing.
> 
> but the code as-is is nonsensical. It checks for:
> 
>         BUG_ON(len > sizeof(long));
> 
> but then deals with page crossing...
> 

That was in the initial version, before my patch, yes. I dealt with page
crossing at first, then added a more restrictive test to "play safe" (I
should have removed the page-crossing code at that point), but later on
noticed that there was a single case where it's valid to do non-atomic
updates, and it's when the execution flow is bypassed by a breakpoint
(as the immediate values are doing), so the last patch you have removes
the restrictive test and lets the page-crossing code in place.

> it should also rename text_poke_early() to text_poke_core(), and call 
> _that_ from text_poke() if core_kernel_text(). From that alone the whole 
> poke_text() function would look a whole lot cleaner.
> 

hrm, I am not convinced it's safe to call vmap() very early at boot
time. In the immediate values implementation, I do call text_poke very
very early at boot to populate the initial values. Or maybe are you
proposing something different from what I currently understand ?

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
