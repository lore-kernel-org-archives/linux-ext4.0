From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] ext4: Reduce contention on s_orphan_lock
Date: Tue, 6 May 2014 13:49:00 +0200
Message-ID: <20140506114900.GF9291@quack.suse.cz>
References: <1398814353-11904-1-git-send-email-jack@suse.cz>
 <536414A8.2040506@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, T Makphaibulchoke <tmac@hp.com>,
	linux-ext4@vger.kernel.org
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34351 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbaEFLtD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 May 2014 07:49:03 -0400
Content-Disposition: inline
In-Reply-To: <536414A8.2040506@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-05-14 15:56:56, Thavatchai Makphaibulchoke wrote:
> On 04/29/2014 05:32 PM, Jan Kara wrote:
> > 
> >   Hello,
> > 
> >   so I finally got to looking into your patches for reducing contention
> > on s_orphan_lock. AFAICT these two patches (the first one is just a
> > small cleanup) should have the same speed gain as the patches you wrote
> > and they are simpler. Can you give them a try please? Thanks!
> 
> I applied your patch and ran aim7 on both the 80 and 120 core count
> machines.  There are aim7 workloads that your patch does show some
> performance improvement.  Unfortunately in general, it does not have the
> same performance level as my original patch, especially with high user
> count, 500 or more.
  Thanks for running the benchmarks!

> As for the hashed mutex used in my patch to serialize orphan operation
> within a single node, even if I agree with you that with existing code it
> is not required, I don't believe that you can count on that in the
> future.  I believe that is also your concern, as you also added comment
> indicating the requirement of the i_mutex in your patch.
  So I believe it is reasonable to require i_mutex to be held when orphan
operations are called. Adding / removing inode from orphan list is needed
when extending or truncating inode and these operations generally require
i_mutex in ext4. I've added the assertion so that we can catch a situation
when we either by mistake or intentionally grow a call site which won't
hold i_mutex. If such situation happens and we have good reasons why
i_mutex shouldn't be used there, then we can think about some dedicated
locks (either hashed or per inode ones).

> In terms of maintainability, I do not believe simply relying on warning
> in a comment is sufficient.  On top of that with this new requirement, we
> are unnecessarily coupling the orphan operations to i_mutex, adding more
> contention to it.  This would likely to cause performance regression, as
  We aren't adding *any* contention. I didn't have to add a single
additional locking of i_mutex because in all the necessary cases we are
holding i_mutex over the orphan operations anyway (or the inode isn't
reachable by other processes). So regarding per-inode locking, we are doing
strictly less work with my patch than with your patch. However you are
correct in your comments to my patch 2/2 that in your patch you handle
operations under the global s_orphan_lock better and that's probably what
causes the difference. I need to improve that for sure.

> my experiment in responding to your earlier comment on my patch did show
> some regression when using i_mutex for serialization of orphan operations
> within a single node (adding code to lock the if it is not already
> locked).
> 
> I still believe having a different mutex for orphan operation
> serialization is a better and safer alternative.
  Frankly I don't see why they would be better. They are marginally safer
by keeping the locking inside the orphan functions but the WARN_ON I have
added pretty much mitigates this concern and as I wrote above I actually
think using i_mutex not only works but also makes logical sense.

> From my experiment so
> far (I'm still verifying this), it may even help improving the
> performance by spreading out the contention on the s_orphan_mutex.
  So orphan operations on a single inode are serialized by i_mutex both
with your and with my patch. You add additional serialization by hashed
mutexes so now orphan operations for independent inodes get serialized as
well. It may in theory improve the performance by effectively making the
access to global s_orphan_lock less fair but for now I believe that other
differences in our patches is what makes a difference.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
