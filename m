From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 21:18:00 +0200
Message-ID: <20060929191759.GA19304@elte.hu>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net> <451C4DDE.60307@us.ibm.com> <20060929090253.GA17124@atrey.karlin.mff.cuni.cz> <1159546306.8780.2.camel@dyn9047017100.beaverton.ibm.com> <20060929122026.62ec29eb.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>,
	torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>, Andi Kleen <ak@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:42919 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1751340AbWI2T0q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 15:26:46 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20060929122026.62ec29eb.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> gad, there have been so many all-CPU-backtrace patches over the years.
> 
> <optimistically cc's Ingo>
> 
> Ingo, do you think that's something which we shuld have in the 
> spinlock debugging code?  A trace to let us see which CPU is holding 
> that lock, and where from?  I guess if the other cpu is stuck in 
> spin_lock_irqsave() then we'll get stuck delivering the IPI, so it'd 
> need to be async.

used to have this in -rt for i686 and x86_64 for the NMI watchdog tick 
to print on all CPUs, in the next tick (i.e. no need to actually 
initiate an IPI) - but it was all a bit hacky [but worked]. It fell 
victim to some recent flux in that area.

< optimistically cc's Andi =B-) >

	Ingo
