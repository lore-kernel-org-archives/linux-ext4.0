From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 23:22:27 +0200
Message-ID: <20060929212227.GA14030@elte.hu>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net> <20060929122026.62ec29eb.akpm@osdl.org> <20060929191759.GA19304@elte.hu> <200609292154.30234.ak@suse.de> <20060929132057.3039bac8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <ak@suse.de>, Badari Pulavarty <pbadari@us.ibm.com>,
	Jan Kara <jack@suse.cz>, torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:38294 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1161419AbWI2Vax (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 17:30:53 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20060929132057.3039bac8.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> +	if (cpu_isset(cpu, backtrace_mask)) {
> +		cpu_clear(cpu, backtrace_mask);
> +		printk("NMI backtrace for cpu %d\n", cpu);
> +		dump_stack();
> +	}

yeah. There's just one issue: this will mix all the printks from all 
CPUs at once (the NMIs if IO-APIC triggered fire at once). The way i 
solved this was to add a private spinlock around the printk and 
dump_stack().

	Ingo
