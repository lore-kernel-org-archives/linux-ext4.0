From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 8 Dec 2008 18:00:47 -0500
Message-ID: <20081208230047.GC2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org> <20081208221241.GA2501@mit.edu> <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754088AbYLHXBV@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
> 
> atomic_t is pretty good on all archs, but you get to keep the cacheline
> ping-pong.
> 

Stupid question --- if you're worried about cacheline ping-pongs, why
aren't each cpu's delta counter cacheline aligned?  With a 64-byte
cache-line, and a 32-bit counters entry, with less than 16 CPU's we're
going to be getting cache ping-pong effects with percpu_counter's,
right?  Or am I missing something?

						- Ted
