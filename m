From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Date: Sun, 7 Dec 2008 20:42:22 -0800
Message-ID: <20081207204222.d811c00b.akpm@linux-foundation.org>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<20081207152821.GA9596@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org,
	stable@kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbYLHEnG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 7 Dec 2008 23:43:06 -0500
In-Reply-To: <20081207152821.GA9596@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(cc stable)

On Sun, 7 Dec 2008 10:28:21 -0500 Theodore Tso <tytso@mit.edu> wrote:

> On Sat, Dec 06, 2008 at 08:22:33PM -0800, Andrew Morton wrote:
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
> 
> I've looked the two patches which you've queued in the -mm branch, and
> they look correct to me.
> 
> The bugs fixed by these patches can potentially lead to filesystem
> corruption, since we ultimately use these fields to set the superblock
> values.  This in my mind makes them stable candidates at the very
> least, and if we weren't so late in the 2.6.28 cycle, I'd be strongly
> tempted to push them to Linus as a bugfix before the merge window.
> 
> Andrew, any strong objections for me to grab them for the ext4 tree?
> Or would you rather carry them?  I would prefer that they get pushed
> to Linus as soon as the merge window opens, which is one reason why
> I'd prefer carry them, but we can do this either way.
> 

I'm planning on sending them off to Linus for 2.6.28 this week,
assuming nobody can think of a plausible reason to not do that.

Now I didn't look _very_ closely at the chronology, but I think that
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch reverts
a post-2.6.27 change, and is not needed in stable.

revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
however reverts a pre-2.6.27 change, and should be merged into 2.6.27. 
This patch reverts the addition and use of
percpu_counter_sum_and_set(), which is racy and can corrupt the
counters.

However
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
won't apply to 2.6.27 because the dirty_blocks stuff was added and
generates rejects.

So if all the above is correct, I'd propose that if and when
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
hits mainline, we should ask the -stable guys to directly revert 

    commit e8ced39d5e8911c662d4d69a342b9d053eaaac4e
    Author: Mingming Cao <cmm@us.ibm.com>
    Date:   Fri Jul 11 19:27:31 2008 -0400

        percpu_counter: new function percpu_counter_sum_and_set

which should be all that 2.6.27.x needs.

Agree?  If so, can you please take care of getting that patch over to
stable@kernel.org?  (I added the cc:stable to the diff, so there's
probably nothing which you need to do..)
