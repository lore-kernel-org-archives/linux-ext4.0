From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
	ffffffffffffffff
Date: Wed, 23 Apr 2008 19:40:06 +0200
Message-ID: <20080423174006.GA2739@elte.hu>
References: <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org> <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu> <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com> <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org> <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com> <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:41335 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYDWRlW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 13:41:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> >  CPU: L2 cache: 4096K
> >  CPU: Physical Processor ID: 0
> >  CPU: Processor Core ID: 1
> >  x86: PAT support disabled.
> >  SPIN IRQ ALREADY DISABLED
> >  Pid: 0, comm: swapper Not tainted 2.6.25 #57
> > 
> >  Call Trace:
> >   [_spin_lock_irq+126/128] _spin_lock_irq+0x7e/0x80
> >   [lock_ipi_call_lock+16/32] lock_ipi_call_lock+0x10/0x20
> >  CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz
> > [start_secondary+68/206] start_secondary+0x44/0xce
> 
> This is indeed an interesting issue: arch/x86/kernel/smpboot.c does an 
> IPI call to start_secondary, and yes, it looks suspicious to have that 
> lock_ipi_call_lock there (and in particular the unlock_ipi_call_lock 
> that enables interrupts within it). Ingo?

hm, irqs already disabled isnt bad in itself and it happens all the 
time. The irq enabling in unlock_ipi_call_lock() should be OK.

Any race with irqs there should at most result in a hung or crashed 
bootup, not in any memory corruption i believe.

	Ingo
