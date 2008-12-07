From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 07 Dec 2008 11:25:30 +0100
Message-ID: <1228645530.24126.2234.camel@twins>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:63766 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYLGKZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 05:25:44 -0500
In-Reply-To: <20081206202233.3b74febc.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-12-06 at 20:22 -0800, Andrew Morton wrote:
> On Wed, 03 Dec 2008 21:24:36 +0100 Eric Dumazet <dada1@cosmosbay.com>
> wrote:
> 
> > Eric Dumazet a __crit :
> > > Hi Andrew
> > > 
> > > While working on percpu_counter on net-next-2.6, I found
> > > a CPU unplug race in percpu_counter_destroy()
> > > 
> > > (Very unlikely of course)
> > > 
> > > Thank you
> > > 
> > > [PATCH] percpu_counter: fix CPU unplug race in
> percpu_counter_destroy()
> > > 
> > > We should first delete the counter from percpu_counters list
> > > before freeing memory, or a percpu_counter_hotcpu_callback()
> > > could dereference a NULL pointer.
> > > 
> > > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > > ---
> > > lib/percpu_counter.c |    4 ++--
> > > 1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > 
> > Well, this percpu_counter stuff is simply not working at all.
> > 
> > We added some percpu_counters to network tree for 2.6.29 and we get
> > drift bugs if calling __percpu_counter_sum() while some heavy duty
> > benches are running, on a 8 cpus machine
> > 
> > 1) __percpu_counter_sum() is buggy, it should not write
> > on per_cpu_ptr(fbc->counters, cpu), or another cpu
> > could get its changes lost.
> > 
> > __percpu_counter_sum should be read only (const struct
> percpu_counter *fbc),
> > and no locking needed.
> 
> No, we can't do this - it will break ext4.
> 
> Take a closer look at 1f7c14c62ce63805f9574664a6c6de3633d4a354 and at
> e8ced39d5e8911c662d4d69a342b9d053eaaac4e.
> 
> I suggest that what we do is to revert both those changes.  We can
> worry about the possibly-unneeded spin_lock later, in a separate
> patch.
> 
> It should have been a separate patch anyway.  It's conceptually
> unrelated and is not a bugfix, but it was mixed in with a bugfix.
> 
> Mingming, this needs urgent consideration, please.  Note that I had to
> make additional changes to ext4 due to the subsequent introduction of
> the dirty_blocks counter.
> 
> 
> Please read the below changelogs carefully and check that I have got
> my
> head around this correctly - I may not have done.
> 
> What a mess.

Thing is, as Eric pointed out, the sum_and_set() thing is fundamentally
broken. It's impossible to _set a percpu_counter.



