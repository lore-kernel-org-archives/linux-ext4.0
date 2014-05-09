From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH 0/2] ext4: Reduce contention on s_orphan_lock
Date: Fri, 09 May 2014 00:24:50 -0600
Message-ID: <536C74B2.5010107@hp.com>
References: <1398814353-11904-1-git-send-email-jack@suse.cz> <536414A8.2040506@hp.com> <20140506114900.GF9291@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: T Makphaibulchoke <tmac@hp.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g2t2352.austin.hp.com ([15.217.128.51]:12698 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaEIG01 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 May 2014 02:26:27 -0400
In-Reply-To: <20140506114900.GF9291@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/06/2014 05:49 AM, Jan Kara wrote:
> On Fri 02-05-14 15:56:56, Thavatchai Makphaibulchoke wrote:
>   So I believe it is reasonable to require i_mutex to be held when orphan
> operations are called. Adding / removing inode from orphan list is needed
> when extending or truncating inode and these operations generally require
> i_mutex in ext4. I've added the assertion so that we can catch a situation
> when we either by mistake or intentionally grow a call site which won't
> hold i_mutex. If such situation happens and we have good reasons why
> i_mutex shouldn't be used there, then we can think about some dedicated
> locks (either hashed or per inode ones).
> 

In earlier version of the patch, it is suggested that per inode mutex is too much of an overhead.  In addition, adding a mutex to the ext4_inode struct would increase its size above the cache size.

>   We aren't adding *any* contention. I didn't have to add a single
> additional locking of i_mutex because in all the necessary cases we are
> holding i_mutex over the orphan operations anyway (or the inode isn't
> reachable by other processes). So regarding per-inode locking, we are doing
> strictly less work with my patch than with your patch. However you are
> correct in your comments to my patch 2/2 that in your patch you handle
> operations under the global s_orphan_lock better and that's probably what
> causes the difference. I need to improve that for sure.
> 

Sorry for not being clear.  Yes, I agree, with existing code, you are not adding any contention.  What I'm trying to say is that with your patch making i_mutex an implicit requirement of an orphan operation, any future ext4 operation  requiring an orphan add/delete will also have to acquire i_mutex regardless of whether it needs i_mutex.  Though this may not likely to happen, it could potentially add unnecessary contention to i_mutex.

Again, this may not likely to happen, but any change in i_mutex usages in the caller could have direct impact on your change.

>   Frankly I don't see why they would be better. They are marginally safer
> by keeping the locking inside the orphan functions but the WARN_ON I have
> added pretty much mitigates this concern and as I wrote above I actually
> think using i_mutex not only works but also makes logical sense.
> 

Yes, the WARN_ON is good safe gaurd against any i_mutex violation.  Personally I would prefer a BUG_ON.  But as mentioned above, any change in the caller or some future usage of orphan operations may require a revisit of the WARN_ON.

Though my patch is doing more work and is only marginal safer with existing code, it would be safer with regards to any further change.  In addition, since i_mutex is not required, there may be a chance (sorry I did not have chance to verify with the source yet)for the caller to drop the i_mutex earlier for possible further improvement.

Despite what I've said, I would agree it would make sense to take advantage of the fact either the caller already held i_mutex or it is safe due to no other accesses possible to the inode for the performance reason. Unfotunately (it may be coincidental) from the aim7 results from my patch with the hashed mutex acquire/release removed, not only no performance improvement is detected, there is significant regression in several workloads on two of my higher thread count platforms tested.

With all the performance numbers I'm getting, plus the fact that at least it is marginal safer, I'm still believe the hashed mutex is the way to go.


Thanks,
Mak.


>   So orphan operations on a single inode are serialized by i_mutex both
> with your and with my patch. You add additional serialization by hashed
> mutexes so now orphan operations for independent inodes get serialized as
> well. It may in theory improve the performance by effectively making the
> access to global s_orphan_lock less fair but for now I believe that other
> differences in our patches is what makes a difference.
> 
> 								Honza
> 


