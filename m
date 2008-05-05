From: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Mon, 5 May 2008 12:36:28 +1000
Message-ID: <200805051236.31160.nickpiggin@yahoo.com.au>
References: <20080425.021301.193689806.davem@davemloft.net> <alpine.LFD.1.10.0804250915340.2779@woody.linux-foundation.org> <48121F43.3060902@goop.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756183AbYEECgx@vger.kernel.org>
In-Reply-To: <48121F43.3060902@goop.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 26 April 2008 04:13, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> > With each invocation being thousands of instructions and a cross-CPU IPI
> > for the tlb flush, that kind of stuff adds up. We're likely talking real
> > fractions of a second, rather than milliseconds.
>
> Doesn't vunmap batch the cross-CPU tlb flushes to amortize the cost?
> Hm, no, it doesn't seem to.  Oh, right, it was one of Nick's TBDs.

Yeah and I do have patches... posted a few months ago IIRC. I forget
offhand the exact details of the batching, but yes it should batch this
case of Linus's. I think I set it to batch 1024 vunmaps or xxxxKB per
IPI flush. With those patches it basically removed IPI flushing
completely from profiles of vmap intensive workloads.

The problem with vmap (outside this particular issue of text poking,
which should be single-threaded anyway), really is that it is a single
threaded allocator. The locking actually ends up hurting much more than
the IPIs for non-trivial uses of vmap (like xfs with directories larger
than PAGE_SIZE). Fortunately I have patches for that too ;)
