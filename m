From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [RFC, PATCH] Avoid hot statistics cache line in ext4 extent
 cache
Date: Fri, 13 Apr 2012 14:06:03 -0400
Message-ID: <20120413180603.GF26332@thunk.org>
References: <20120323221715.GA6712@tassilo.jf.intel.com>
 <A3DE1F37-C0AB-4ACE-8D13-22DC8A21ED3C@dilger.ca>
 <20120324031357.GA5690@tassilo.jf.intel.com>
 <CAMQXfUcH-0Krg811msFVbC25qY1mPTdrMi8Rg-qJST=6B-s_5w@mail.gmail.com>
 <4F70F51F.8030405@linux.intel.com>
 <20120326235707.GC19489@thunk.org>
 <m2zkaiyzjl.fsf@firstfloor.org>
 <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Vivek Haldar <haldar@google.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tim.c.chen@linux.intel.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59300 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326Ab2DMSGJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Apr 2012 14:06:09 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFx8UsBEqK2KA_7D4YNGYrtcNaduvuEUcLfbRRjSXS_Xeg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 10:42:10AM -0700, Linus Torvalds wrote:
> 
> > Can we please revert fix it or revert
> > 556b27abf73833923d5cd4be80006292e1b31662 before release.
> 
> That commit ID doesn't make any sense, and doesn't seem to have
> anything to do with any statistics counters that your email talks
> about. So regardless, you'd need to explain why that commit causes the
> problems you talk about, I'm not going to revert a random commit that
> doesn't even look what you describe.
> 
> Ted?

I think Andi cited the wrong commit.  The commit in question is
77f4135f2a219a2127be6cc1208c42e6175b11dd, which first showed up in
2.6.39.  If you have a very fast (PCIe-attached would be required I
suspect) flash device, with a system with a large SMP box, and a
random-read benchmark which reads from large number of CPU's in
parallel, such that we thrash cache line containing
sbi->extent_cache_hits.

It makes sense that there is a problem here, and what had been
discussed was either (a) removing these counters entirely, or (b)
replacing them with a percpu counter.  At the moment these counters
aren't really worth it, although in the future when we replace the
single extent cache with a larger cache, the statistics would be more
interesting.

I just ran out of time before the 3.4 merge window, and quite frankly
I didn't think it was worth persuing this with a high urgency, since
(a) it's not a regression (the commit in question which added these
counters has been around since 2.6.39), and (b) in most circumstances
people it's not noticeable at all.

I'm willing to push commit to you to remove the counters for now, and
we'll probably add it back later using percpu counters if you think
it's worth making a change at this time --- or if Andi can explain why
he's treating this with a high degree of urgency.  Is there some
common use case that I'm missing which is being very badly impacted
with this cache-line thrashing?

Regards,

						- Ted
