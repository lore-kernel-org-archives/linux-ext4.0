From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 003/152] jbd: fix commit of ordered data buffers
Date: Fri, 29 Sep 2006 23:26:39 +0200
Message-ID: <20060929212639.GA14744@elte.hu>
References: <200609260630.k8Q6UrvQ011999@shell0.pdx.osdl.net> <20060929122026.62ec29eb.akpm@osdl.org> <20060929191759.GA19304@elte.hu> <200609292154.30234.ak@suse.de> <20060929132057.3039bac8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <ak@suse.de>, Badari Pulavarty <pbadari@us.ibm.com>,
	Jan Kara <jack@suse.cz>, torvalds@osdl.org, stable@kernel.org,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:3736 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1751460AbWI2Vez (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Sep 2006 17:34:55 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20060929132057.3039bac8.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


* Andrew Morton <akpm@osdl.org> wrote:

> +void __trigger_all_cpu_backtrace(void)
> +{
> +	backtrace_mask = CPU_MASK_ALL;
> +}

i'd suggest cpu_online_map, i also added a busy-loop to wait for the 
backtrace_mask to go back to 0. That way we get a consistent dump all 
across. (as the NMI will dump on this CPU too)

if the NMI isnt working on some CPU, the wait might be quite long ;-) 
But it's not a big issue i think as the system is likely hosed already.

	Ingo
