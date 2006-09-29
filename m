From: Andi Kleen <ak@suse.de>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 21:54:30 +0200
Message-ID: <200609292154.30234.ak@suse.de>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net> <20060929122026.62ec29eb.akpm@osdl.org> <20060929191759.GA19304@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@osdl.org>,
	Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>,
	torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:17329 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1161888AbWI2Tyk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 15:54:40 -0400
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20060929191759.GA19304@elte.hu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Friday 29 September 2006 21:18, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@osdl.org> wrote:
> 
> > gad, there have been so many all-CPU-backtrace patches over the years.
> > 
> > <optimistically cc's Ingo>
> > 
> > Ingo, do you think that's something which we shuld have in the 
> > spinlock debugging code?  A trace to let us see which CPU is holding 
> > that lock, and where from?  I guess if the other cpu is stuck in 
> > spin_lock_irqsave() then we'll get stuck delivering the IPI, so it'd 
> > need to be async.
> 
> used to have this in -rt for i686 and x86_64 for the NMI watchdog tick 
> to print on all CPUs, in the next tick (i.e. no need to actually 
> initiate an IPI) - but it was all a bit hacky [but worked]. It fell 
> victim to some recent flux in that area.

You mean spinlock debugging setting a global variable and the NMI
watchdog testing that?  Makes sense. I can put it on my todo list.

-Andi
