From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 1/2] mbcache: Remove unused features
Date: Thu, 22 Jul 2010 02:07:40 +0200
Message-ID: <201007220207.40940.agruen@suse.de>
References: <4C46FD67.8070808@redhat.com> <20100721202636.B94F83C539AA@imap.suse.de> <4F3D0C4D-BA6B-490E-B656-774578B3F67B@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-ext4" <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124Ab0GVAHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jul 2010 20:07:46 -0400
In-Reply-To: <4F3D0C4D-BA6B-490E-B656-774578B3F67B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From https://bugzilla.lustre.org/show_bug.cgi?id=22771#c24 :
> On our production system, the hash table contain 64 entries (6 bits) for a
> cache of 2307267 entries.
> A count in each list give a good load balance : number of entries vary
> between 35782 to 36496 while the optimal repartition is 2307267 / 64 =
> 36051.

Hehe, I like that sense of humor :)

On Thursday 22 July 2010 01:18:39 Andreas Dilger wrote:
> Is it possible to allow mbcache to be disabled, either for the whole
> kernel, on a per-filesystem basis, or adaptively if the cache hit rate is
> very low (any of these is fine, not all of them).

We could do that, but making the cache not degrade so badly would be a good 
idea in any case.  The number of buckets is currently fixed for ext[234] so it 
would make sense to either make that number dynamic or limit the maximum 
number of cache entries.  The latter will probably be good enough for most 
workloads.

> Attached is a patch that allows manually disabling mbcache on a
> per-filesystem basis with a mount option.

> I don't think fixing the mbcache to be more efficient (more buckets, more
> locks, etc) is really solving the problem which is that mbcache is adding
> overhead without value in these situations.

A mount option would be very ugly, but a kernel internal NO_MBCACHE flag 
sounds more acceptable to me.

> Better would be to
> automatically disable it if e.g. some hundreds or thousands of objects
> were inserted into the cache and there was < 1% cache hit rate.

This assumes that the workload won't change.

> That would help everyone, even those people who don't know they have a
> problem.

People who don't know they have a problem would also be helped by making the 
cache not degrade so badly, right?

Even better would be to use a more appropriate inode size, but you've pointed 
that out in the bug already.

Thanks,
Andreas
