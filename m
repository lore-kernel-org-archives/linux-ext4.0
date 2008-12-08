From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 7 Dec 2008 20:52:50 -0800
Message-ID: <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
	<20081207092854.f6bcbfae.akpm@linux-foundation.org>
	<493C0F40.7040304@cosmosbay.com>
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
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYLHEx1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 23:53:27 -0500
In-Reply-To: <493C0F40.7040304@cosmosbay.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 07 Dec 2008 19:00:32 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:

> Andrew Morton a __crit :
> > On Sun, 07 Dec 2008 14:28:00 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> > 
> >> Andrew Morton a __crit :
> >>> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com> wrote:
> >>>
> >>>> Eric Dumazet a __crit :
> >>>>
> >>>> 1) __percpu_counter_sum() is buggy, it should not write
> >>>> on per_cpu_ptr(fbc->counters, cpu), or another cpu
> >>>> could get its changes lost.
> >>>>
> >>>> __percpu_counter_sum should be read only (const struct percpu_counter *fbc),
> >>>> and no locking needed.
> >>> No, we can't do this - it will break ext4.
> >>>
> >>> Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
> >>> e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
> >>>
> >>> I suggest that what we do is to revert both those changes.  We can
> >>> worry about the possibly-unneeded spin_lock later, in a separate patch.
> >>>
> >>> It should have been a separate patch anyway.  It's conceptually
> >>> unrelated and is not a bugfix, but it was mixed in with a bugfix.
> >>>
> >>> Mingming, this needs urgent consideration, please.  Note that I had to
> >>> make additional changes to ext4 due to the subsequent introduction of
> >>> the dirty_blocks counter.
> >>>
> >>>
> >>> Please read the below changelogs carefully and check that I have got my
> >>> head around this correctly - I may not have done.
> >>>
> >>
> >> Hum... e8ced39d5e8911c662d4d69a342b9d053eaaac4e is probably following
> >> the wrong path, but I see the intent. Even in the 'nr_files' case, it could
> >> help to reduce excessive calls to percpu_counter_sum()
> >>
> > 
> > We should fix this in 2.6.28 - right now percpu_counter_sum() is subtly
> > corrupting the counter's value.
> > 
> > I sent two revert patches which I hope to merge into 2.6.28.  Could you
> > guys please read/review/maybe-test them?
> 
> Your revert patches have the same effect than my first patch : No writes
> in percpu_counter_sum()
> 
> I am lost here Andrew...
> 

heh.  Here's the problem...

The first patch which was added (pre-2.6.27) was "percpu_counter: new
function percpu_counter_sum_and_set".  This added the broken-by-design
percpu_counter_sum_and_set() function, **and used it in ext4**.

Later, during 2.6.28 development came the "percpu counter: clean up
percpu_counter_sum_and_set()" which propagated the
percpu_counter_sum_and_set() brokenness into percpu_counter_sum() as
well.

If we were to now merge your simple dont-modify-the-percpu-counters fix
then this would break ext4, because of the **and used it in ext4**,
above.

You see, ext4 stopped using the accurate/slow percpu_counter_sum() and
switched to percpu_counter_sum_and_set() because this new function
increases the accuracy of percpu_counter_read() in other parts of ext4.

Also, e8ced39d5e8911c662d4d69a342b9d053eaaac4e ("percpu_counter: new
function percpu_counter_sum_and_set") replaced a call to
percpu_counter_sum_positive() with a call to
percpu_counter_sum_and_set(), but there's nothing which prevents
percpu_counter_sum_and_set() from returning negative values, afacit.

