From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 09:11:59 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804250908570.2779@woody.linux-foundation.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu>
 <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425155000.GA4438@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758128AbYDYQOI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 12:14:08 -0400
In-Reply-To: <20080425155000.GA4438@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Ingo Molnar wrote:
> 
> text_poke() itself only applies/unapplies the LOCK prefix - a single 
> byte. We shouldnt be doing that at all: the cost of LOCK is 
> insignificant (a few cycles) and most systems are SMP anyway.

No, the cost of LOCK is quite high on a lot of systems.

On P4's in particular, since LOCK is serializing, it's about 140 cycles or 
so (and breaks all speculation). So we definitely want to remove it for 
any generic kernels.

(lock is fairly cheap on AMD K8's, and reportedly on Intel's upcoming 
Nehalem too, but on Core 2 it's about 35 cycles - quite noticeable, 
although not nearly the disaster that netburst is)

Oh, and text_poke() is also used for inserting the debug instruction for 
kprobes (and restoring the original byte), but yes, that is always just a 
single byte too.

			Linus
