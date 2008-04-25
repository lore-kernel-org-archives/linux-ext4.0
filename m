From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 11:54:44 -0400
Message-ID: <20080425155444.GB9503@Krystal>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763513AbYDYPzF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Fri, 25 Apr 2008, Ingo Molnar wrote:
> > 
> > something like the patch below? (untested)
> 
> No. That whole code sequence is total and utter crap. It needs to be 
> rewritten.
> 
> It first does a BUG_ON() if it's not naturally aligned (because that 
> wouldn't be atomic), and then it has code for page crossing! What a TOTAL 
> PIECE OF SH*T!
> 
> Hint:
>  - if it's naturally aligned, it couldn't be page crossing ANYWAY
>  - and if it was a page-crosser, it sure as hell couldn't be atomic!
> 
> The code is just crap, crap, crap. It needs to be rewritten from scratch. 
> I'll have a patch soonish.
> 
> 		Linus


Woooow, just a sec here. I removed the atomicity test _because_ there
happen to be a case where it's safe to do non-atomic instruction
modification. If we do :

1) replace the instruction first byte by a breakpoint, execute an
  instruction bypass (see the immediate values patches for detail)
2) modify the instruction non-atomically
3) put back the original instruction first byte.

That's why I removed the BUG_ONs at the beginning of the function.
That's also why it's required to deal with page crossing.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
