From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Tue, 09 Dec 2008 00:08:07 +0100
Message-ID: <1228777687.12729.6.camel@twins>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
	 <20081208230047.GC2501@mit.edu>  <1228777500.12729.4.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbYLHXIg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 18:08:36 -0500
In-Reply-To: <1228777500.12729.4.camel@twins>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-12-09 at 00:05 +0100, Peter Zijlstra wrote:
> On Mon, 2008-12-08 at 18:00 -0500, Theodore Tso wrote:
> > On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
> > > 
> > > atomic_t is pretty good on all archs, but you get to keep the cacheline
> > > ping-pong.
> > > 
> > 
> > Stupid question --- if you're worried about cacheline ping-pongs, why
> > aren't each cpu's delta counter cacheline aligned?  With a 64-byte
> > cache-line, and a 32-bit counters entry, with less than 16 CPU's we're
> > going to be getting cache ping-pong effects with percpu_counter's,
> > right?  Or am I missing something?
> 
> sorta - a new per-cpu allocator is in the works, but we do cacheline
> align the per-cpu allocations (or used to), also, the allocations are
> node affine.

Indeed we still (or again) do, see mm/allocpercpu.c:percpu_populate().

