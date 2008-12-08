From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Mon, 8 Dec 2008 17:12:41 -0500
Message-ID: <20081208221241.GA2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51039 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752021AbYLHWM5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 17:12:57 -0500
Content-Disposition: inline
In-Reply-To: <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 07, 2008 at 08:52:50PM -0800, Andrew Morton wrote:
> 
> The first patch which was added (pre-2.6.27) was "percpu_counter: new
> function percpu_counter_sum_and_set".  This added the broken-by-design
> percpu_counter_sum_and_set() function, **and used it in ext4**.
> 

Mea culpa, I was the one who reviewed Mingming's patch, and missed
this.  Part of the problem was that percpu_counter.c isn't well
documented, and I so saw the spinlock, but didn't realize it only
protected reference counter, and not the per-cpu array.  I should have
read through code more thoroughly before approving the patch.

I suppose if we wanted we could add a rw spinlock which mediates
access to a "foreign" cpu counter (i.e., percpu_counter_add gets a
shared lock, and percpu_counter_set needs an exclusive lock) but it's
probably not worth it.

Actually, if all popular architectures had a hardware-implemented
atomic_t, I wonder how much ext4 really needs the percpu counter,
especially given ext4's multiblock allocator; with ext3, given that
each block allocation required taking a per-filesystem spin lock,
optimizing away that spinlock was far more important for improving
ext3's scalability.  But with the multiblock allocator, it may that
we're going through a lot more effort than what is truly necessary.

						- Ted
