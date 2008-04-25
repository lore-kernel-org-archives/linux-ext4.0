From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 12:30:35 -0400
Message-ID: <20080425163035.GE9503@Krystal>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425161916.GD3265@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org, pageexec@freemail.hu,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tomts13.bellnexxia.net ([209.226.175.34]:43633 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759524AbYDYQak (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:30:40 -0400
Content-Disposition: inline
In-Reply-To: <20080425161916.GD3265@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Andi Kleen (andi@firstfloor.org) wrote:
> On Fri, Apr 25, 2008 at 09:06:37AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 25 Apr 2008, Andi Kleen wrote:
> > > 
> > > So all these checks can be just removed.
> > 
> > Quite frankly, I'd rather tighten them up. All the callers actually seem 
> > to do just a single-byte one.
> 
> I think Mathieu did them to prepare for his immediate values which
> need to write more bytes (although actually it would be quite
> possible to have immediate values only for byte immediates too)
> 
> But that code needs much more infrastructure anyways.
> 

Yes, the immediate values, in general, only need to do atomic writes,
because I have taken care of placing the mov instruction in the correct
alignment so its immediate value happens to be aligned in memory.
However, the latest optimisation I did to change a conditional branch
into a jump when the correct code pattern is detected :

mov, test, bne short
into a
nop2, nop2, nop1, jmp short

or

mov, test, bne near
into a
nop2, nop2, nop1, jmp near

"replace_instruction_safe" is used for that. It puts a breakpoint in
lieue of each instruction's first byte before changing the rest of the
(potentially non aligned) instruction non atomically, and only then,
after issuing a sync_core on every CPUs to flush the trace cache, does
it put back the first byte, so it's done safely wrt intel's erratas
regarding code modification on SMP. Also note that it changes a 6 bytes
branch instruction into a 1 byte nop + 5 byte jump in the near jump
case, which is ok : you can split an instruction in multiple smaller
instructions safely on a live system wrt any execution context, but the
opposite is _not_ ok, since there could be a return address pointing in
the middle of the grouped instructions sitting on some other kernel
thread or interrupt stack (we should also take into account hypervisor
interaction here).

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
