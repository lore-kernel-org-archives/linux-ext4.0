From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 8 Dec 2008 18:49:27 -0500
Message-ID: <20081208234927.GF2501@mit.edu>
References: <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org> <20081208221241.GA2501@mit.edu> <1228774836.16244.22.camel@lappy.programming.kicks-ass.net> <20081208230047.GC2501@mit.edu> <20081208150724.37761534.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: a.p.zijlstra@chello.nl, dada1@cosmosbay.com,
	linux-kernel@vger.kernel.org, davem@davemloft.net, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37386 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134AbYLHXtl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 18:49:41 -0500
Content-Disposition: inline
In-Reply-To: <20081208150724.37761534.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 08, 2008 at 03:07:24PM -0800, Andrew Morton wrote:
> > Stupid question --- if you're worried about cacheline ping-pongs, why
> > aren't each cpu's delta counter cacheline aligned?
> 
> They are allocated with alloc_percpu(), so each CPU's counter lives
> in a per-cpu area.  If you chase through seventeen layers of Rustyness
> you end up at mm/allocpercpu.c:percpu_populate() which is where that
> little s32 ends up getting allocated.

Ah, OK.  So the answer is "Ted was stupid and didn't understand n
layers of percpu abstractions".... whoever wrote that code seems to
have been a great believer of the saying, "if the code was hard to
*write*, it should be hard to *understand*".  :-)

						- Ted
