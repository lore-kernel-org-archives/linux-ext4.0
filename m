From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 7 Dec 2008 09:28:54 -0800
Message-ID: <20081207092854.f6bcbfae.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbYLGR3c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 12:29:32 -0500
In-Reply-To: <493BCF60.1080409@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 07 Dec 2008 14:28:00 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Andrew Morton a __crit :
> > On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >> Eric Dumazet a __crit :
> >>
> >> 1) __percpu_counter_sum() is buggy, it should not write
> >> on per_cpu_ptr(fbc->counters, cpu), or another cpu
> >> could get its changes lost.
> >>
> >> __percpu_counter_sum should be read only (const struct percpu_counter *fbc),
> >> and no locking needed.
> > 
> > No, we can't do this - it will break ext4.
> > 
> > Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
> > e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
> > 
> > I suggest that what we do is to revert both those changes.  We can
> > worry about the possibly-unneeded spin_lock later, in a separate patch.
> > 
> > It should have been a separate patch anyway.  It's conceptually
> > unrelated and is not a bugfix, but it was mixed in with a bugfix.
> > 
> > Mingming, this needs urgent consideration, please.  Note that I had to
> > make additional changes to ext4 due to the subsequent introduction of
> > the dirty_blocks counter.
> > 
> > 
> > Please read the below changelogs carefully and check that I have got my
> > head around this correctly - I may not have done.
> > 
> 
> 
> Hum... e8ced39d5e8911c662d4d69a342b9d053eaaac4e is probably following
> the wrong path, but I see the intent. Even in the 'nr_files' case, it could
> help to reduce excessive calls to percpu_counter_sum()
> 

We should fix this in 2.6.28 - right now percpu_counter_sum() is subtly
corrupting the counter's value.

I sent two revert patches which I hope to merge into 2.6.28.  Could you
guys please read/review/maybe-test them?

They will make ext4 as slow as it was in 2.6.26, but presumably that's
not a catastrophe.

> What we can do is to use two s64 counters (only in SMP):

We can do lots of things in 2.6.29.  Including just making ->counters
an array of atomic_t.

