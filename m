From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: i_version, NFSv4 change attribute
Date: Wed, 25 Nov 2009 15:48:44 -0500
Message-ID: <20091125204843.GK32502@fieldses.org>
References: <20091122222047.GB21944@fieldses.org> <20091123114831.GA2532@thunk.org> <20091123164445.GB3292@fieldses.org> <1258999879.8700.17.camel@localhost> <20091123181951.GB5583@fieldses.org> <20091123185105.GC2183@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:45088 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759811AbZKYUr4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 25 Nov 2009 15:47:56 -0500
Content-Disposition: inline
In-Reply-To: <20091123185105.GC2183@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 01:51:05PM -0500, tytso@mit.edu wrote:
> Now, all of this having been said, Feodra 11 and 12 have been using
> ext4 as the default filesystem, and for generic desktop usage, people
> haven't been screaming about the increased CPU overhead implied by
> engaging the jbd2 machinery on every sys_write().
> 
> However, we have had a report that some enterprise database developers
> have noticed the increased overhead in ext4, and this is on our list
> of things that require some performance tuning.  Hence my comments
> about a mount option to adjust s_time_gran for the benefit of database
> workloads, and once we have that moun option, since enabling i_version
> would mean once again needing to update the inode at every single
> write(2) call, we would be back with the same problem.
> 
> Maybe we can find a way to be more clever about doing some (but not
> all) of the jbd2 work on each sys_write(), and deferring as much as
> possible to the commit handling.  We need to do some investigating to
> see if that's possible.  Even if it isn't, though, my gut tells me
> that we will probably be able to enable i_version by default for
> desktop workloads, and tell database server folks that they should
> mount with the mount options "noi_version,time_gran=1s", or some such.
> 
> I'd like to do some testing to confirm my intuition first, of course,
> but that's how I'm currently leaning.   Does that make sense?

I think so, thanks.

So do I have this todo list approximately right?:

	1. Use an atomic type instead of a spinlock for i_version, and
	do some before-and-after benchmarking of writes (following your
	suggestions in
	http://marc.info/?l=linux-ext4&m=125900130605891&w=2)

	2. Turn on i_version by default.  (At this point it shouldn't be
	making things any worse than the high-resolution timestamps
	are.)

	3. Find someone to run database benchmarks, and work on
	noi_version,time_gran=1s (or whatever) options for their case.

I wish I could volunteer at least for #1, but embarassingly don't have
much more than dual-core machines lying around right now to test with.

--b.
